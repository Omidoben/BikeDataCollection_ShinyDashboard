# load_data.R
library(DBI)
library(RMySQL)
library(dplyr)
library(tibble)

# Function to load most recent bike data

load_most_recent_bike_data <- function() {
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

  # Create table with the specified columns
  dbExecute(con, "
    CREATE TABLE IF NOT EXISTS latest_bike_stations (
      is_installed BOOLEAN,
      num_bikes_available INT,
      last_reported DATETIME,
      is_renting BOOLEAN,
      num_docks_available INT,
      num_docks_disabled INT,
      is_returning BOOLEAN,
      station_id INT,
      num_ebikes_available INT,
      num_bikes_disabled INT,
      num_scooters_available INT,
      time DATETIME,
      name VARCHAR(255),
      lat DOUBLE,
      lon DOUBLE,
      capacity INT
    )
  ")

  # Fetch the most recent record from original tables
  latest_station_status_data <- dbGetQuery(
    con,
    "SELECT * FROM station_status
     WHERE time = (SELECT MAX(time) FROM station_status)"
  ) %>% tibble::tibble()

  latest_station_info_data <- dbGetQuery(con, "SELECT * FROM station_info") %>%
    tibble::tibble()

  # Join and process data
  df <- latest_station_status_data %>%
    left_join(latest_station_info_data, by = "station_id") %>%
    select(-last_updated)

  # Insert the new data into the latest_bike_stations table
  dbWriteTable(con, "latest_bike_stations", df, append = TRUE, row.names = FALSE)

  dbDisconnect(con)
}


