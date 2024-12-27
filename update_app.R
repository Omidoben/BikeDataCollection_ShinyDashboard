source("bike_station_status.R")
source("stationInfo.R")
source("load_data.R")

# Main data collection and processing workflow

run_daily_bike_data_workflow <- function() {
  tryCatch({
    loginfo("Starting daily bike data collection workflow")

    collect_station_info()

    safe_collect_daily_status()

    load_most_recent_bike_data()

    loginfo("Daily bike data workflow completed successfully")

  }, error = function(e) {
    logerror(paste("Workflow failed:", e$message))

    # Send error notification (using existing email method from first script)
    email <- compose_email(
      body = md(glue::glue("
        **Bike Data Workflow Failed**
        - Error Message: {e$message}
        - Timestamp: {Sys.time()}
      "))
    )
    smtp_send(
      email,
      from = "benomido2001@gmail.com",
      to = "benomido2001@gmail.com",
      subject = "Bike Data Workflow - Failure",
      credentials = creds_file("email_creds")
    )

    stop("Daily bike data workflow failed")
  })
}

# Execute the workflow
run_daily_bike_data_workflow()



