# Step Mash Server

stepMashServer <- function(input, output){
    
  ## ----- Load section ----- ##
  #Default
  mashRVs <- reactiveValues()
  mashRVs$values <- data.frame(Recipe = "New",
                               Init_Grain_Temp = 69,
                               Infusion_Temp = 164.0,
                               Sacc_Rest_Temp = 152.0,
                               Mash_Duration = 60,
                               Mash_Volume_Gal = 0.0,
                               Mash_Thickness = 1.25,
                               Mash_Out_Vol = 0.0)
  
  #On Load do this
  observeEvent(input$load,{
    
    #Set path for DB
    sqlitePath <- "Database/Recipes.sqlite"
    # Connect to the database
    db <- dbConnect(SQLite(), sqlitePath)
    # Construct the fetching query
    query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Mash", input$recipe)
    # Submit the fetch query
    data <- dbGetQuery(db, query); 
  
    #Disconnect
    dbDisconnect(db)
    mashRVs$values <- 0 # Allows to load more than once
    mashRVs$values <- data
  })
  
  output$mashGrainTemp <- renderUI({numericInput(inputId = "mashGrainTemp",label = paste0("Grain Temp(","\U00B0","F)"),value = mashRVs$values$Init_Grain_Temp[1])})
  output$mashSaccRestTemp <- renderUI({numericInput(inputId = "mashSaccRestTemp",label = paste0("Sacc. Rest Temp(","\U00B0","F)"),value = mashRVs$values$Sacc_Rest_Temp[1])})
  output$mashDuration <- renderUI({numericInput(inputId = "mashDuration",label = paste0("Sacc Rest Duration (min)"),value = mashRVs$values$Mash_Duration[1])})
  
  mashGrainTemp <<- reactive({
    
    if(is.null(input$mashGrainTemp)){
      mashGrainTemp <- 69
    }else{
      mashGrainTemp <- input$mashGrainTemp
    }
    
  })
  
  mashSaccRestTemp <<- reactive({
    
    if(is.null(input$mashSaccRestTemp)){
      mashSaccRestTemp <- 152.0
    }else{
      mashSaccRestTemp <- input$mashSaccRestTemp
    }
    
  })
  
  mashDuration <<- reactive({
    
    if(is.null(input$mashDuration)){
      mashDuration <- 60
    }else{
      mashDuration <- input$mashDuration
    }
    
  })
  
    output$mashThickness <- renderText({waterMashThickness()}) #From water ui
    
    mashVol <<- reactive({waterMashVol()})
    
    output$mashMashVol <- renderText({
      mashVol()
    })
    output$boilTime <- renderText({input$boilTime}) #From main panel ui
    output$totalGrain <- renderText({totalGrain()}) #From fermentables server
    
    Tw <<- reactive({
        #Tw is temperature of water being infused
        Tw <- (0.2/waterMashThickness())*(mashSaccRestTemp() - mashGrainTemp())+mashSaccRestTemp()
    })
    
    output$infusionTemp <- renderText({
        Tw()
    }) 

    Wa <<- reactive({
      #Wa is water added to mash out
      Wa <- (170 - mashSaccRestTemp())*(0.2*totalGrain() + mashVol())/(212 - 170)
    })
    
    output$mashOutVolume <- renderText({Wa()})
    
   stepMashPlot <<- reactive({
     
     
     #times are in minutes
     grainSittingTime <- 5
     mashIn <- 3
     mashTime <- mashDuration()
     mashOut <- 3
     sparge <- 30
     boilRise <- 45
     boil <- 60
     
     time <- c(1:(grainSittingTime),
               (grainSittingTime+1):(grainSittingTime+mashIn),
               (grainSittingTime+mashIn+1):(grainSittingTime+mashIn+mashTime),
               (grainSittingTime+mashIn+mashTime+1):(grainSittingTime+mashIn+mashTime+mashOut),
               (grainSittingTime+mashIn+mashTime+mashOut+1):(grainSittingTime+mashIn+mashTime+mashOut+sparge),
               (grainSittingTime+mashIn+mashTime+mashOut+sparge+1):(grainSittingTime+mashIn+mashTime+mashOut+sparge+boilRise),
               (grainSittingTime+mashIn+mashTime+mashOut+sparge+boilRise+1):(grainSittingTime+mashIn+mashTime+mashOut+sparge+boilRise+boil)) 
     
     mashTemp <- c(rep(mashGrainTemp(), grainSittingTime),
                   seq(mashGrainTemp(), mashSaccRestTemp(), length.out = mashIn),
                   rep(mashSaccRestTemp(), mashTime),
                   seq(mashSaccRestTemp(), 170, length.out = mashOut),
                   rep(170, sparge),
                   seq(170, 212, length.out = boilRise),
                   rep(212, boil))
     infusionTemp <- c(rep(Tw(), grainSittingTime),
                       seq(Tw(), mashSaccRestTemp(), length.out = mashIn),
                       rep(NA, mashTime),
                       rep(NA, mashOut),
                       rep(NA, sparge),
                       rep(NA, boilRise),
                       rep(NA, boil))
     mashOutTemp <- c(rep(NA, grainSittingTime),
                      rep(NA, mashIn),
                      rep(NA, mashTime-5),
                      rep(212,5),
                      seq(212, 170, length.out = mashOut),
                      rep(NA, sparge),
                      rep(NA, boilRise),
                      rep(NA, boil))
     
     data <- data.frame(Time = time,
                        mashTemp = mashTemp,
                        infusionTemp = infusionTemp,
                        mashOutTemp = mashOutTemp)
     
     dataLong <- data %>% gather("Volumes", "Temp", 2:4)
     
     mashGraph <- ggplot(dataLong, aes(Time, Temp, group = Volumes, color = Volumes))
     mashGraph + geom_line(size = 2) 
     
   })
    
    output$stepMashPlot <- renderPlot({
      stepMashPlot()
        })
}