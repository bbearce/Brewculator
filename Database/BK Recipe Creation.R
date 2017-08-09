#-------------------------------------------------------------------------------------#
#------------------ Create, Read, Update, Delete for Saving Recipies -----------------#
#-------------------------------------------------------------------------------------#

suppressWarnings(suppressMessages(library(sqldf)))
setwd("C:/Users/Benjamin/Documents/GitHub/BK_Brew/Database")

dbIngredients <- dbConnect(SQLite(), dbname="Recipes.sqlite")

dbWriteTable(conn = dbIngredients, name = "Grains", value = Grains_Info, overwrite = F, append = T)