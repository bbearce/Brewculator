library(shiny, quietly = TRUE, warn.conflicts = FALSE)
library(sqldf, quietly = TRUE, warn.conflicts = FALSE)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE)
library(tidyr, quietly = TRUE, warn.conflicts = FALSE)
library(stringr, quietly = TRUE, warn.conflicts = FALSE)
library(ggplot2, quietly = TRUE, warn.conflicts = FALSE)
library(RSQLite, quietly = TRUE, warn.conflicts = FALSE)
library(shinyjs, quietly = TRUE, warn.conflicts = FALSE)
library(shinyBS, quietly = TRUE, warn.conflicts = FALSE)


# Get Databases...maybe make lazy

db <- dbConnect(SQLite(), dbname="Database/Ingredients.sqlite")
Grains <- dbReadTable(db, "Grains")
Grains <- Grains[order(Grains$Ingredients),]
Extracts <- dbReadTable(db, "Extracts")
Adjuncts <- dbReadTable(db, "Adjuncts")
Grists <- rbind(Grains,Extracts,Adjuncts)
Hops <- dbReadTable(db, "Hops")
Spices <- dbReadTable(db, "Spices")
Yeast <- dbReadTable(db, "Yeast")
Styles <- dbReadTable(db, "Styles")

db <-  dbConnect(SQLite(), dbname="Database/BKBrewHouse.sqlite")
GravityVersusTemp <-  dbReadTable(db, "GravityCorrectionChart")
closeAllConnections()



source("Helper_Functions/helpers.R", local = TRUE)

source("Home/homeUI.R", local = TRUE)
source("Home/homeServer.R", local = TRUE)

source("Fermentables/FermentablesUI.R", local = TRUE)
source("Fermentables/FermentablesServer.R", local = TRUE)

source("Water/WaterUI.R", local = TRUE)
source("Water/WaterServer.R", local = TRUE)

source("Hops/HopsUI.R", local = TRUE)
source("Hops/HopsServer.R", local = TRUE)

source("Mash/MashUI.R", local = TRUE)
source("Mash/StepMash/StepMashUI.R", local = TRUE)
# source("Mash/SingleDecoction/SingleDecoctionUI.R", local = TRUE)

source("Mash/MashServer.R", local = TRUE)
source("Mash/StepMash/StepMashServer.R", local = TRUE)
# source("Mash/SingleDecoction/SingleDecoctionServer.R", local = TRUE)

source("Yeast/YeastUI.R", local = TRUE)
source("Yeast/YeastServer.R", local = TRUE)

source("Chemistry/ChemistryUI.R", local = TRUE)
source("Chemistry/ChemistryServer.R", local = TRUE)

source("Fermentation/FermentationUI.R", local = TRUE)
source("Fermentation/FermentationServer.R", local = TRUE)

ui <- tagList(
        useShinyjs(),
        navbarPage(title="BK Brewculator",
                   
                   homeUI(),
                   fermentablesUI(),
                   hopsUI(),
                   waterUI(),
#                    #tabPanel("Water"),
                   mashUI(),
                   yeastUI(),
                   chemistryUI(),
                   fermentationUI()
        )
      )
        
        
server <- function(input, output){
    homeServer(input, output)
    fermentablesServer(input, output)
    hopsServer(input, output)
    waterServer(input, output)
    mashServer(input, output)
    yeastServer(input, output)
    chemistryServer(input, output)
    fermentationServer(input, output)
}


#runApp(shinyApp(ui = ui, server = server), launch.browser = TRUE)
shinyApp(ui = ui, server = server)









