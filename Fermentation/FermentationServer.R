# Fermentation Server

fermentationServer <- function(input, output){
  
  ## ----- Load section ----- ##
  #Default
  fermentationRVs <- reactiveValues()
  fermentationRVs$values <- data.frame(Recipe = "New",
                                       Days1 = 7,
                                       Temp1 = 70,
                                       Days2 = 7,
                                       Temp2 = 70,
                                       Days3 = 7,
                                       Temp3 = 70,
                                       Days4 = 7,
                                       Temp4 = 70,
                                       Days5 = 7,
                                       Temp5 = 70,
                                       stringsAsFactors = F)
  
  #Testing
  observeEvent(input$load,{
    # print(fermentationRVs$ingredients)
    #Set path for DB
    sqlitePath <- "Database/Recipes.sqlite"
    # Connect to the database
    db <- dbConnect(SQLite(), sqlitePath)
    # Construct the fetching query
    query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Fermentation", input$recipe)
    # Submit the fetch query
    data <- dbGetQuery(db, query); #print(data)#...debug
    # Damage Control: Filter out this weird character (Â) and then set the encoding to UTF-8 
    #data$Ingredient <- gsub(pattern = "Â",replacement = "",x = data$Ingredient) # This is a HACK...find a more elegant solution
    # Encoding(data$Ingredient) <- "UTF-8"
    #Disconnect
    dbDisconnect(db)
    data
    
    fermentationRVs$values <- 0 # Allows to load more than once
    fermentationRVs$values <- data
  })
  
  output$days1 <- renderUI({numericInput(inputId = "days1",label = "Days",value = fermentationRVs$values$Days1[1]) })
  output$days2 <- renderUI({numericInput(inputId = "days2",label = "Days",value = fermentationRVs$values$Days2[1]) })
  output$days3 <- renderUI({numericInput(inputId = "days3",label = "Days",value = fermentationRVs$values$Days3[1]) })
  output$days4 <- renderUI({numericInput(inputId = "days4",label = "Days",value = fermentationRVs$values$Days4[1]) })
  output$days5 <- renderUI({numericInput(inputId = "days5",label = "Days",value = fermentationRVs$values$Days5[1]) })
  
  output$fermentationFirstTemp <- renderUI({sliderInput(inputId = "fermentationFirstTemp", label = "First Temp", min = 40, max = 80, value = fermentationRVs$values$Temp1[1])})
  output$fermentationSecondTemp <- renderUI({sliderInput(inputId = "fermentationSecondTemp", label = "Second Temp", min = 40, max = 80, value = fermentationRVs$values$Temp2[1])})
  output$fermentationThirdTemp <- renderUI({sliderInput(inputId = "fermentationThirdTemp", label = "Third Temp", min = 40, max = 80, value = fermentationRVs$values$Temp3[1])})
  output$fermentationFourthTemp <- renderUI({sliderInput(inputId = "fermentationFourthTemp", label = "Fourth Temp", min = 40, max = 80, value = fermentationRVs$values$Temp4[1])})
  output$fermentationFifthTemp <- renderUI({sliderInput(inputId = "fermentationFifthTemp", label = "Fifth Temp", min = 40, max = 80, value = fermentationRVs$values$Temp5[1])})
  
  
  
  fermentationPlot <<- reactive({
            
          
            
          listOfInputs <- c(input$days1,input$days2,input$days3,input$days4,input$days5,input$fermentationFirstTemp,input$fermentationSecondTemp,input$fermentationThirdTemp,input$fermentationFourthTemp,input$fermentationFifthTemp)
          if(any(is.null(listOfInputs))){
            
              days1 <- 7
              days2 <- 7
              days3 <- 7
              days4 <- 7
              days5 <- 7
              
              fermentationFirstTemp <- 70
              fermentationSecondTemp <- 70
              fermentationThirdTemp <- 70
              fermentationFourthTemp <- 70
              fermentationFifthTemp <- 70
              
          }else{
                
              days1 <- input$days1
              days2 <- input$days2
              days3 <- input$days3
              days4 <- input$days4
              days5 <- input$days5
              
              fermentationFirstTemp <- input$fermentationFirstTemp
              fermentationSecondTemp <- input$fermentationSecondTemp
              fermentationThirdTemp <- input$fermentationThirdTemp
              fermentationFourthTemp <- input$fermentationFourthTemp
              fermentationFifthTemp <- input$fermentationFifthTemp
              
              
          }
          
          
          days1 <- 1:days1 #days
          days2 <- (max(days1)+1):(max(days1)+days2) #days
          days3 <- (max(days2)+1):(max(days2)+days3) #days
          days4 <- (max(days3)+1):(max(days3)+days4) #days
          days5 <- (max(days4)+1):(max(days4)+days5) #days
          
          days <- c(days1,days2,days3,days4,days5)
          
          tempFirstTemp <- rep(fermentationFirstTemp,length(days1))
          tempSecondTemp <- rep(fermentationSecondTemp,length(days2)) 
          tempThirdTemp <- rep(fermentationThirdTemp,length(days3))
          tempFourthTemp <- rep(fermentationFourthTemp,length(days4))
          tempFifthTemp <- rep(fermentationFifthTemp,length(days5))
          
          temp <- c(tempFirstTemp,tempSecondTemp,tempThirdTemp,tempFourthTemp,tempFifthTemp)
          
          fermentationDF <- data.frame(Days = days, Temp = temp)
          
          fermentationGraph <- ggplot(fermentationDF, aes(Days, Temp))
          #group = Volumes, color = Volumes))
          fermentationGraph + geom_line(size = 2) + ggtitle("Fermentation")
  })
        
  output$fermentationPlot <- renderPlot({fermentationPlot()})
}