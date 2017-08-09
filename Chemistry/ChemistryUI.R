# Chemistry UI

chemistryUI <- function(){
        tabPanel("Chemistry",
                fluidRow(
                        h4("Step1: Initial Ion Concentrations (ppm or mg/L)"),
                        column(width = 2,
                          uiOutput("Ca")
                        ),
                        column(width = 2,
                          uiOutput("Mg")
                        ),
                        column(width = 2,
                          uiOutput("Na")
                        ),
                        column(width = 2,
                          uiOutput("Cl")
                        ),
                        column(width = 2,
                          uiOutput("SO4")
                        ),
                        column(width = 2,
                          uiOutput("HCO3_CaCO3")
                        )
                ),
                fluidRow(
                        column(width = 2,
#                                strong("Mash Volume (Gal):"),
#                                verbatimTextOutput(outputId = "chemistryMashVol")
                               uiOutput(outputId = "chemistryMashVol")
                               ),
                        column(width = 2,
#                                strong("Sparge Volume (Gal):"),
#                                verbatimTextOutput(outputId = "chemistrySpargeVol")
                               uiOutput(outputId = "chemistrySpargeVol")
                               )
                ),
                fluidRow(
                        column(width = 2,
                               numericInput(inputId = "mashPercentDistilled",label = "% Distilled",value = 0)
                        ),
                        column(width = 2,
                               numericInput(inputId = "spargePercentDistilled",label = "% Distilled",value = 0)
                               
                        )
                ),
                h4("Step2: Grain Info"),
                fluidRow(
                        column(width = 5,
                                tableOutput(outputId = "grainInfo")
                        ),
                        column(width = 1,
                               HTML("<br>"),
                               "%",
                               HTML("<br>"),
                               HTML("<br>"),
                               HTML("<br>"),
                               "oz"
                        ),
                        column(width = 2,
                                numericInput(inputId = "acidulatedMaltPercent",label = "Acidulated Malt",value = 2),
                                numericInput(inputId = "acidulatedMaltOz",label = NULL,value = 0)
                        ),
                        column(width = 1,
                               HTML("<br>"),
                               
                               "%",
                               HTML("<br>"),
                               HTML("<br>"),
                               HTML("<br>"),
                               "ml"
                        ),
                        column(width = 2,
                               numericInput(inputId = "lacticAcidPercent",label = "Lactic Acid",value = 88),
                               numericInput(inputId = "lacticAcidml",label = NULL,value = 0)
                        )
                ),
                fluidRow(
                        h4("Step3: View Mash pH (Desired Mash pH is between 5.4 - 5.6)"),
                        fluidRow(
                            column(width = 6, strong("Estimated Values:"),
                                fluidRow(
                                    column(width = 4,
                                      strong("Mash pH"),
                                      verbatimTextOutput(outputId = "pHestimated")
                                    ),
                                    column(width = 4,
                                      strong("Effective Alkalinty"),
                                      verbatimTextOutput(outputId = "effAlkalinityEstimated")
                                    ),
                                    column(width = 4,
                                      strong("Residual Alkalinty"),
                                      verbatimTextOutput(outputId = "resAlkalinityEstimated")
                                    )
                                )
                            ), 
                            column(width = 6, strong("Actual Values:"),
                                fluidRow(
                                    column(width = 4,
                                      uiOutput(outputId = "pHactual")
                                    ),
                                    column(width = 4,
                                      uiOutput(outputId = "effAlkalinityActual")
                                    ),
                                    column(width = 4,
                                      uiOutput(outputId = "resAlkalinityActual")
                                    )
                                )
                            )
                        )
                        
                ),
                h4("Step4(a): Adjust Mash pH Down (if needed)"),
                wellPanel(
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Mash Additions"),
                                       h4("(grams)")
                                ),
                                column(width = 3,
                                       uiOutput("mashGypsum")
                                ),
                                column(width = 3,
                                       uiOutput("mashCalciumChloride")
                                ),
                                column(width = 3,
                                       uiOutput("mashEpsomSalt")
                                )
                          
                          
                        ),
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Adjusting Sparge Water?")
                                ),
                                column(width = 3,
                                       HTML("<br>"),
                                       checkboxInput(inputId = "checkGypsum", label = NULL, value = FALSE)
                                ),
                                column(width = 3,
                                       HTML("<br>"),
                                       checkboxInput(inputId = "checkCalciumChloride", label = NULL, value = FALSE)
                                ),
                                column(width = 3,
                                       HTML("<br>"),
                                       checkboxInput(inputId = "checkEpsomSalt", label = NULL, value = FALSE)
                                )
                        ),
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Sparge Additions"),
                                       h4("(grams)")
                                ),
                                column(width = 3,
                                       strong("Gypsum CaSO4"),
                                       verbatimTextOutput(outputId = "spargeGypsum")
                                ),
                                column(width = 3,
                                       strong("Cal.Chl. CaCl2"),
                                       verbatimTextOutput(outputId = "spargeCalciumChloride")
                                ),
                                column(width = 3,
                                       strong("Epsom Salt MgSO4"),
                                       verbatimTextOutput(outputId = "spargeEpsomSalt")
                                )
                        )
                ), #End of wellPanel()
                h4("Step4(b): Adjust Mash pH Up (if needed)"),
                wellPanel(
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Mash Additions"),
                                       h4("(grams")
                                ),
                                column(width = 3,
                                  uiOutput("mashSlakedLime")
#                                        numericInput(inputId = "mashSlakedLime",
#                                                     label = "Slaked Lime Ca(OH)2",
#                                                     value =  0)
                                ),
                                column(width = 3,
                                  uiOutput("mashBakingSoda")
#                                        numericInput(inputId = "mashBakingSoda",
#                                                     label = "Baking Soda NaHCO3",
#                                                     value =  0)
                                ),
                                column(width = 3,
                                  uiOutput("mashChalk")
#                                        numericInput(inputId = "mashChalk",
#                                                     label = "Chalk CaCO3",
#                                                     value =  0)
                                )
                        ),
                        fluidRow(
                                column(width = 3,
                                       HTML("<br>"),
                                       h4("Adjusting Sparge Water? ")
                                ),
                                column(width = 3,
                                       HTML("<br>"),
                                       checkboxInput(inputId = "checkSlakedLime", label = NULL, value = FALSE)
                                ),
                                column(width = 3,
                                       HTML("<br>"),
                                       checkboxInput(inputId = "checkBakingSoda", label = NULL, value = FALSE)
                                ),
                                column(width = 3,
                                       HTML("<br>"),
                                       checkboxInput(inputId = "checkChalk", label = NULL, value = FALSE)
                                )
                        ),
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Sparge Additions "),
                                       h4("(grams)")
                                ),
                                column(width = 3,
                                       strong("Slaked Lime Ca(OH)2"),
                                       verbatimTextOutput(outputId = "spargeSlakedLime")
                                ),
                                column(width = 3,
                                       strong("Baking Soda NaHCO3"),
                                       verbatimTextOutput(outputId = "spargeBakingSoda")
                                ),
                                column(width = 3,
                                       strong("Chalk CaCO3"),
                                       verbatimTextOutput(outputId = "spargeChalk")
                                )
                        )
                ), #End of wellPanel()
                h4("Step5: View Resulting Water Profile"),
                wellPanel(
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Mash Profile "),
                                       h4("(ppm)")
                                ),
                                column(width = 1,
                                       strong("Ca"),
                                       verbatimTextOutput(outputId = "mashCalcium")
                                ),
                                column(width = 1,
                                       strong("Mg"),
                                       verbatimTextOutput(outputId = "mashMagnesium")
                                ),
                                column(width = 1,
                                       strong("Na"),
                                       verbatimTextOutput(outputId = "mashSodium")
                                ),
                                column(width = 1,
                                       strong("Cl"),
                                       verbatimTextOutput(outputId = "mashChloride")
                                ),
                                column(width = 1,
                                       strong("SO4"),
                                       verbatimTextOutput(outputId = "mashSulfate")
                                ),
                                column(width = 1,
                                       strong("Cl/SO4"),
                                       verbatimTextOutput(outputId = "mashChlorideSulfate")
                                )
                        ),
                        fluidRow(
                                column(width = 3,
                                       #HTML("<br>"),
                                       h4("Mash + Sparge Profile"),
                                       h4("(ppm)")
                                ),
                                column(width = 1,
                                       strong("Ca"),
                                       verbatimTextOutput(outputId = "M_SCalcium")
                                ),
                                column(width = 1,
                                       strong("Mg"),
                                       verbatimTextOutput(outputId = "M_SMagnesium")
                                ),
                                column(width = 1,
                                       strong("Na"),
                                       verbatimTextOutput(outputId = "M_SSodium")
                                ),
                                column(width = 1,
                                       strong("Cl"),
                                       verbatimTextOutput(outputId = "M_SChloride")
                                ),
                                column(width = 1,
                                       strong("SO4"),
                                       verbatimTextOutput(outputId = "M_SSulfate")
                                ),
                                column(width = 1,
                                       strong("Cl/SO4"),
                                       verbatimTextOutput(outputId = "M_SChlorideSulfate")
                                )
                        ),
                        fluidRow(
                                column(width = 3,
                                       HTML("<br>"),
                                       h4("Recommended Ranges"),
                                       h4("(ppm)")
                                ),
                                column(width = 1,
                                       strong("Ca"),
                                       verbatimTextOutput(outputId = "recommendedCalcium")
                                ),
                                column(width = 1,
                                       strong("Mg"),
                                       verbatimTextOutput(outputId = "recommendedMagnesium")
                                ),
                                column(width = 1,
                                       strong("Na"),
                                       verbatimTextOutput(outputId = "recommendedSodium")
                                ),
                                column(width = 1,
                                       strong("Cl"),
                                       verbatimTextOutput(outputId = "recommendedChloride")
                                ),
                                column(width = 1,
                                       strong("SO4"),
                                       verbatimTextOutput(outputId = "recommendedSulfate")
                                ),
                                column(width = 1,
                                       strong("Cl/SO4"),
                                       verbatimTextOutput(outputId = "recommendedChlorideSulfate")
                                )
                        ),
                        fluidRow(
                                "*Cl/SO4",
                                verbatimTextOutput(outputId = "Chl_SO4_Ratio_Message")
                        )
                ) #End of wellPanel()
        )
}