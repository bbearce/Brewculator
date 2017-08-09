# Hops UI

hopsUI <- function(){
  
  
tabPanel("Hops",
        HTML("<br>"),
        fluidRow(
                column(width = 2,
                       uiOutput(outputId = "Hops1")
                ),
                column(width = 2,
                       uiOutput(outputId = "Weight1")
                ),
                column(width = 2,
                       uiOutput(outputId = "hopsAlphaAcidOne")
                ),
                column(width = 1,
                       strong("Default AA (%)"),
                       verbatimTextOutput(outputId = "hopsDefaultAlphaAcidOne")
                ),
                column(width = 2,
                       uiOutput(outputId = "BoilTime1")
                ),
                column(width = 2,
                       strong("Utilization (%)"),
                       verbatimTextOutput(outputId = "hopsUtilization1") #switch to verbatimTextOutput() for reactive values
                ),
                column(width = 1,
                       strong("IBU"),
                       verbatimTextOutput(outputId = "hopsIBU1") #switch to verbatimTextOutput() for reactive values
                )
        ),
        fluidRow(
          column(width = 2,
            uiOutput(outputId = "Hops2")
          ),
          column(width = 2,
            uiOutput(outputId = "Weight2")
          ),
          column(width = 2,
            uiOutput(outputId = "hopsAlphaAcidTwo")
          ),
          column(width = 1,
            verbatimTextOutput(outputId = "hopsDefaultAlphaAcidTwo")
          ),
          column(width = 2,
            uiOutput(outputId = "BoilTime2")
          ),
          column(width = 2,
            verbatimTextOutput(outputId = "hopsUtilization2") #switch to verbatimTextOutput() for reactive values
          ),
          column(width = 1,
            verbatimTextOutput(outputId = "hopsIBU2") #switch to verbatimTextOutput() for reactive values
          )
        ),
        fluidRow(
                column(width = 2,
                       uiOutput(outputId = "Hops3")
                ),
                column(width = 2,
                       uiOutput(outputId = "Weight3")
                ),
                column(width = 2,
                       uiOutput(outputId = "hopsAlphaAcidThree")
                ),
                column(width = 1,
                       verbatimTextOutput(outputId = "hopsDefaultAlphaAcidThree")
                ),
                column(width = 2,
                       uiOutput(outputId = "BoilTime3")
                ),
                column(width = 2,
                       verbatimTextOutput(outputId = "hopsUtilization3") #switch to verbatimTextOutput() for reactive values
                ),
                column(width = 1,
                       verbatimTextOutput(outputId = "hopsIBU3") #switch to verbatimTextOutput() for reactive values
                )
        ),
        fluidRow(
                column(width = 2,
                       uiOutput(outputId = "Hops4")
                ),
                column(width = 2,
                       uiOutput(outputId = "Weight4")
                ),
                column(width = 2,
                       uiOutput(outputId = "hopsAlphaAcidFour")
                ),
                column(width = 1,
                       verbatimTextOutput(outputId = "hopsDefaultAlphaAcidFour")
                ),
                column(width = 2,
                       uiOutput(outputId = "BoilTime4")
                ),
                column(width = 2,
                       verbatimTextOutput(outputId = "hopsUtilization4") #switch to verbatimTextOutput() for reactive values
                ),
                column(width = 1,
                       verbatimTextOutput(outputId = "hopsIBU4") #switch to verbatimTextOutput() for reactive values
                )
        ),
        fluidRow(
                column(width = 2,
                       uiOutput(outputId = "Hops5")
                ),
                column(width = 2,
                       uiOutput(outputId = "Weight5")
                ),
                column(width = 2,
                       uiOutput(outputId = "hopsAlphaAcidFive")
                ),
                column(width = 1,
                       verbatimTextOutput(outputId = "hopsDefaultAlphaAcidFive")
                ),
                column(width = 2,
                       uiOutput(outputId = "BoilTime5")
                ),
                column(width = 2,
                       verbatimTextOutput(outputId = "hopsUtilization5") #switch to verbatimTextOutput() for reactive values
                ),
                column(width = 1,
                       verbatimTextOutput(outputId = "hopsIBU5") #switch to verbatimTextOutput() for reactive values
                )
        ),
        fluidRow(
                column(width = 2,
                       strong("Boil Gravity"),
                       verbatimTextOutput(outputId = "hopsBoilGravity")
                )
        ),
        HTML("<br><br><br><br><br>")

)
}