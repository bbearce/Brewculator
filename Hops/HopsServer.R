# Hops Server

# Initialize average alpha acid function
avgAlphaAcid <- function(input, hopChoice){
  
  # Error handling initial condition
  if(is.null(hopChoice)){
    defaultAlpha <- 0
    
  }else if(hopChoice == "None"){
      defaultAlpha <- 0
  }else{
    alphaLow <- Hops %>% 
      filter(Hops == hopChoice) %>%
      select(AlphaLow) %>%
      as.numeric()
    
    alphaHigh <- Hops %>% 
      filter(Hops == hopChoice) %>%
      select(AlphaHigh) %>%
      as.numeric()
    
    defaultAlpha <- mean(c(alphaLow, alphaHigh))
  }
  defaultAlpha
}

utilization <- function(input, boilTime, boilGravity){
        func_of_gravity <- 1.65*0.000125^(boilGravity-1)
        func_of_time <- (1-exp(-0.04*boilTime))/4.15
        func_of_gravity*func_of_time
}

hopsServer <- function(input, output, session){
        
        ## ----- Load section ----- ##
        #Default
        hopsRVs <- reactiveValues()
        hopsRVs$ingredients <- data.frame(Recipe = rep("New",5),
                                          Name = rep("None",5),
                                          Weight_Oz = rep(0,5),
                                          Boil_Time_Min = rep(0,5),
                                          Alpha_Acid_Content = rep(0,5),
                                          Utilization = rep(0,5),
                                          IBU = rep(0,5))
        defaultAlphaAcid <- reactive({
        data.frame(Alpha_Acid_Content = c(avgAlphaAcid(input, input$Hops1),
                                          avgAlphaAcid(input, input$Hops2),
                                          avgAlphaAcid(input, input$Hops3),
                                          avgAlphaAcid(input, input$Hops4),
                                          avgAlphaAcid(input, input$Hops5))
                   )
        })
        
        
        #On Load do this
        observeEvent(input$load,{
            
            #Set path for DB
            sqlitePath <- "Database/Recipes.sqlite"
            # Connect to the database
            db <- dbConnect(SQLite(), sqlitePath)
            # Construct the fetching query
            query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Hops", input$recipe)
            # Submit the fetch query
            data <- dbGetQuery(db, query); 
            # Damage Control: Filter out this weird character (Â) and then set the encoding to UTF-8 
            #data$Ingredient <- gsub(pattern = "Â",replacement = "",x = data$Ingredient) # This is a HACK...find a more elegant solution
            #Encoding(data$Ingredient) <- "UTF-8"
            #Disconnect
            dbDisconnect(db)
            hopsRVs$ingredients <- 0 # Allows to load more than once
            hopsRVs$ingredients <- data
        })
       
        # Hop Hops -----
  
        output$Hops1 <- renderUI({selectInput(inputId = "Hops1", label = "Hops", selected = hopsRVs$ingredients$Name[1], choices = Hops$Hops)})
        output$Hops2 <- renderUI({selectInput(inputId = "Hops2", label = NULL, selected = hopsRVs$ingredients$Name[2], choices = Hops$Hops)})
        output$Hops3 <- renderUI({selectInput(inputId = "Hops3", label = NULL, selected = hopsRVs$ingredients$Name[3], choices = Hops$Hops)})
        output$Hops4 <- renderUI({selectInput(inputId = "Hops4", label = NULL, selected = hopsRVs$ingredients$Name[4], choices = Hops$Hops)})
        output$Hops5 <- renderUI({selectInput(inputId = "Hops5", label = NULL, selected = hopsRVs$ingredients$Name[5], choices = Hops$Hops)})
   
        # Hop Weight(Oz) -----
         
         output$Weight1 <- renderUI({numericInput(inputId = "Weight1",label = "Weight (Oz)",value = hopsRVs$ingredients$Weight_Oz[1])})
         output$Weight2 <- renderUI({numericInput(inputId = "Weight2",label = NULL,value = hopsRVs$ingredients$Weight_Oz[2])})
         output$Weight3 <- renderUI({numericInput(inputId = "Weight3",label = NULL,value = hopsRVs$ingredients$Weight_Oz[3])})
         output$Weight4 <- renderUI({numericInput(inputId = "Weight4",label = NULL,value = hopsRVs$ingredients$Weight_Oz[4])})
         output$Weight5 <- renderUI({numericInput(inputId = "Weight5",label = NULL,value = hopsRVs$ingredients$Weight_Oz[5])})
  
        # Hop Alpha Acid -----
        
        output$hopsAlphaAcidOne <- renderUI({numericInput(inputId = "AlphaAcid1",label = "AlphaAcid (%)",value = hopsRVs$ingredients$Alpha_Acid_Content[1])})
        output$hopsAlphaAcidTwo <- renderUI({numericInput(inputId = "AlphaAcid2",label = NULL,value = hopsRVs$ingredients$Alpha_Acid_Content[2])})
        output$hopsAlphaAcidThree <- renderUI({numericInput(inputId = "AlphaAcid3",label = NULL,value = hopsRVs$ingredients$Alpha_Acid_Content[3])})
        output$hopsAlphaAcidFour <- renderUI({numericInput(inputId = "AlphaAcid4",label = NULL,value = hopsRVs$ingredients$Alpha_Acid_Content[4])})
        output$hopsAlphaAcidFive <- renderUI({numericInput(inputId = "AlphaAcid5",label = NULL,value = hopsRVs$ingredients$Alpha_Acid_Content[5])})
        
          #Defaults
          AA1 <- reactive({avgAlphaAcid(input, input$Hops1)})
          AA2 <- reactive({avgAlphaAcid(input, input$Hops2)})
          AA3 <- reactive({avgAlphaAcid(input, input$Hops3)})
          AA4 <- reactive({avgAlphaAcid(input, input$Hops4)})
          AA5 <- reactive({avgAlphaAcid(input, input$Hops5)})
         
          output$hopsDefaultAlphaAcidOne <- renderText({defaultAlphaAcid()$Alpha_Acid_Content[1]})
          output$hopsDefaultAlphaAcidTwo <- renderText({defaultAlphaAcid()$Alpha_Acid_Content[2]})
          output$hopsDefaultAlphaAcidThree <- renderText({defaultAlphaAcid()$Alpha_Acid_Content[3]})
          output$hopsDefaultAlphaAcidFour <- renderText({defaultAlphaAcid()$Alpha_Acid_Content[4]})
          output$hopsDefaultAlphaAcidFive <- renderText({defaultAlphaAcid()$Alpha_Acid_Content[5]})
          
        
        # Hop Boil Time (Oz) -----
        
        output$BoilTime1 <- renderUI({numericInput(inputId = "BoilTime1",label = "BoilTime (min)",value = hopsRVs$ingredients$Boil_Time_Min[1])})
        output$BoilTime2 <- renderUI({numericInput(inputId = "BoilTime2",label = NULL,value = hopsRVs$ingredients$Boil_Time_Min[2])})
        output$BoilTime3 <- renderUI({numericInput(inputId = "BoilTime3",label = NULL,value = hopsRVs$ingredients$Boil_Time_Min[3])})
        output$BoilTime4 <- renderUI({numericInput(inputId = "BoilTime4",label = NULL,value = hopsRVs$ingredients$Boil_Time_Min[4])})
        output$BoilTime5 <- renderUI({numericInput(inputId = "BoilTime5",label = NULL,value = hopsRVs$ingredients$Boil_Time_Min[5])})
        
        # Hop Utilization -----
        
        hopsUtilization1 <<- reactive({utilization(input, input$BoilTime1, boilGravity())*100})
        
        output$hopsUtilization1 <- renderText({hopsUtilization1()})
        
        
        hopsUtilization2 <<- reactive({utilization(input, input$BoilTime2, boilGravity())*100})
        
        output$hopsUtilization2 <- renderText({hopsUtilization2()})
        
        
        hopsUtilization3 <<- reactive({utilization(input, input$BoilTime3, boilGravity())*100})
        
        output$hopsUtilization3 <- renderText({hopsUtilization3()})
        
        
        hopsUtilization4 <<- reactive({utilization(input, input$BoilTime4, boilGravity())*100})
        
        output$hopsUtilization4 <- renderText({hopsUtilization4()})
        
        
        hopsUtilization5 <<- reactive({utilization(input, input$BoilTime5, boilGravity())*100})
        
        output$hopsUtilization5 <- renderText({hopsUtilization5()})
        
        # Hop IBU -----
        
        IBU1 <<- reactive({
                AUU <- input$AlphaAcid1/100*input$Weight1
                IBU1 <- utilization(input, input$BoilTime1, boilGravity())*AUU*7489/input$batchSize
        })
        
        IBU2 <<- reactive({
                AUU <- input$AlphaAcid2/100*input$Weight2
                IBU2 <- utilization(input, input$BoilTime2, boilGravity())*AUU*7489/input$batchSize
        })
        
        IBU3 <<- reactive({
                AUU <- input$AlphaAcid3/100*input$Weight3
                IBU3 <- utilization(input, input$BoilTime3, boilGravity())*AUU*7489/input$batchSize
        })
        
        IBU4 <<- reactive({
                AUU <- input$AlphaAcid4/100*input$Weight4
                IBU4 <- utilization(input, input$BoilTime4, boilGravity())*AUU*7489/input$batchSize
        })
        
        IBU5 <<- reactive({
                AUU <- input$AlphaAcid5/100*input$Weight5
                IBU5 <- utilization(input, input$BoilTime5, boilGravity())*AUU*7489/input$batchSize
        })
        
        
        Total_IBU <<- reactive({Total_IBU <- IBU1()+IBU2()+IBU3()+IBU4()+IBU5()})
        
        
        output$hopsIBU1 <- renderText({IBU1()})
        
        output$hopsIBU2 <- renderText({IBU2()})

        output$hopsIBU3 <- renderText({IBU3()})
        
        output$hopsIBU4 <- renderText({IBU4()})
        
        output$hopsIBU5 <- renderText({IBU5()})
        
        
        boilGravity <- reactive({
                lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
                higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000
                
                OG <- mean(c(lowerRange,higherRange))/1000+1
                OG

        })
        
        # Boil Gravity -----
        output$hopsBoilGravity <- renderText({boilGravity()})
}



