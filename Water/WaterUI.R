# Water UI

waterUI <- function(){
        tabPanel(title = "Water",
                 splitLayout(
                      splitLayout(width = 4,
                              fluidRow(
                              
                              column(width = 2,
                              strong("Total Water (Gal):"),
                              wellPanel(textOutput(outputId = "waterTotalWaterNeeded")),
                              strong("Grain Loss (Gal):"),
                              wellPanel(textOutput(outputId = "waterGrainLoss")),
                              strong("Equipment Loss (Gal):"),
                              wellPanel(textOutput(outputId = "waterEquipLoss")),
                              strong("Water Evap Loss (Gal):"),
                              wellPanel(textOutput(outputId = "waterEvapLoss")))
                              ,
                              column(width = 2, offset = 2,
                                uiOutput("waterMashThickness"),
#                                 numericInput(inputId = "waterMashThickness",
#                                              label = "Mash Thickness (Qts/Lb):",
#                                              value = 1.25),
                                uiOutput("grainAbsorptionFactor"),
#                                 numericInput(inputId = "grainAbsorptionFactor",
#                                              label = "Grain Abs. Factor (Gal/Lb):",
#                                              value = .125),
                                strong("Mash Volume (Gal):"),
                                verbatimTextOutput(outputId = "waterMashVol"),
                                strong("Sparge Volume (Gal):"),
                                verbatimTextOutput(outputId = "waterSpargeVol"))
                              )
                      ),
                      
                      plotOutput(outputId = "waterGraph")
                                      
                                      
                         )
                 )
}