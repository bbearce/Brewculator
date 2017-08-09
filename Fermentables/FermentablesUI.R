# Fermentables UI

fermentablesUI <- function(){
  
    tabPanel("Fermentables", 
        
             HTML("<br>"),
#              fluidRow(
#                column(width = 4,
#                       selectInput(inputId = "DPcheck",
#                                   label = "Fermentables Difficulty",
#                                   choices = c("Default","Advanced")),
#                       bsTooltip("DPcheck","Advanced will alert user when Diastatic Power is too low for self conversion","top","hover focus")
#                ),
#                column(width = 4,
#                       uiOutput("DPcalc")
#                ),
#                column(width = 4,
#                       uiOutput("DPalert"))
#              ),
             fluidRow(
               column(width = 4,
                      uiOutput("Ingredients1")
               ),
               column(width = 2,
                      uiOutput("IngredientPercent1")
               ),
               column(width = 2,
                      strong("Lbs"),
                      verbatimTextOutput(outputId = "Lbs1") 
               ),
               column(width = 2,
                      strong("Total Grains (Lbs)"),
                      verbatimTextOutput(outputId = "fermentablesTotalGrain")
               )
               
             ),
             fluidRow(
               column(width = 4,
                      uiOutput("Ingredients2")
               ),
               column(width = 2,
                      uiOutput("IngredientPercent2")
               ),
               column(width = 2,
                      verbatimTextOutput(outputId = "Lbs2")
               )
             ),
             fluidRow(
               column(width = 4,
                      uiOutput("Ingredients3")
               ),
               column(width = 2,
                      uiOutput("IngredientPercent3")
               ),
               column(width = 2,
                      verbatimTextOutput(outputId = "Lbs3")
               )
             ),
             fluidRow(
               column(width = 4,
                      uiOutput("Ingredients4")
               ),
               column(width = 2,
                      uiOutput("IngredientPercent4")
               ),
               column(width = 2,
                      verbatimTextOutput(outputId = "Lbs4")
               )
             ),
             fluidRow(
               column(width = 4,
                      uiOutput("Ingredients5")
               ),
               column(width = 2,
                      uiOutput("IngredientPercent5")
               ),
               column(width = 2,
                      verbatimTextOutput(outputId = "Lbs5")
               )
             ),
             HTML("<br><br><br><br><br>")
                     
    )
   
}