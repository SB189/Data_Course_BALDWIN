#Load Packages
library(ggmap) 
#New to me.
library(tidyverse)
library(tidyr)
library(sp)
library(rgdal) #GIVES ELEVATION
library(elevatr) #also elevation
#Also new ?sp
library(housingData) 
#geocounty()
library(janitor)
library(raster) 
#New as ever
library(modelr)
library(zoo)
library(choroplethr) #Has county populations
?zoo
data("df_pop_county")
#New
#devtools::install_github("hafen/housingData")
# Getting ggspatial from github instead of CRAN
#####
#Optional
# library(devtools)
# ggspatial optional method. Only neccessary once.
#devtools::install_github("paleolimbot/ggspatial")
#?zoo
#?merge.zoo()

# Read in county data
#####
#ccdata <- read.csv("./Data/us-counties.csv") #covid county data
# View(ccdata)

# Not interested in daily data, firt try to make it for the whole pandemic.
#####
#ccdata1 <- arrange(ccdata,county) #arrange by county
View(cleaner)
storage1 <- df_pop_county[1:285,1]
cleaner <- paste("0",storage1, sep="")
df_pop_county[1:285,1] = cleaner
countycoords <- geoCounty
df_pop_county <- rename(df_pop_county,"fips"="region")
df_pop_county$fips <- as.factor(df_pop_county$fips)
joined <- full_join(geoCounty,df_pop_county,by=c("fips"))
joined <- rename(joined,"population"="value")
county_storage <- data.frame(str_to_sentence(countycoords$rMapCounty),
                             str_to_sentence(countycoords$rMapState))
pickedcoords <- dplyr::select(countycoords,c("lon","lat"))
ll_prj <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
elevations <- get_elev_point(pickedcoords,ll_prj)
elevations2 <- data.frame(county_storage, elevations@coords,elevations@data$elevation)
joined2 <- data.frame(str_to_sentence(joined$rMapState),str_to_sentence(joined$rMapCounty),joined$population)


elevations2 <- rename(elevations2,county=str_to_sentence.countycoords.rMapCounty.)
elevations2 <- rename(elevations2,state=str_to_sentence.countycoords.rMapState.)
elevations2 <- rename(elevations2,elevation=elevations.data.elevation)

joined2 <- rename(joined2,county=str_to_sentence.joined.rMapCounty.)
joined2 <- rename(joined2,state=str_to_sentence.joined.rMapState.)
joined2 <- rename(joined2,population=joined.population)

elevations2 <- full_join(elevations2,joined2,by=c("state","county"))

#View(elevations2)
#thing <- elevations@coords
#View(county_storage)
saveRDS(elevations2,"./Data/county_elevations")
saveRDS(elevations,"./Data/raw_elevations_output")
#elevations2 <- readRDS("./Data/county_elevations")
#elevations <- readRDS("./Data/raw_elevations_output")
#Use readRDS() next
#?get_elev_point(./county_elevations)
#Use full_join() to get this together with NYT
class(elevations)
#elevations <- readRDS("./county_elevations")
#first column must be longitude, second must be latitude.
#Capitalization problems? string_to_lower() str_to_sentence() First to capital
#Can I make a map?
#myLocation <- c(49,-130,23,-60)
#myLocation <- c(lon=-100,lat=36)
#ggmap::register_google(key="???")
#ggmap(get_googlemap(center=c(lon = -100,lat = 36),zoom = 10,
#                   scale = 2,maptype = 'roadmap')) +
# geom_point()

