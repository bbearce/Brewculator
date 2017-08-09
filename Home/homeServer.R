
recipeListFunction <- function(){
    sqlitePath <- "Database/Recipes.sqlite"
    
    # Connect to the database
    db <- dbConnect(SQLite(), sqlitePath)
    # Construct the fetching query
    query <- sprintf("SELECT DISTINCT(Recipe) FROM %s ORDER BY Recipe", "Fermentables")
    # Submit the fetch query and disconnect
    data <- dbGetQuery(db, query)
    dbDisconnect(db)
    
    recipe <- unlist(data) %>% as.character()
    recipe  
}

homeServer <- function(input, output){
  

    output$recipeList <- renderUI({selectInput(inputId = "recipe", label = "Recipe Name to Load:", choices = recipeListFunction())})
    output$recipeDeleteList <- renderUI({selectInput(inputId = "recipeDeleteList", label = "Recipe Name to Delete:", choices = recipeListFunction())})
    
    
    
    
    # Save Functionality
    #Things to find:
    
    #Chemistry Table
    chemistryData <- reactive({
      Chemistry <- data.frame(
        Recipe = input$saveRecipe,
        Init_Ca = input$Ca,
        Init_Mg = input$Mg,
        Init_Na = input$Na,
        Init_Cl = input$Cl,
        Init_SO4 = input$SO4,
        Init_HCO3_CaCO3 = input$HCO3_CaCO3,
        Actual_pH = input$pHactual,
        Effective_Alkalinity = input$effAlkalinityActual,
        Residual_Alkalinity = input$resAlkalinityActual,
        pH_Down_Gypsum_CaSO4 = input$mashGypsum,
        pH_Down_Cal_Chl_CaCl2 = input$mashCalciumChloride,
        pH_Down_Epsom_Salt_MgSO4 = input$mashEpsomSalt,
        pH_UP_Slaked_Lime_CaOH2 = input$mashSlakedLime,
        pH_UP_Baking_Soda_NaHCO3 = input$mashBakingSoda,
        pH_UP_Chalk_CaCO3 = input$mashChalk,
        stringsAsFactors = F)
    })
    
    #Fermentables Table
    fermentablesData <- reactive({
      Fermentables <- data.frame(
        Recipe = rep(input$saveRecipe,5),
        Ingredient = c(input$Ingredients1,input$Ingredients2,input$Ingredients3,input$Ingredients4,input$Ingredients5),
        Weight_Lbs = c(Lbs1(),Lbs2(),Lbs3(),Lbs4(),Lbs5()),
        Percent_Of_Total = c(input$IngredientPercent1,input$IngredientPercent2,input$IngredientPercent3,input$IngredientPercent4,input$IngredientPercent5),
        stringsAsFactors = F)
    })
    
    #Fermentation Table...make graph...do later because it is hard
    fermentationData <- reactive({
      Fermentation <- data.frame(
        Recipe = input$saveRecipe,
        Days1 = input$days1,Temp1 = input$fermentationFirstTemp,
        Days2 = input$days2,Temp2 = input$fermentationSecondTemp,
        Days3 = input$days3,Temp3 = input$fermentationThirdTemp,
        Days4 = input$days4,Temp4 = input$fermentationFourthTemp,
        Days5 = input$days5,Temp5 = input$fermentationFifthTemp,
        stringsAsFactors = F)
    })
    
    #Hops Table
    hopsData <- reactive({
      Hops <- data.frame(
        Recipe = rep(input$saveRecipe,5),
        Name = c(input$Hops1,input$Hops2,input$Hops3,input$Hops4,input$Hops5),
        Weight_Oz = c(input$Weight1,input$Weight2,input$Weight3,input$Weight4,input$Weight5),
        Boil_Time_Min = c(input$BoilTime1,input$BoilTime2,input$BoilTime3,input$BoilTime4,input$BoilTime5),
        Alpha_Acid_Content = c(input$AlphaAcid1,input$AlphaAcid2,input$AlphaAcid3,input$AlphaAcid4,input$AlphaAcid5),
        Utilization = c(hopsUtilization1(),hopsUtilization2(),hopsUtilization3(),hopsUtilization4(),hopsUtilization5()),
        IBU = c(IBU1(),IBU2(),IBU3(),IBU4(),IBU5()),
        stringsAsFactors = F)
    })
    
    #Mash Tables...do we need a table for each mash type
    #...or one table where the most complicated mash with the most columns, dictates the number
    #of columns. Then either everything is filled in or we pad with NULLs.
    mashData <- reactive({
      Mash <- data.frame(
        Recipe = input$saveRecipe,
        Init_Grain_Temp = input$mashGrainTemp,
        Infusion_Temp = Tw(),
        Sacc_Rest_Temp = input$mashSaccRestTemp,
        Mash_Duration = input$mashDuration,
        Mash_Volume_Gal = mashVol(),
        Mash_Thickness = input$waterMashThickness,
        Mash_Out_Vol = Wa(),
        stringsAsFactors = F)
    })
    #Not Correct
    systemData <- reactive({
      System <- data.frame(
        Recipe = input$saveRecipe,
        Batch_Size = input$batchSize,
        Boil_Time = input$boilTime,
        Evap_Rate = input$evap,
        Shrinkage = input$shrink,
        Efficiency = input$sysEfficiency,
        Boil_Kettle_Dead_Space_Gal = input$kettleDeadSpace,
        Lauter_Tun_Dead_Space_Gal = input$lauterTunDeadSpace,
        Mash_Tun_Dead_Space_Gal = input$mashTunDeadSpace,
        Fermentation_Tank_Loss_Gal = input$fermentationTankLoss,
        stringsAsFactors = F)
    })
    
    waterData <- reactive({
     
      Water <- data.frame(
        Recipe = input$saveRecipe,
        Mash_Thickness = input$waterMashThickness,
        Grain_Abs_Factor = input$grainAbsorptionFactor,
        stringsAsFactors = F)
        
    })
    
    yeastData <- reactive({
      Yeast <- data.frame(
        Recipe = input$saveRecipe,
        Name = input$yeast,
        Attenuation = input$attenuation,
        ABV = ABV(),
        OG = 1.050,
        FG = 1.050,
        Init_Cells = input$startYeastCells,
        Pitched_Cells = cellsNeeded(),
        Liters_for_Starter = litersNeeded(),
        stringsAsFactors = F)
    })
    
    observeEvent(input$saveButton, {
      
      saveData(chemistryData(), table = "Chemistry")
      saveData(fermentablesData(), "Fermentables")
      saveData(fermentationData(), "Fermentation")
      saveData(hopsData(), "Hops")
      saveData(mashData(), "Mash")
      saveData(systemData(), "System")
      saveData(waterData(), "Water")
      saveData(yeastData(), "Yeast")
      
    })
    
    observeEvent(input$deleteButton, {

      sqlitePath <- "Database/Recipes.sqlite"
      
      # Connect to the database
      db <- dbConnect(SQLite(), sqlitePath)
      # Construct the fetching query
      
      Recipe <- input$recipeDeleteList
      
      chemistryQuery <- sprintf(paste0("DELETE FROM Chemistry WHERE Recipe = \'",Recipe,"\';"))
      fermentablesQuery <- sprintf(paste0("DELETE FROM Fermentables WHERE Recipe = \'",Recipe,"\';"))
      fermentationQuery <- sprintf(paste0("DELETE FROM Fermentation WHERE Recipe = \'",Recipe,"\';"))
      yeastQuery <- sprintf(paste0("DELETE FROM Yeast WHERE Recipe = \'",Recipe,"\';"))
      hopsQuery <- sprintf(paste0("DELETE FROM Hops WHERE Recipe = \'",Recipe,"\';"))
      mashQuery <- sprintf(paste0("DELETE FROM Mash WHERE Recipe = \'",Recipe,"\';"))
      systemQuery <- sprintf(paste0("DELETE FROM System WHERE Recipe = \'",Recipe,"\';"))
      waterQuery <- sprintf(paste0("DELETE FROM Water WHERE Recipe = \'",Recipe,"\';"))
      # Submit the fetch query and disconnect
      dbGetQuery(db, chemistryQuery)
      dbGetQuery(db, fermentablesQuery)
      dbGetQuery(db, fermentationQuery)
      dbGetQuery(db, yeastQuery)
      dbGetQuery(db, hopsQuery)
      dbGetQuery(db, mashQuery)
      dbGetQuery(db, systemQuery)
      dbGetQuery(db, waterQuery)
 
      
      dbDisconnect(db)
      
    })
    
    
    
  
  # Kyle added this. This is for more advanced mash tun settings.  
  output$MashTunExtras <- renderUI({
    if (input$MashTunType == "Cooler") {
      fluidRow(
        column(width=12,
               numericInput(inputId = "weightMashTun",
                            label = "Weight of Mash Tun (lbs):",
                            value = 7.5),
               numericInput(inputId = "thermalMassMashTun",
                            label = "Thermal Mash of Mash Tun (btu/(lb*F)):",
                            value = 0.38)
        )
      )
    }
  })
  
  
  
 }







