# Single Decoction UI

singleDecoctionUI <- function(){
        tabPanel("Single Decoction",
                 sidebarLayout(
                     sidebarPanel(width = 4,
                                  h3("Inputs:"),
                                  fluidRow(width = 4,
                                           column(width = 4, 
                                                  numericInput(inputId = "mashGrainTemp",label = paste0("Grain Temp(","\U00B0","F)"),value = 70)
                                           ),
                                           column(width = 4,
                                                  numericInput(inputId = "mashSaccRestTemp",label = paste0("Sacc. Rest Temp (","\U00B0","F)"),value = 150)
                                           )
                                  ),
                                  numericInput(inputId = "mashDuration",label = "Sacc Rest Duration (min)",value = 60),
                                  
                                  h3("Outputs:"),
                                  fluidRow(width = 4,
                                           column(width = 4,
                                                  strong("Mash Vol (Gal):"),
                                                  verbatimTextOutput(outputId = "singleDecoctionMashVol")
                                           ),
                                           column(width = 4,
                                                  strong(paste0("Infusion Temp(","\U00B0","F)")),
                                                  verbatimTextOutput(outputId = "singleDecoctionInfusionTemp") 
                                           )
                                  ),
                                  fluidRow(width = 4,
                                           column(width = 4,
                                                  strong("Thickness (Qts/Lb):"),
                                                  verbatimTextOutput(outputId = "singleDecoctionMashThickness")
                                           ),
                                           column(width = 4,
                                                  strong("Total Grain (lbs):"),
                                                  verbatimTextOutput(outputId = "singleDecoctionTotalGrain")
                                           )
                                  ),
                                  fluidRow(
                                      column(width = 4,
                                             strong("Mash Out Vol (Gal):"),
                                             verbatimTextOutput(outputId = "singleDecoctionMashOutVolume")
                                      ),
                                      column(width = 4,
                                             strong("Boil Time (min):"),
                                             verbatimTextOutput(outputId = "singleDecoctionBoilTime")
                                      )
                                  )
                                  
                                  
                                  
                                  
                                  
                                  
                                  
                     ),
                     mainPanel(width = 8,
                               plotOutput(outputId = "singleDecoctionStepMashPlot")
                     )
                 )
                 
        )
        
}