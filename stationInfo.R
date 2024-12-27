library(BikeDataCollection)
library(dplyr)
library(DBI)
library(RMySQL)
library(dotenv)

collect_station_info <- function(){

  station_info <- feeds_urls() %>%
    filter(name == "station_information") %>%
    pull(url) %>%
    get_data()

  # Tidy the data
  station_info <- station_info %>%
    magrittr::extract2("data") %>%
    dplyr::mutate(last_updated = station_info$last_updated) %>%
    dplyr::select(
      station_id,
      name,
      lat,
      lon,
      capacity,
      last_updated
    )

  # Database connection
  con <- dbConnect(
    MySQL(),
    dbname = "bikeshare_data",
    host = Sys.getenv("DB_HOST"),
    user = Sys.getenv("DB_USER"),
    password = Sys.getenv("DB_PASSWORD"),
    port = 3306,
    local_infile = 1,
    client.flag = CLIENT_LOCAL_FILES
  )

  # Create table to store the data if it doesn't exist
  if(!dbExistsTable(con, "station_info")){
    con %>% dbCreateTable(
      name = "station_info",
      fields = station_info)
  }

  # write station_info only if table is empty
  if(dbGetQuery(con, "SELECT COUNT(*) FROM station_info")[[1]] == 0){
    con %>%
      dbWriteTable(
        name = "station_info",
        value = station_info,
        append = TRUE,
        row.names = FALSE
      )
    message("Station information collected and stored successfully.")
  } else{
    message("Station information already exists in the database.")
  }

  dbDisconnect(con)
}














