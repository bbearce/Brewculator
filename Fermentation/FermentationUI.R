# Fermentation UI

fermentationUI <- function(){
        tabPanel("Fermentation",
                 fluidRow(
                   column(width = 4,
                     h4("Fermentation"),
                     column(width = 8,
                            uiOutput("fermentationFirstTemp"),
                            uiOutput("fermentationSecondTemp"),
                            uiOutput("fermentationThirdTemp"),
                            uiOutput("fermentationFourthTemp"),
                            uiOutput("fermentationFifthTemp")
                            
#                             sliderInput(inputId = "fermentationFirstTemp", label = "First Temp", min = 40, max = 80, value = 65),
#                             sliderInput(inputId = "fermentationSecondTemp", label = "Second Temp", min = 40, max = 80, value = 65),
#                             sliderInput(inputId = "fermentationThirdTemp", label = "Third Temp", min = 40, max = 80, value = 65),
#                             sliderInput(inputId = "fermentationFourthTemp", label = "Fourth Temp", min = 40, max = 80, value = 65),
#                             sliderInput(inputId = "fermentationFifthTemp", label = "Fifth Temp", min = 40, max = 80, value = 65)
                     ),
                     column(width = 4,
                            uiOutput("days1"),HTML("<br>"),HTML("<br>"),
                            uiOutput("days2"),HTML("<br>"),HTML("<br>"),
                            uiOutput("days3"),HTML("<br>"),HTML("<br>"),
                            uiOutput("days4"),HTML("<br>"),HTML("<br>"),
                            uiOutput("days5"),HTML("<br>")

                     )
                       
                   ),
                   column(width = 8,
                          plotOutput(outputId = "fermentationPlot")
                   )
                 )
        )
}