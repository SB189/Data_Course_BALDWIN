# Load Packages
library(tidyverse)

# Read in the data
location_data <- readRDS("./data/county_elevations")
nyt_data <- read.csv("./data/us-counties.csv")

#Rename some very ugly columns in location_data to match nyt_data.
location_data <- rename(location_data,county=str_to_sentence.countycoords.rMapCounty.)
location_data <- rename(location_data,state=str_to_sentence.countycoords.rMapState.)
location_data <- rename(location_data,elevation=elevations.data.elevation)

#full_join the data.
joined_data <- full_join(nyt_data,location_data,by=c("state","county"))
#Evidently there was not elevation data for every county? There are some NAs.
#Perhaps they were spelled differently, but that is a whole new can of worms.

saveRDS(joined_data,"./data/complete_covid_dataset")