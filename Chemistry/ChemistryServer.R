# Chemistry Server

chemistryServer <- function(input, output){
        
        chemistryRVs <- reactiveValues()
        chemistryRVs$ingredients <- data.frame(
                                                Recipe = "New",
                                                Init_Ca = 4,
                                                Init_Mg = 1,
                                                Init_Na = 32,
                                                Init_Cl = 27,
                                                Init_SO4 = 6,
                                                Init_HCO3_CaCO3 = 40,
                                                Actual_pH = 5.5,
                                                Effective_Alkalinity = -150,
                                                Residual_Alkalinity = -200,
                                                pH_DOWN_Gypsum_CaSO4 = 5,
                                                pH_DOWN_Cal_Chl_CaCl2 = 5,
                                                pH_DOWN_Epsom_Salt_MgSO4 = 5,
                                                pH_UP_Slaked_Lime_CaOH2 = 5,
                                                pH_UP_Baking_Soda_NaHCO3 = 5,
                                                pH_UP_Chalk_CaCO3 = 5)

        
        
        #On Load do this
        observeEvent(input$load,{
          
          #Set path for DB
          sqlitePath <- "Database/Recipes.sqlite"
          # Connect to the database
          db <- dbConnect(SQLite(), sqlitePath)
          # Construct the fetching query
          query <- sprintf("SELECT * FROM %s WHERE Recipe = '%s'", "Chemistry", input$recipe)
          # Submit the fetch query
          data <- dbGetQuery(db, query); 
          # Damage Control: Filter out this weird character (Â) and then set the encoding to UTF-8 
          #data$Ingredient <- gsub(pattern = "Â",replacement = "",x = data$Ingredient) # This is a HACK...find a more elegant solution
          #Encoding(data$Ingredient) <- "UTF-8"
          #Disconnect
          dbDisconnect(db)
          chemistryRVs$ingredients <- 0 # Allows to load more than once
          chemistryRVs$ingredients <- data
        })
        
  
        ### Step 1 Variables and Output -----
        # DB Values
        output$Ca <- renderUI({ numericInput(inputId = "Ca", label = "Ca", value =  chemistryRVs$ingredients$Init_Ca[1]) })
        output$Mg <- renderUI({ numericInput(inputId = "Mg", label = "Mg", value =  chemistryRVs$ingredients$Init_Mg[1]) })
        output$Na <- renderUI({ numericInput(inputId = "Na", label = "Na", value =  chemistryRVs$ingredients$Init_Na[1]) })
        output$Cl <- renderUI({ numericInput(inputId = "Cl", label = "Cl", value =  chemistryRVs$ingredients$Init_Cl[1]) })
        output$SO4 <- renderUI({ numericInput(inputId = "SO4", label = "SO4", value =  chemistryRVs$ingredients$Init_SO4[1]) })
        output$HCO3_CaCO3 <- renderUI({ numericInput(inputId = "HCO3_CaCO3", label = "HCO3 or CaCO#", value =  chemistryRVs$ingredients$Init_HCO3_CaCO3[1]) })

        
        output$chemistryMashVol <- renderUI({
                
            if(is.null(input$mashThickness)){
              mashThickness <- 1.25
            }else{
              mashThickness <- input$mashThickness 
            }

      
            numericInput(inputId = "chemistryMashVol",label = "Mash Volume (Gal):",value = mashThickness*totalGrain()/4) #[Qts/Lbs]*[Lbs]*[1Gal/4Qts] = Gal
        })
        
        output$chemistrySpargeVol <- renderUI({
            numericInput(inputId = "chemistrySpargeVol",label = "Sparge Volume (Gal):",value = spargeVol()) #from water server
        })
        
        ### Step 2 Variables and Output -----
        
        chemistryMashVol <- reactive({
            if(is.null(input$chemistryMashVol)){
              chemistryMashVol <- 0
            }else{
              chemistryMashVol <- input$chemistryMashVol
            }
        })
        
        grainInfo <- reactive({
          
            if(is.null(input$Ingredients1) | is.null(input$Ingredients2) | is.null(input$Ingredients3) | is.null(input$Ingredients4) | is.null(input$Ingredients5)){
              
              Ingredients1 <- "0 - None"
              Ingredients2 <- "0 - None"
              Ingredients3 <-"0 - None"
              Ingredients4 <- "0 - None"
              Ingredients5 <- "0 - None"
              
            }else{
              
              Ingredients1 <- input$Ingredients1
              Ingredients2 <- input$Ingredients2
              Ingredients3 <- input$Ingredients3
              Ingredients4 <- input$Ingredients4
              Ingredients5 <- input$Ingredients5
              
            }
                  
                  #Grain Type and Distilled Water pH
                  grainDistpH <- data.frame(grainTypes = 0:11,
                                            distWaterpH = c(0,
                                                            0,
                                                            5.7,
                                                            5.79,
                                                            5.77,
                                                            5.43,
                                                            5.75,
                                                            6.04,
                                                            5.56,
                                                            5.70,
                                                            NA,
                                                            4.71))
                  
                  #Grains
                  ingredients <- c(Ingredients1,
                                   Ingredients2,
                                   Ingredients3,
                                   Ingredients4,
                                   Ingredients5)
                  
                  #Lbs
                  lbs <- as.numeric(c(grains1(),
                                      grains2(),
                                      grains3(),
                                      grains4(),
                                      grains5()))
                  #EZ Water Code
                  ezWaterCode <- as.numeric(c(filter(Grists, Ingredients == Ingredients1) %>% select(EZWaterCode),
                                              filter(Grists, Ingredients == Ingredients2) %>% select(EZWaterCode),
                                              filter(Grists, Ingredients == Ingredients3) %>% select(EZWaterCode),
                                              filter(Grists, Ingredients == Ingredients4) %>% select(EZWaterCode),
                                              filter(Grists, Ingredients == Ingredients5) %>% select(EZWaterCode)))
                  #SRM
                  srm <- as.numeric(c(filter(Grists, Ingredients == Ingredients1) %>% select(SRM),
                                      filter(Grists, Ingredients == Ingredients2) %>% select(SRM),
                                      filter(Grists, Ingredients == Ingredients3) %>% select(SRM),
                                      filter(Grists, Ingredients == Ingredients4) %>% select(SRM),
                                      filter(Grists, Ingredients == Ingredients5) %>% select(SRM)))
                  
                  graininfo <- data.frame(Ingredients =ingredients, 
                             Lbs = lbs, 
                             SRM = srm,
                             EZWaterCode = ezWaterCode) %>%
                             left_join(y = grainDistpH, by = c("EZWaterCode" = "grainTypes")) 
                  
                  data.frame(Ingredients =ingredients, 
                    Lbs = lbs, 
                    SRM = srm,
                    EZWaterCode = ezWaterCode) %>%
                    left_join(y = grainDistpH, by = c("EZWaterCode" = "grainTypes")) %>%
                    mutate(distWaterpH = ifelse(ezWaterCode == 10, 5.22-0.00504*srm,distWaterpH)) %>%
                    select(Ingredients,Lbs,SRM,distWaterpH)
                  
        })
        output$grainInfo <- renderTable({grainInfo()})
        ### Step 3 Variables and Output -----
        
        pHestimated <<- reactive({
#           print("grainInfo()")
#           print(grainInfo())
#           print("totalGrain()")
#           print(totalGrain())
#           print("chemistryMashVol()")
#           print(chemistryMashVol())
#           
#           print("effAlkalinityEstimated()")
#           print(effAlkalinityEstimated())
#           print("resAlkalinityEstimated()")
#           print(resAlkalinityEstimated())
          
          if(chemistryMashVol() == 0){
            pH <- 0
          }else{
            pH <- grainInfo() %>%
              mutate(Lbs_x_distWaterPH = Lbs*distWaterpH) %>%
              .[complete.cases(.),] %>%
              select(Lbs_x_distWaterPH) %>%
              sum()/ifelse(totalGrain() == 0, 1, totalGrain()) %>%
              as.numeric() + (0.1085*chemistryMashVol()/ifelse(totalGrain() == 0, 1, totalGrain())+0.013)*resAlkalinityEstimated()/50
          }
          
          pH
          
        })
        
        output$pHestimated <- renderText({pHestimated()})
        output$pHactual <- renderUI({ numericInput(inputId = "pHactual", label = "Mash pH", value =  chemistryRVs$ingredients$Actual_pH[1]) })
        
        
        effAlkalinityEstimated <<- reactive({
                
                #What is this bonkers logic below??? Found it in the spread sheet...I think it should be deleted...but for now I'll keep. (1/29/2017)
                #It might be a non implemented toggle for HCO3 or CaCO
                if(chemistryMashVol() == 0){
                  
                  effAlkalinityEstimated <- 0
                  
                }else{
                  
                  if("Not Bicarbonate" == "Bicarbonate"){ratio = 56/61}else if("Alkalinity" == "Alkalinity"){ratio = 1}
                  #(1-%Distilled)*(HCO3 or CaCO3) #ppm
                  effAlkalinityEstimated <- ((1)*input$HCO3_CaCO3*ratio+ 
                    
                    (
                      (mashChalk()*130)+
                        (mashBakingSoda()*157)-
                        (176.1*input$lacticAcidPercent/100*input$lacticAcidml*2)-
                        (4160.4*input$acidulatedMaltPercent/100*input$acidulatedMaltOz)*2.5+
                        (mashSlakedLime())*357
                    )/(ifelse(chemistryMashVol() == 0,1,chemistryMashVol())))
                  
                  
                }
          
                effAlkalinityEstimated
                
                
        })
        
        output$effAlkalinityEstimated <- renderText({ effAlkalinityEstimated() })
        output$effAlkalinityActual <- renderUI({ numericInput(inputId = "effAlkalinityActual", label = "Actual Effective Alkalinity", value =  chemistryRVs$ingredients$Effective_Alkalinity[1]) })
        
        resAlkalinityEstimated <<- reactive({ 
          
          if(chemistryMashVol() == 0){
            resAlkalinityEstimated <- 0
          }else{
            resAlkalinityEstimated <- effAlkalinityEstimated() - ((mashCa()/1.4)+(mashMg()/1.7))
            
          }

          resAlkalinityEstimated #ppm
          
          }) 
        
        output$resAlkalinityEstimated <- renderText({resAlkalinityEstimated()})
        output$resAlkalinityActual <- renderUI({ numericInput(inputId = "resAlkalinityActual", label = "Actual ResidualAlkalinity ", value =  chemistryRVs$ingredients$Residual_Alkalinity[1]) })
        
        ### Step 4 Variables and Output -----
        #(a) - Adjusting pH Down
        
        output$mashGypsum <- renderUI({ numericInput(inputId = "mashGypsum", label = "Gypsum CaSO4", value =  chemistryRVs$ingredients$pH_DOWN_Gypsum_CaSO4[1]) })
        
        output$mashCalciumChloride <- renderUI({ numericInput(inputId = "mashCalciumChloride", label = "Cal.Chl. CaCl2", value =  chemistryRVs$ingredients$pH_DOWN_Cal_Chl_CaCl2[1]) })
        
        output$mashEpsomSalt <- renderUI({ numericInput(inputId = "mashEpsomSalt", label = "Epsom Salt MgSO4", value =  chemistryRVs$ingredients$pH_DOWN_Epsom_Salt_MgSO4[1]) })
        


        
        
        spargeGypsum <- reactive({
                ifelse(input$checkGypsum,
                       mashGypsum()*(input$chemistrySpargeVol/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())),
                       0)
        })
        spargeCalciumChloride <- reactive({
                ifelse(input$checkCalciumChloride,
                       mashCalciumChloride()*(input$chemistrySpargeVol/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())),
                       0)
        })
        spargeEpsomSalt <- reactive({
                ifelse(input$checkEpsomSalt,
                       mashEpsomSalt()*(input$chemistrySpargeVol/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())),
                       0)
        })
        
        output$spargeGypsum <- renderText({spargeGypsum()})
        output$spargeCalciumChloride <- renderText({spargeCalciumChloride()})
        output$spargeEpsomSalt <- renderText({spargeEpsomSalt()})
        
        #(b) - Adjusting pH Up
        
        output$mashSlakedLime <- renderUI({ numericInput(inputId = "mashSlakedLime", label = "Slaked Lime Ca(OH)2", value =  chemistryRVs$ingredients$pH_UP_Slaked_Lime_CaOH2[1]) })
        output$mashBakingSoda <- renderUI({ numericInput(inputId = "mashBakingSoda", label = "Baking Soda NaHCO3", value =  chemistryRVs$ingredients$pH_UP_Baking_Soda_NaHCO3[1]) })
        output$mashChalk <- renderUI({ numericInput(inputId = "mashChalk", label = "Chalk CaCO3", value =  chemistryRVs$ingredients$pH_UP_Chalk_CaCO3[1]) })

        
        
        
        
        spargeSlakedLime <- reactive({
                ifelse(input$checkSlakedLime,
                       mashSlakedLime()*(input$chemistrySpargeVol/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())),
                       0)
        })
        spargeBakingSoda <- reactive({
                ifelse(input$checkBakingSoda,
                       mashBakingSoda()*(input$chemistrySpargeVol/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())),
                       0)
        })
        spargeChalk <- reactive({
                ifelse(input$checkChalk,
                       mashChalk()*(input$chemistrySpargeVol/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())),
                       0)
        })
        
        output$spargeSlakedLime <- renderText({spargeSlakedLime()})
        output$spargeBakingSoda <- renderText({spargeSlakedLime()})
        output$spargeChalk <- renderText({spargeChalk()})
        
        ### Step 5 Variables and Output -----
        #Mash Profile
        
        # handle NULLS
        
        Ca <- reactive({ifelse(is.null(input$Ca),4,input$Ca)})
        Cl <- reactive({ifelse(is.null(input$Cl),4,input$Cl)})
        Mg <- reactive({ifelse(is.null(input$Mg),4,input$Mg)})
        Na <- reactive({ifelse(is.null(input$Na),4,input$Na)})
        SO4 <- reactive({ifelse(is.null(input$SO4),4,input$SO4)})
        
        mashBakingSoda <- reactive({ifelse(is.null(input$mashBakingSoda),5,input$mashBakingSoda)})
        mashChalk <- reactive({ifelse(is.null(input$mashChalk),5,input$mashChalk)})
        mashGypsum <- reactive({ifelse(is.null(input$mashGypsum),5,input$mashGypsum)})
        mashCalciumChloride <- reactive({ifelse(is.null(input$mashCalciumChloride),5,input$mashCalciumChloride)})
        mashSlakedLime <- reactive({ifelse(is.null(input$mashSlakedLime),5,input$mashSlakedLime)})
        mashEpsomSalt <- reactive({ifelse(is.null(input$mashEpsomSalt),5,input$mashEpsomSalt)})
        
        
        mashCa <- reactive({
                (1)* #1-%Distilled
                (Ca())+
                (mashChalk()*105.89+
                 mashGypsum()*60+
                 mashCalciumChloride()*72+
                 mashSlakedLime()*143)/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())
        })
        mashMg <- reactive({
                (1)*
                (Mg())+
                (mashEpsomSalt()*24.6)/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())
        })
        mashNa <- reactive({
                (1)*
                (Na())+
                (mashBakingSoda()*72.3)/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())
        })
        mashCl <- reactive({
                (1)*
                (Cl())+
                (mashCalciumChloride()*127.47)/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())
        })
        mashSO4 <- reactive({
                (1)*
                (SO4())+
                (mashGypsum()*147.4+mashEpsomSalt()*103)/ifelse(chemistryMashVol() == 0,1,chemistryMashVol())
        })
        
        output$mashCalcium <- renderText({mashCa()})
        output$mashMagnesium <- renderText({mashMg()})
        output$mashSodium <- renderText({mashNa()})
        output$mashChloride <- renderText({mashCl()})
        output$mashSulfate <- renderText({mashSO4()})
        output$mashChlorideSulfate <- renderText({mashCl()/mashSO4()})
        #Mash and Sparge Profile
        
        M_SCalcium <- reactive({
#           print("input$chemistrySpargeVol")
#           print(input$chemistrySpargeVol)
#           print("input$mashPercentDistilled")
#           print(input$mashPercentDistilled)
#           print("chemistryMashVol()")
#           print(chemistryMashVol())
#           print("input$spargePercentDistilled")
#           print(input$spargePercentDistilled)
#           print("Ca()")
#           print(Ca())
#           print("mashChalk()")
#           print(mashChalk())
#           print("spargeChalk()")
#           print(spargeChalk())
#           print("mashGypsum()")
#           print(mashGypsum())
#           print("spargeGypsum()")
#           print(spargeGypsum())
#           print("mashCalciumChloride()")
#           print(mashCalciumChloride())
#           print("spargeCalciumChloride()")
#           print(spargeCalciumChloride())
#           print("mashSlakedLime()")
#           print(mashSlakedLime())
#           print("spargeSlakedLime()")
#           print(spargeSlakedLime())
#           print("END")
          
                
                if(is.null(input$chemistrySpargeVol)){
                        M_SCalcium <- mashCa()
                }else if(input$chemistrySpargeVol == 0){
                        M_SCalcium <- mashCa()
                        
                }else{
                        M_SCalcium <- (1-(input$mashPercentDistilled*chemistryMashVol()+input$spargePercentDistilled*input$chemistrySpargeVol)/
                                               (chemistryMashVol()+input$chemistrySpargeVol)
                        )*Ca()+
                                ((mashChalk()+spargeChalk())*105.89+
                                         (mashGypsum()+spargeGypsum())*60+
                                         (mashCalciumChloride()+spargeCalciumChloride())*72+
                                         (mashSlakedLime()+spargeSlakedLime())*143)/(chemistryMashVol()+input$chemistrySpargeVol)
                        
                }
                M_SCalcium
        })
        M_SMagnesium <- reactive({
                if(is.null(input$chemistrySpargeVol)){
                        M_SMagnesium <- mashMg()
                }else if(input$chemistrySpargeVol == 0){
                        M_SMagnesium <- mashMg()
                        
                }else{
                        M_SMagnesium <- (1-(input$mashPercentDistilled*chemistryMashVol()+input$spargePercentDistilled*input$chemistrySpargeVol)/
                                                 (chemistryMashVol()+input$chemistrySpargeVol)
                        )*Mg()+
                                ((mashEpsomSalt()+spargeEpsomSalt())*24.6)/
                                (chemistryMashVol()+input$chemistrySpargeVol)
                        
                }
                M_SMagnesium
        })
        M_SSodium <- reactive({
                if(is.null(input$chemistrySpargeVol)){
                        M_SSodium <- mashNa()
                }else if(input$chemistrySpargeVol == 0){
                        M_SSodium <- mashNa()
                        
                }else{
                        M_SSodium <- (1-(input$mashPercentDistilled*chemistryMashVol()+input$spargePercentDistilled*input$chemistrySpargeVol)/
                                              (chemistryMashVol()+input$chemistrySpargeVol)
                        )*Na()+
                                ((mashBakingSoda()+spargeBakingSoda())*72.3)/
                                (chemistryMashVol()+input$chemistrySpargeVol)
                        
                }
                M_SSodium
        })
        M_SChloride <- reactive({
                if(is.null(input$chemistrySpargeVol)){
                        M_SChloride <- mashCl()
                }else if(input$chemistrySpargeVol == 0){
                        M_SChloride <- mashCl()
                        
                }else{
                        M_SChloride <- (1-(input$mashPercentDistilled*chemistryMashVol()+input$spargePercentDistilled*input$chemistrySpargeVol)/
                                                (chemistryMashVol()+input$chemistrySpargeVol)
                        )*Cl()+
                                ((mashCalciumChloride()+spargeCalciumChloride())*127.47)/
                                (chemistryMashVol()+input$chemistrySpargeVol)
                        
                }
                M_SChloride
        })
        M_SSulfate <- reactive({
                if(is.null(input$chemistrySpargeVol)){
                        M_SSulfate <- mashSO4()
                }else if(input$chemistrySpargeVol == 0){
                        M_SSulfate <- mashSO4()
                        
                }else{
                        M_SSulfate <- (1-(input$mashPercentDistilled*chemistryMashVol()+input$spargePercentDistilled*input$chemistrySpargeVol)/
                                               (chemistryMashVol()+input$chemistrySpargeVol)
                        )*SO4()+
                                ((mashGypsum()+spargeGypsum())*147.4+
                                         (mashEpsomSalt()+spargeEpsomSalt())*103)/
                                (chemistryMashVol()+input$chemistrySpargeVol)
                        
                }
                M_SSulfate
        })
        M_SChlorideSulfate <- reactive({
               ifelse(is.nan(M_SChloride()/M_SSulfate()),0.6211459,M_SChloride()/M_SSulfate())
        })
        output$M_SCalcium <- renderText({M_SCalcium()})
        output$M_SMagnesium <- renderText({M_SMagnesium()})
        output$M_SSodium <- renderText({M_SSodium()})
        output$M_SChloride <- renderText({M_SChloride()})
        output$M_SSulfate <- renderText({M_SSulfate()})
        output$M_SChlorideSulfate <- renderText({M_SChlorideSulfate()})
        
        #Palmer's Recommened Ranges
        output$recommendedCalcium <- renderText({"50-100"})
        output$recommendedMagnesium <- renderText({"10-30"})
        output$recommendedSodium <- renderText({"0-150"})
        output$recommendedChloride <- renderText({"0-250"})
        output$recommendedSulfate <- renderText({"50-350"})
        output$recommendedChlorideSulfate <- renderText({"*"})
        
        #Chloride / Sulfate Ratio Check
        output$Chl_SO4_Ratio_Message <- renderText({
                  
                M_SChlorideSulfate <- ifelse(is.na(M_SChlorideSulfate())
                                            ,mean(c(0.77,1.3))
                                            ,M_SChlorideSulfate())  
                
                if(M_SChlorideSulfate < 0.77){
                        "Below .77, May enhance bitterness"
                }else if(M_SChlorideSulfate < 1.3){
                        ".77 to 1.3 = Balanced"
                }else{
                        "Above 1.3 may enhance maltiness"
                }
        })
        
        
        
        
}