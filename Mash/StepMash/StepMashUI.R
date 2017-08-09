# Step Mash UI

stepMashUI <- function(){
        tabPanel("Step Mash (infusions)",
                 sidebarLayout(
                         sidebarPanel(width = 4,
                                 h3("Inputs:"),
                                 fluidRow(width = 4,
                                   column(width = 4,
                                          uiOutput("mashGrainTemp")
                                          #numericInput(inputId = "mashGrainTemp",label = paste0("Grain Temp(","\U00B0","F)"),value = 70)
                                          ),
                                   column(width = 4,
                                          uiOutput("mashSaccRestTemp")
                                          #numericInput(inputId = "mashSaccRestTemp",label = paste0("Sacc. Rest Temp (","\U00B0","F)"),value = 150)
                                          )
                                 ),
                                 uiOutput("mashDuration"),
                                 #numericInput(inputId = "mashDuration",label = "Sacc Rest Duration (min)",value = 60),
                                 
                                 h3("Outputs:"),
                                 fluidRow(width = 4,
                                          column(width = 4,
                                                 strong("Mash Vol (Gal):"),
                                                 verbatimTextOutput(outputId = "mashMashVol")
                                          ),
                                          column(width = 4,
                                                 strong(paste0("Infusion Temp(","\U00B0","F)")),
                                                 verbatimTextOutput(outputId = "infusionTemp") 
                                          )
                                 ),
                                 fluidRow(width = 4,
                                     column(width = 4,
                                            strong("Thickness (Qts/Lb):"),
                                            verbatimTextOutput(outputId = "mashThickness")
                                            ),
                                     column(width = 4,
                                            strong("Total Grain (lbs):"),
                                            verbatimTextOutput(outputId = "totalGrain")
                                            )
                                ),
                                 fluidRow(
                                     column(width = 4,
                                            strong("Mash Out Vol (Gal):"),
                                            verbatimTextOutput(outputId = "mashOutVolume")
                                            ),
                                     column(width = 4,
                                            strong("Boil Time (min):"),
                                            verbatimTextOutput(outputId = "boilTime")
                                            )
                                 )
                                 
                         ),
                          mainPanel(width = 8,
                                 plotOutput("stepMashPlot")
                          )
                 )
                 
        )
}