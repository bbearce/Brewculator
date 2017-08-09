# Saving and Loading Functions

saveData <- function(data,table) {
  sqlitePath <- "Database/Recipes.sqlite"
  
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  # Construct the update query by looping over the data fields
  query <- list()
  
  for(row in 1:nrow(data)){
    
    query[row] <- sprintf(
      "INSERT INTO %s (%s) VALUES ('%s')",
      table, 
      paste(names(data[row,]), collapse = ", "),
      paste(data[row,], collapse = "', '")
    )
    
    dbGetQuery(db, query[[row]])
    
  }
  # Submit the update query and disconnect
  dbDisconnect(db)
}  


# saveData <- function(data,table) {
#         # Connect to the database
#         db <- dbConnect(SQLite(), sqlitePath)
#         # Construct the update query by looping over the data fields
#         query <- sprintf(
#                 "INSERT INTO %s (%s) VALUES ('%s')",
#                 table, 
#                 paste(names(data), collapse = ", "),
#                 paste(data, collapse = "', '")
#         )
#         # Submit the update query and disconnect
#         dbGetQuery(db, query)
#         dbDisconnect(db)
# }

loadData <- function(recipe, table) {
        # Connect to the database
        db <- dbConnect(SQLite(), sqlitePath)
        # Construct the fetching query
        query <- sprintf("SELECT * FROM %s", table)
        # Submit the fetch query and disconnect
        data <- dbGetQuery(db, query)
        dbDisconnect(db)
        data
}