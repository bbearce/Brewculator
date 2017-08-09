# Water Server

waterServer <- function(input, output){
        
        ## ----- Load section ----- ##
        #Default
        waterRVs <- reactiveValues()
        waterRVs$values <- data.frame(Recipe = "New",
                                      Mash_Thickness = 1.25,
                                      Grain_Abs_Factor = 0.133)
  
        #On Load do this
        observeEvent(input$load,{
          
          #Set path for DB
          sqlitePath <- "Database/Recipes.sqlite"
          # Connect to the database
          db <- dbConnect(SQLite(), sqlitePath)
          # Construct the fetching query
          query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Water", input$recipe)
          # Submit the fetch query
          data <- dbGetQuery(db, query); 
          # Damage Control: Filter out this weird character (Â) and then set the encoding to UTF-8 
          #data$Ingredient <- gsub(pattern = "Â",replacement = "",x = data$Ingredient) # This is a HACK...find a more elegant solution
          #Encoding(data$Ingredient) <- "UTF-8"
          #Disconnect
          dbDisconnect(db)
          waterRVs$values <- 0 # Allows to load more than once
          waterRVs$values <- data
        })
        
        #Output objects
        
        output$waterMashThickness <- renderUI({numericInput(inputId = "waterMashThickness", label = "Mash Thickness (Qts/Lb):", value = waterRVs$values$Mash_Thickness[1])})
        output$grainAbsorptionFactor <- renderUI({numericInput(inputId = "grainAbsorptionFactor", label = "Grain Abs. Factor (Gal/Lb):", value = waterRVs$values$Grain_Abs_Factor[1])})
        
        output$waterTotalWaterNeeded <- renderText({
                TWN()
        })
        
        output$waterGrainLoss <- renderText({
                grainLoss()
        })
        
        output$waterEquipLoss <- renderText({
                EL()
        })
        
        output$waterEvapLoss <- renderText({
                EvL()
        })
        
        
        output$waterBatchSize <- renderText({
                BS()
        })
        
        waterMashThickness <<- reactive({
          
          if(is.null(input$waterMashThickness)){
            mashThickness <- 1.25
          }else{
            mashThickness <- input$waterMashThickness
          }
          
        })
        
        waterMashVol <<- reactive({waterMashThickness()*totalGrain()/4}) #[Qts/Lbs]*[Lbs]*[1Gal/4Qts] = Gal
        
        output$waterMashVol <- renderText({ waterMashVol() })
        
        spargeVol <<- reactive({TWN()-(waterMashThickness()*totalGrain()/4) - Wa() })
        #Wa() is from Mash and is the mash out volume. It is apart of "rinse" water but is separate from mashout
        #Mashout is for raising temp to 170 and sparge is for the lauter tun.
        
        output$waterSpargeVol <- renderText({
                spargeVol() 
        })
        
        output$waterGraph <- renderPlot({
              #Just here to see what the values are in consol
                
#                 print("GL")
#                 print(grainLoss())
#                 print("EL")
#                 print(EL()) 
#                 print("BS")
#                 print(BS())
#                 print("EvL")
#                 print(EvL()) 
#                 print("TWN")
#                 print(TWN()) 
                
                waterData <- data.frame(x = factor(c("TWN",
                                                     "PostMash",
                                                     "PostSparge",
                                                     "PostBoil",
                                                     "Cooling",
                                                     "Fermentation"),
                                                   ordered = T,
                                                   levels = c("TWN",
                                                              "PostMash",
                                                              "PostSparge",
                                                              "PostBoil",
                                                              "Cooling",
                                                              "Fermentation")),
                                        y = c(TWN(),
                                              TWN()-grainLoss(),
                                              TWN()-grainLoss()-mashLoss(),
                                              TWN()-grainLoss()-mashLoss()-lauterLoss(),
                                              TWN()-grainLoss()-mashLoss()-lauterLoss()-kettleLoss()-EvL(),
                                              TWN()-grainLoss()-mashLoss()-lauterLoss()-kettleLoss()-EvL()-fermentationLoss())
                                        )
                # print(waterData)
                plot <- ggplot(data = waterData, aes(x,y))
                plot + geom_bar(stat = "identity", fill = I("grey50")) +
                       ggtitle("Total Water Needed")
                
                

        })
        
        #Constants that are dynamic
        grainLoss <- reactive({
        
        # Handling initial NULL condition 
        if(is.null(input$grainAbsorptionFactor)){
          grainAbsorptionFactor <- 1.25
        }else{
          grainAbsorptionFactor <- input$grainAbsorptionFactor
        }
          
          totalGrain()*grainAbsorptionFactor*(1-input$shrink/100)
        })
        
        lauterLoss <- reactive({
          input$lauterTunDeadSpace*(1-input$shrink/100)
        })
        mashLoss <- reactive({
          input$mashTunDeadSpace*(1-input$shrink/100)
        })
        kettleLoss <- reactive({
          input$kettleDeadSpace
        })
        fermentationLoss <- reactive({
          input$fermentationTankLoss
        })
        BS <- reactive({
          input$batchSize      
        })
        EvL <- reactive({
          (BS()+kettleLoss()+fermentationLoss())*((input$boilTime/60)*(input$evap/100)/(1-(input$boilTime/60)*(input$evap/100)))
        })
        EL <- reactive({
          lauterLoss() + mashLoss() + kettleLoss() + fermentationLoss()
        })
        TWN <- reactive({
          grainLoss() + EL() + BS() + EvL()
        })
        
}