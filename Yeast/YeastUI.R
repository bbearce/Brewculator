# Yeast UI

yeastUI <- function(){
        tabPanel("Yeast",
                 fluidRow(
                         column(width = 3,
                                uiOutput(outputId = "yeast")
                         )
                         
                 ),
                 fluidRow(
                         column(width = 2,
                           strong("Default DB Attenuation (%)"),
                           verbatimTextOutput(outputId = "defaultAttenuation")
                          ),
                         column(width = 2,
                           uiOutput(outputId = "attenuation")
                          )
                 ),
                 fluidRow(
                         column(width = 4,
                               wellPanel("Set 'Actual Attenuation' = 'Default DB Attenuation' 
                                 to see ABV using the default Attenuation")
                         )
                 ),
                 fluidRow(
                         column(width = 2,
                           strong("Theoretical ABV (%)"),
                           verbatimTextOutput(outputId = "calculatedABV") 
                         ), 
                         column(width = 2,
                           uiOutput(outputId = "ABV")
                         )
                 ),
                 fluidRow(
                         column(width = 2,
                           strong("Style OG"),
                           verbatimTextOutput(outputId = "styleOG") 
                         ),
                         column(width = 2,
                           uiOutput(outputId = "actualOG") 
                         )
                 ),
                 fluidRow(
                         column(width = 2,
                           strong("Style FG"),
                           verbatimTextOutput(outputId = "styleFG") 
                         ),
                         column(width = 2,
                           uiOutput(outputId = "actualFG")
                         )
                 ),
                 fluidRow(
                         column(width = 3,
                                uiOutput(outputId = "startYeastCells")
                         )
                 ),
                 fluidRow(
                         column(width = 2,
                                strong("Recommended Cells (B)"),
                                verbatimTextOutput(outputId = "cellsNeeded")
                          ),
                         column(width = 2,
                                uiOutput(outputId = "actualPitched")
                         )
                   ),
                 fluidRow(
                         column(width = 2,
                                strong("Recommended Starter (L)"),
                                verbatimTextOutput(outputId = "litersNeeded")),
                         column(width = 2,
                           uiOutput(outputId = "starterUsed")
                   )
                 )
        )
}