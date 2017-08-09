# Mash UI

mashUI <- function(){
  tabPanel("Mash", 
           navlistPanel(widths = c(2,10),
                  stepMashUI()
#                  singleDecoctionUI()
#                   doubleDecoctionUI(),
#                   enhancedDoubleDecoctionUI(),
#                   hochkuraDoubleDecoctionUI()
                  
           )
  )
}
