# Yeast Server

#the while loop
whileLoop <- function(input, currentCellCount, desiredCells, totalVol, nextVol){

  
  
        while(currentCellCount < desiredCells){
                
                totalVol <- totalVol + nextVol
                nextVol <- nextVol*2
                currentCellCount <- currentCellCount*2
                
                
                if(currentCellCount*2 > desiredCells){
                        remainder <- ifelse(currentCellCount == 0,0,desiredCells/currentCellCount)
                        nextVol <- (remainder-1)*nextVol/2
                        totalVol <- totalVol + nextVol
                        currentCellCount <- currentCellCount*remainder  
                }
        }
        totalVol
                
}

yeastServer <- function(input, output, session){
      
  
  ## ----- Load section ----- ##
  #Default
  yeastRVs <- reactiveValues()
  
  yeastRVs$values <- data.frame(Recipe = "New",
                                    Name = "Brewferm Lager Yeast",
                                    Attenuation = 0,
                                    ABV = 0,
                                    OG = 0,
                                    FG = 0, 
                                    Init_Cells = 100.0,
                                    Pitched_Cells = 0,
                                    Liters_for_Starter = 0,
                                stringsAsFactors = F)

  
  
  #On Load do this
  observeEvent(input$load,{
    
    #Set path for DB
    sqlitePath <- "Database/Recipes.sqlite"
    # Connect to the database
    db <- dbConnect(SQLite(), sqlitePath)
    # Construct the fetching query
    query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Yeast", input$recipe)
    # Submit the fetch query
    data <- dbGetQuery(db, query); 
    # Damage Control: Filter out this weird character (Â) and then set the encoding to UTF-8 
    #data$Ingredient <- gsub(pattern = "Â",replacement = "",x = data$Ingredient) # This is a HACK...find a more elegant solution
    #Encoding(data$Ingredient) <- "UTF-8"
    #Disconnect
    dbDisconnect(db)
    yeastRVs$values <- 0 # Allows to load more than once
    yeastRVs$values <- data
  
  })
  
  
  output$yeast <- renderUI({selectInput(inputId = "yeast", label = "Yeast", selected = yeastRVs$values$Name[1], choices = Yeast$YeastStrain)})

  output$attenuation <- renderUI({numericInput(inputId = "attenuation", label = "Actual Attenuation (%)", value = yeastRVs$values$Attenuation[1]) })
  output$defaultAttenuation <- renderText({
    
    attenuation()
    
  })
  
  output$ABV <- renderUI({numericInput(inputId = "ABV", label = "Actual ABV (%)", value = yeastRVs$values$ABV[1]) })
  output$calculatedABV <- renderText({ ABV() })
  output$startYeastCells <- renderUI({numericInput(inputId = "startYeastCells", label = "Initial Yeast Cells (B)", value = yeastRVs$values$Init_Cells[1]) })
  
  
  attenuation <<- reactive({
    
    if(is.null(input$yeast)){
      yeastRVs$values$Attenuation[1]
      
    }else{
      
      Attenuation <- filter(Yeast, YeastStrain == input$yeast) %>% select(ATT)
      Attenuation$ATT[1]
      
    }    
    
    
  })
        
        
    ABV <<- reactive({
      #Calc OG
      lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
      higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000
      
      OG <- mean(c(lowerRange,higherRange))/1000 + 1
      ATT <- input$attenuation
      FG <- OG-(ATT/100)*(OG-1)
      ABV = (1.05/0.79)*((OG-FG)/FG)*100
    })
    
    
        
    output$actualOG <- renderUI({numericInput(inputId = "OG", label = "Actual OG", value = yeastRVs$values$OG[1]) })
    output$actualFG <- renderUI({numericInput(inputId = "FG", label = "Actual FG", value = yeastRVs$values$FG[1]) })
        
        
        FG <<- reactive ({
          #Calc OG
          lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
          higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000
          
          OG <- mean(c(lowerRange,higherRange))/1000 + 1
          ATT <- input$attenuation
          FG <- OG-(ATT/100)*(OG-1)
          
        })
        
        output$styleOG <- renderText({
                #Calc OG from style ranges
                lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
                higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000      
                
                avgOG <- mean(c(lowerRange, higherRange))
                
                paste(avgOG/1000+1)
                #paste(lowerRange/1000+1,"-",higherRange/1000+1)
        })
        
        output$styleFG <- renderText({
          #Calc FG from style ranges
          lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = FGRangeLow)) - 1)*1000
          higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = FGRangeHigh)) - 1)*1000      
          
          avgOG <- mean(c(lowerRange, higherRange))
          
          paste(avgOG/1000+1)
          
        })
        
        cellsNeeded <<- reactive({
                  
                #Calc OG
                lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
                higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000
                
                OG <- mean(c(lowerRange,higherRange))
                degreePlato <- OG/4
                
                # Recommended that you use (1e6 cells)/(degreePlate*milliliter) or 1B/(P*L)
                batchSize <- input$batchSize
                literBatchSize <- batchSize*3.785 #Liters in a gallon
                cellDensity <- (1e9*degreePlato*literBatchSize)
        })
        
        output$cellsNeeded <- renderText({cellsNeeded()/1e9}) #show in Billions
        output$actualPitched <- renderUI({numericInput(inputId = "actualPitched", label = "Actual Cells Pitched (B)", value = yeastRVs$values$Pitched_Cells[1]) })
        output$starterUsed <- renderUI({numericInput(inputId = "starterUsed", label = "Liters Used (L)", value = yeastRVs$values$Liters_for_Starter[1]) })
        
        litersNeeded <<- reactive({
                
                if(is.null(input$startYeastCells)){
                  startingCells <- 100*1e9
                }else{
                  startingCells <- input$startYeastCells*1e9
                }
          
                desiredCells <- cellsNeeded()
                currentCellCount <- startingCells
                
                rateForYeast <- 1/(50e9) # L/Billion to double 
                
                
                initialVol <- rateForYeast*startingCells # L
                nextVol <- initialVol
                totalVol <- 0
                
                
                
                if(currentCellCount*2 > desiredCells){
                        remainder <- ifelse(currentCellCount == 0,0,desiredCells/currentCellCount)
                        nextVol <- (remainder-1)*nextVol/2
                        totalVol <- totalVol + nextVol
                        currentCellCount <- currentCellCount*remainder 
                        
                        #Return totalVol
                        totalVol
                }else{
                        #Returns totalVol
                        whileLoop(input, currentCellCount, desiredCells, totalVol, nextVol)
                  print("line182")
                  print(currentCellCount)
                  print(desiredCells)
                  print(totalVol)
                  print(nextVol)
                        
                }
                
        })
        
        
        output$litersNeeded <- renderText({
                litersNeeded()
        })
}


