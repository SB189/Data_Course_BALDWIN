# Load Packages
library(tidyverse)

# Read in the data
location_data <- readRDS("./data/county_elevations")
nyt_data <- read.csv("./data/us-counties.csv")


#full_join the data.
joined_data <- full_join(nyt_data,location_data,by=c("state","county"))
#Evidently there was not elevation data for every county? There are some NAs.
#Perhaps they were spelled differently, but that is a whole new can of worms.

saveRDS(joined_data,"./data/complete_covid_dataset")
