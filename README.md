# Bike Share Data Collection and Visualization Project

This project automates the collection, storage, and visualization of Capital bike-sharing data using a combination of custom R scripts and a Shiny application. It employs the BikeDataCollection package (developed by the author) for accessing API endpoints, processes the data, and stores it in a MySQL database. A Shiny dashboard provides interactive visualizations of the data.

## Features 
  `1) Data Collection`
* Station Information: Retrieves and stores bike station details such as station_id, name, capacity, latitude, and longitude.
* Station Status: Collects real-time bike availability and status information, including the number of bikes and docks available at each station.

 `2) Database Integration` 

* All collected data is stored in a MySQL database for efficient querying and historical analysis.
* Ensures data integrity by checking for duplicates before inserting new records. 

 `3) Email Notifications`
* Success or failure notifications are sent via email using the blastula package for real-time updates on data collection status.

`4) Shiny Dashboard`
* Provides interactive visualizations for: Bike station overvie, Geographic distribution of stations, Availability of bikes and e-bikes.

