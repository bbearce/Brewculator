## ----- Function Pre-Load ----- ##

calcLbs <- function(input,ing,ingPct){

    if(is.null(ing)){
      lbs <- 0
    }else if (ing != "0 - None") {

            lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
            higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000
           
            OG <- mean(c(lowerRange,higherRange)) #/1000+1
            totalGravity <- OG*(input$batchSize+input$kettleDeadSpace+input$fermentationTankLoss) #OG*Gal #OG*Gal
            lbs <- Grists %>% 
                    filter(Ingredients == ing) %>% 
                    mutate(IngredientGravity = ingPct/100*totalGravity) %>%
                    mutate(lbsNeeded = IngredientGravity/((PPG-1)*1000*input$sysEfficiency/100)) %>%
                    select(lbsNeeded)
    } else {
            lbs <- 0
    }

}

## ----- Fermentables Server ----- ##

fermentablesServer <- function(input, output){
    
    ## ----- Load section ----- ##
    #Default
    fermentablesRVs <- reactiveValues()
    fermentablesRVs$ingredients <- data.frame(Recipe = rep("New",5),
                                              Ingredient = rep("0 - None",5),
                                              Weight_Lbs = rep(0,5),
                                              Percent_Of_Total = rep(0,5))
  
    #Testing
    observeEvent(input$load,{
      # print(fermentablesRVs$ingredients)
      #Set path for DB
      sqlitePath <- "Database/Recipes.sqlite"
      # Connect to the database
      db <- dbConnect(SQLite(), sqlitePath)
      # Construct the fetching query
      query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Fermentables", input$recipe)
      # Submit the fetch query
      data <- dbGetQuery(db, query); #print(data)#...debug
      # Damage Control: Filter out this weird character (Â) and then set the encoding to UTF-8 
      #data$Ingredient <- gsub(pattern = "Â",replacement = "",x = data$Ingredient) # This is a HACK...find a more elegant solution
      Encoding(data$Ingredient) <- "UTF-8"
      #Disconnect
      dbDisconnect(db)
      data
      
      fermentablesRVs$ingredients <- 0 # Allows to load more than once
      fermentablesRVs$ingredients <- data
    })
    
    
    #observeEvent(input$load, {print(input$load); print(fermentablesRVs$ingredients$Ingredient[1])})
    
    # Fermentables
    output$Ingredients1 <- renderUI({selectInput(inputId = "Ingredients1",label = "Ingredients", selected = fermentablesRVs$ingredients$Ingredient[1],choices =  c(Grains$Ingredients, Extracts$Ingredients, Adjuncts$Ingredients))})
    output$Ingredients2 <- renderUI({selectInput(inputId = "Ingredients2",label = NULL, selected = fermentablesRVs$ingredients$Ingredient[2],choices =  c(Grains$Ingredients, Extracts$Ingredients, Adjuncts$Ingredients))})
    output$Ingredients3 <- renderUI({selectInput(inputId = "Ingredients3",label = NULL, selected = fermentablesRVs$ingredients$Ingredient[3],choices =  c(Grains$Ingredients, Extracts$Ingredients, Adjuncts$Ingredients))})
    output$Ingredients4 <- renderUI({selectInput(inputId = "Ingredients4",label = NULL, selected = fermentablesRVs$ingredients$Ingredient[4],choices =  c(Grains$Ingredients, Extracts$Ingredients, Adjuncts$Ingredients))})
    output$Ingredients5 <- renderUI({selectInput(inputId = "Ingredients5",label = NULL, selected = fermentablesRVs$ingredients$Ingredient[5],choices =  c(Grains$Ingredients, Extracts$Ingredients, Adjuncts$Ingredients))})
    
    output$IngredientPercent1 <- renderUI({numericInput(inputId = "IngredientPercent1",label = "Percent",value = fermentablesRVs$ingredients$Percent_Of_Total[1])})
    output$IngredientPercent2 <- renderUI({numericInput(inputId = "IngredientPercent2",label = NULL,value = fermentablesRVs$ingredients$Percent_Of_Total[2])})
    output$IngredientPercent3 <- renderUI({numericInput(inputId = "IngredientPercent3",label = NULL,value = fermentablesRVs$ingredients$Percent_Of_Total[3])})
    output$IngredientPercent4 <- renderUI({numericInput(inputId = "IngredientPercent4",label = NULL,value = fermentablesRVs$ingredients$Percent_Of_Total[4])})
    output$IngredientPercent5 <- renderUI({numericInput(inputId = "IngredientPercent5",label = NULL,value = fermentablesRVs$ingredients$Percent_Of_Total[5])})
    
    ## ----- Calculation Section ----- ##
    
        DPcalc <- reactive({
                

                DPnum <- as.numeric((Grists %>% filter(Ingredients == input$Ingredients1) %>% mutate(DP1=DP*isGrain*grains1()) %>% select(DP1)) +
                                             (Grists %>% filter(Ingredients == input$Ingredients2) %>% mutate(DP2=DP*isGrain*grains2()) %>% select(DP2)) +
                                             (Grists %>% filter(Ingredients == input$Ingredients3) %>% mutate(DP3=DP*isGrain*grains3()) %>% select(DP3)) +
                                             (Grists %>% filter(Ingredients == input$Ingredients4) %>% mutate(DP4=DP*isGrain*grains4()) %>% select(DP4)) +
                                             (Grists %>% filter(Ingredients == input$Ingredients5) %>% mutate(DP5=DP*isGrain*grains5()) %>% select(DP5)))
                DPden <- as.numeric((Grists %>% filter(Ingredients == input$Ingredients1) %>% select(isGrain)*grains1()) +
                                             (Grists %>% filter(Ingredients == input$Ingredients2) %>% select(isGrain)*grains2()) +
                                             (Grists %>% filter(Ingredients == input$Ingredients3) %>% select(isGrain)*grains3()) +
                                             (Grists %>% filter(Ingredients == input$Ingredients4) %>% select(isGrain)*grains4()) +
                                             (Grists %>% filter(Ingredients == input$Ingredients5) %>% select(isGrain)*grains5()))

                
                DP <- DPnum/DPden
                
                sumIngPct <- input$IngredientPercent1+input$IngredientPercent2+input$IngredientPercent3+input$IngredientPercent4+input$IngredientPercent5
                
                if (input$DPcheck == "Advanced" & DPnum > 0 & DP < 35.0 & is.finite(DP) & sumIngPct == 100) {
                        createAlert(session,"DPalert","DPalert1",content="DP is below 35 Linter and needs to be higher, in order for full self conversion of the mash. Add more base malt.")
                } else if (input$DPcheck == "Advanced") {
                        closeAlert(session,"DPalert1")
                }
                
                if (is.finite(DP)) {
                        return(DP)
                } else {
                        return(0)
                }
                
        })
        
        OG <<- reactive({
          lowerRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeLow)) - 1)*1000
          higherRange <- (as.numeric(subset(Styles, Styles == input$Style, select = OGRangeHigh)) - 1)*1000
          
          OG <- mean(c(lowerRange,higherRange))/1000+1
        })
        
        output$DPcalcVal <- renderText({as.character(DPcalc())})
        
        output$DPcalc <- renderUI({
                if (input$DPcheck == "Advanced") {
                        fluidRow(column(width=12,strong("Diastatic Power [\u00B0L]"),verbatimTextOutput("DPcalcVal")))
                }
        })
        
        output$DPalert <- renderUI({
                if (input$DPcheck == "Advanced") {
                        fluidRow(column(width=12,strong(" "),bsAlert("DPalert")))
                }
        })
        
        grains1 <<- reactive({calcLbs(input,input$Ingredients1,input$IngredientPercent1)})
        grains2 <<- reactive({calcLbs(input,input$Ingredients2,input$IngredientPercent2)})
        grains3 <<- reactive({calcLbs(input,input$Ingredients3,input$IngredientPercent3)})
        grains4 <<- reactive({calcLbs(input,input$Ingredients4,input$IngredientPercent4)})
        grains5 <<- reactive({calcLbs(input,input$Ingredients5,input$IngredientPercent5)})
        totalGrain <<- reactive({as.numeric(grains1()+grains2()+grains3()+grains4()+grains5())})
        
        Lbs1 <<- reactive({as.character(round(grains1(),2))})
        Lbs2 <<- reactive({as.character(round(grains2(),2))})
        Lbs3 <<- reactive({as.character(round(grains3(),2))})
        Lbs4 <<- reactive({as.character(round(grains4(),2))})
        Lbs5 <<- reactive({as.character(round(grains5(),2))})
        
        output$Lbs1 <- renderText({Lbs1()})
        output$Lbs2 <- renderText({Lbs2()})
        output$Lbs3 <- renderText({Lbs3()})
        output$Lbs4 <- renderText({Lbs4()})
        output$Lbs5 <- renderText({Lbs5()})
        
        output$fermentablesTotalGrain <- renderText({
                round(totalGrain(),2)
        })
        
}
