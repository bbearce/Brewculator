homeUI <- function(){
    tabPanel("Home",
        #Everything underneath that
        wellPanel(#style = "background-color: #9c533c; color: #FFFFFF",
            sidebarLayout(
              
                # Sidebar Panel --------------------
                sidebarPanel(style = "background-color: #FFFFFF",
                            width =3,
                            verticalLayout(
                               wellPanel(style = "background-color: #9c533c; color: #FFFFFF",
                                 h4("What Beer?"),
                                 textInput(inputId = "Brewer", label = "Brewer",value = "Big Kitchen"),
                                 textInput(inputId = "RecipeName", label = "Recipe Name",value = ""),
                                 selectInput(inputId = "Style", label = "BJCP Geneneral Beer Style",choices = unique(Styles$Styles)),
                                 textInput(inputId = "DateBrewed", label = "Date Brewed",value = Sys.time())
                               )
                               ,
                               wellPanel(style = "background-color: #9c533c; color: #FFFFFF",
                                 # This is the recipe list and associated load button   
                                 h4("What Brew?"),
                                 uiOutput("recipeList"),
                                 actionButton(inputId = "load", label = "Load"),
                                 textInput(inputId = "saveRecipe", label = "Recipe Name to Save:"),
                                 actionButton(inputId = "saveButton", label = "Save"),
                                 uiOutput("recipeDeleteList"),
                                 actionButton(inputId = "deleteButton", label = "Delete")
                               )
                             )
                ),
                # Main Panel --------------------
                mainPanel(
                  wellPanel(style = "background-color: #FFFFFF;", width = 9,
                    wellPanel(style = "background-color: #9c533c; color: #FFFFFF",
                              h4("System Specific Constants"),
                              fluidRow(
                                  column(width = 5,
                                         numericInput(inputId = "batchSize",
                                                      label = "Batch Size (Gal):",
                                                      value = 5.5),
                                         numericInput(inputId = "boilTime",
                                                      label = "Boil Time (Min):",
                                                      value = 60),
                                         numericInput(inputId = "evap",
                                                      label = "Evaporation (%/hr)",
                                                      value = 5),
                                         numericInput(inputId = "shrink",
                                                      label = "Shrinkage From Cooling (%)",
                                                      value = 4),
                                         numericInput(inputId = "sysEfficiency",
                                                      label = "Brew House Efficiency (%)",
                                                      value = 73.5),
                                         numericInput(inputId = "scaleRecipe",
                                                      label = "Scale Current Recipe (%)",
                                                      value = 100)
                                  ),
                                  column(width = 5, offset = 1,
                                         numericInput(inputId = "kettleDeadSpace",
                                                      label = "Boil Kettle Dead Space (Gal):",
                                                      value = 0),
                                         numericInput(inputId = "lauterTunDeadSpace",
                                                      label = "Lauter Tun Dead Space (Gal):",
                                                      value = 0.25),
                                         numericInput(inputId = "mashTunDeadSpace",
                                                      label = "Mash Tun Dead Space (Gal):",
                                                      value = 0),
                                         numericInput(inputId = "fermentationTankLoss",
                                                      label = "Fermentation Tank Loss (Gal):",
                                                      value = 0),
                                         selectInput(inputId = "MashTunType",
                                                     label = "Mash Tun Type",
                                                     choices =  c("Kettle/Pot",
                                                                  "Cooler")),
                                         uiOutput("MashTunExtras")
                                  )
                              )
                    )
                    )
                )
              
            )
        )
        
    )
}