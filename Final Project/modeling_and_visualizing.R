library(tidyverse)
library(modelr)
library(ggmap)
library(prophet)
library(gganimate)
library(zoo) #Compare models.
library(xts) #alternative to zoo.
library(tidyquant)
library(forecast)
library(RColorBrewer)
library(viridis)
library(patchwork)
library(lme4)
library(gifski)
library(lmerTest)
#?arima()
#?rollsum()
#diff()
#?prophet
#View(covid_data)

covid_data <- readRDS("./Data/complete_covid_dataset")
#class(covid_data$date)
covid_data$date <- as.Date(covid_data$date)
covid_data$deaths <- as.numeric(covid_data$deaths)
covid_data$cases <- as.numeric(covid_data$cases)
#class(covid_data$deaths)
#gganimate

#make_future_dataframe()
#prophet_plot_components()
cuts <- cut(covid_data$elevation,4)
covid_data$elev_group <- cuts
covid_data$elev_group %>% levels()

#Dividing into groups for prophet.
low <- covid_data %>% filter(elev_group == "(-24.1,922]")
moderate <- covid_data %>% filter(elev_group == "(922,1.86e+03]")
high <- covid_data %>% filter(elev_group == "(1.86e+03,2.81e+03]")
extreme <- covid_data %>% filter(elev_group == "(2.81e+03,3.75e+03]")

#Subsetting for prophet.
lowpc <- dplyr::select(low,c("date","cases"))
moderatepc <- dplyr::select(moderate,c("date","cases"))
highpc <- dplyr::select(high,c("date","cases"))
extremepc <- dplyr::select(extreme,c("date","cases"))

lowpd <- dplyr::select(low,c("date","deaths"))
moderatepd <- dplyr::select(moderate,c("date","deaths"))
highpd <- dplyr::select(high,c("date","deaths"))
extremepd <- dplyr::select(extreme,c("date","deaths"))

#Renaming for use by prophet.
lowpc <- rename(lowpc,"ds"="date","y"="cases")
moderatepc <- rename(moderatepc,"ds"="date","y"="cases")
highpc <- rename(highpc,"ds"="date","y"="cases")
extremepc <- rename(extremepc,"ds"="date","y"="cases")

lowpd <- rename(lowpd,"ds"="date","y"="deaths")
moderatepd <- rename(moderatepd,"ds"="date","y"="deaths")
highpd <- rename(highpd,"ds"="date","y"="deaths")
extremepd <- rename(extremepd,"ds"="date","y"="deaths")

#Collapsing the data for prophet and cutting off that NA at the end.
lowpc <- group_by(lowpc,ds) %>% #ie) LOW Prophet Cases
  summarise(y=sum(y,na.rm=TRUE))
lowpc <- lowpc[1:299,1:2]

moderatepc <- group_by(moderatepc,ds) %>%
  summarise(y=sum(y,na.rm=TRUE))
moderatepc <- moderatepc[1:256,1:2]

highpc <- group_by(highpc,ds) %>%
  summarise(y=sum(y,na.rm=TRUE))
highpc <- highpc[1:255,1:2]

extremepc <- group_by(extremepc,ds) %>%
  summarise(y=sum(y,na.rm=TRUE))
extremepc <- extremepc[1:250,1:2]

lowpd <- group_by(lowpd,ds) %>% #ie) LOW Prophet Deaths
  summarise(y=sum(y,na.rm=TRUE))
lowpd <- lowpd[1:299,1:2]

moderatepd <- group_by(moderatepd,ds) %>%
  summarise(y=sum(y,na.rm=TRUE))
moderatepd <- moderatepd[1:256,1:2]

highpd <- group_by(highpd,ds) %>%
  summarise(y=sum(y,na.rm=TRUE))
highpd <- highpd[1:255,1:2]

extremepd <- group_by(extremepd,ds) %>%
  summarise(y=sum(y,na.rm=TRUE))
extremepd <- extremepd[1:250,1:2]

#Running these datasets through prophet to get models...
mod_lpc <- prophet(lowpc,daily.seasonality = TRUE)
mod_mpc <- prophet(moderatepc,daily.seasonality = TRUE)
mod_hpc <- prophet(highpc,daily.seasonality = TRUE)
mod_epc <- prophet(extremepc,daily.seasonality = TRUE)

mod_lpd <- prophet(lowpd,daily.seasonality = TRUE)
mod_mpd <- prophet(moderatepd,daily.seasonality = TRUE)
mod_hpd <- prophet(highpd,daily.seasonality = TRUE)
mod_epd <- prophet(extremepd,daily.seasonality = TRUE)


#Now to get values for anova and making a few plots.
predlpc <- make_future_dataframe(mod_lpc,periods=100)
predlpc = predict(mod_lpc,predlpc)
datalpc = data.frame(predlpc$ds,predlpc$yhat)
mod_lpc_plot <- plot(mod_lpc,predlpc)

predmpc <- make_future_dataframe(mod_mpc,periods=100)
predmpc = predict(mod_mpc,predmpc)
datampc = data.frame(predmpc$ds,predmpc$yhat)
mod_mpc_plot <- plot(mod_mpc,predmpc)

predhpc <- make_future_dataframe(mod_hpc,periods=100)
predhpc = predict(mod_hpc,predhpc)
datahpc = data.frame(predhpc$ds,predhpc$yhat)
mod_hpc_plot <- plot(mod_hpc,predhpc)

predepc <- make_future_dataframe(mod_epc,periods=100)
predepc = predict(mod_epc,predepc)
dataepc = data.frame(predepc$ds,predepc$yhat)
mod_epc_plot <- plot(mod_epc,predepc)

#
predlpd <- make_future_dataframe(mod_lpd,periods=100)
predlpd = predict(mod_lpd,predlpd)
datalpd = data.frame(predlpd$ds,predlpd$yhat)
mod_lpd_plot <- plot(mod_lpd,predlpd)

predmpd <- make_future_dataframe(mod_mpd,periods=100)
predmpd = predict(mod_mpd,predmpd)
datampd = data.frame(predmpd$ds,predmpd$yhat)
mod_mpd_plot <- plot(mod_mpd,predmpd)

predhpd <- make_future_dataframe(mod_hpd,periods=100)
predhpd = predict(mod_hpd,predhpd)
datahpd = data.frame(predhpd$ds,predhpd$yhat)
mod_hpd_plot <- plot(mod_hpd,predhpd)

predepd <- make_future_dataframe(mod_epd,periods=100)
predepd = predict(mod_epd,predepd)
dataepd = data.frame(predepd$ds,predepd$yhat)
mod_epd_plot <- plot(mod_epd,predepd)

#Saving images of prophet models.
saveRDS(mod_lpc_plot,"./Output/low_alt_cases_plot.jpg")
saveRDS(mod_mpc_plot,"./Output/moderate_alt_cases_plot.jpg")
saveRDS(mod_hpc_plot,"./Output/high_alt_cases_plot.jpg")
saveRDS(mod_epc_plot,"./Output/extreme_alt_cases_plot.jpg")
#
saveRDS(mod_lpd_plot,"./Output/low_alt_deaths_plot.jpg")
saveRDS(mod_mpd_plot,"./Output/moderate_alt_deaths_plot.jpg")
saveRDS(mod_hpd_plot,"./Output/high_alt_deaths_plot.jpg")
saveRDS(mod_epd_plot,"./Output/extreme_alt_deaths_plot.jpg")

#Patchworking these plots.
side_by_side_cases <- patchwork::wrap_plots(mod_lpc_plot,mod_mpc_plot,mod_hpc_plot,mod_epc_plot)
side_by_side_deaths <-   patchwork::wrap_plots(mod_lpd_plot,mod_mpd_plot,mod_hpd_plot,mod_epd_plot)
saveRDS(side_by_side_cases,"./Output/patched_cases.RDS")
saveRDS(side_by_side_deaths,"./Output/patched_deaths.RDS")
                                   


#Making models ANOVA can use.
#lowdeaths <- lmer(data=low,formula=deaths~(1 | county/elevation) + date)
#moderatedeaths <- lmer(data=moderate,formula=deaths~(1 | county/elevation) + date)
#highdeaths <- lmer(data=high,formula=deaths~(1 | county/elevation) + date)
#extremedeaths <- lmer(data=extreme,formula=deaths~(1 | county/elevation) + date)

#lowcases <- lmer(data=low,formula=cases~(1 | county/elevation) + date)
#moderatecases <- lmer(data=moderate,formula=cases~(1 | county/elevation) + date)
#highcases <- lmer(data=high,formula=cases~(1 | county/elevation) + date)
#extremecases <- lmer(data=extreme,formula=cases~(1 | county/elevation) + date)
  
  
 # anova(lowdeaths,extremedeaths)

#Suggestions for models...
#glm(deaths ~ elevation * date, data = full_dataset)
#lmer(data=,formula = deaths ~ (1 | county/elevation) + date)
#The second one deals with the nested data.
#See week 10 mixed effect models...
#then compare these models with anova, find the root mean square...
#saveRDS()
#ggsave("./myanimation.gif")
#RColorBrewer::display.all()
#viridis package has more colors...
#+scale_color_viridis(option="magma")
#Chloropleth map
#?geom_contour() Works best with a grid, not a grid.
#?Prophet
#This refused to save properly, so I used the snipping tool.
  #testingdata <- filter(covid_data,state=="Utah") # To shorten loading times.
  
  
  
ggmap::register_google(key="???") #INSERT KEY

elevation_map <- ggmap(get_googlemap(center=c(lon = -100,lat = 36),zoom = 4,
                    scale = 1,maptype = 'roadmap')) +
  geom_point(data=covid_data, aes(x=lon,y=lat,alpha=cases,color=elev_group))
ggsave(elevation_map,"./Output/Elevation_Plot")
ggsave("./Output/Elevation_Plot.jpg")

#This makes it more suitable for the map...
covid_data <- covid_data %>% filter(!is.na(date))
#unique(covid_data$date)

#cases
ggmap(get_map(center=c(lon = -100,lat = 36),zoom = 4,
              scale = 1,maptype = 'toner')) +
  geom_point(data=covid_data, aes(x=lon,y=lat,color=cases/population)) +
  scale_color_viridis() +
  transition_time(date) +
  labs(title = 'Date: {frame_time}')
anim_save("./Output/covid_progression.gif")

#deaths
ggmap(get_map(center=c(lon = -100,lat = 36),zoom = 4,
              scale = 1,maptype = 'toner')) +
  geom_point(data=covid_data, aes(x=lon,y=lat,color=deaths/population)) +
  scale_color_viridis() +
  transition_time(date) +
  labs(title = 'Date: {frame_time}')
anim_save("./Output/covid_deaths_progression.gif")

#Modeling Retry...
#lmer(date = covid_data,
 #    formula = deaths/cases ~ date + (1|state/county/elevation))

small_covi <- covid_data[sample(6000),]
#lmer(data=low,formula=deaths~(1 | county/elevations) + date)
#lmer(data=moderate,formula=deaths~(1 | county/elevations) + date)
#lmer(data=high,formula=deaths~(1 | county/elevations) + date)
#lmer(data=extreme,formula=deaths~(1 | county/elevations) + date)

mod1 <- glm(covid_data,family=gaussian(),
            formula = sqrt(deaths/population) ~ date + elevation)
mod2 <- glm(covid_data,family=gaussian(),
            formula = sqrt(cases/population) ~ date + elevation)

summod1 <- summary(mod1)
saveRDS(summod1,"./Output/deaths_model_summary.RDS")

summod2 <- summary(mod2)
saveRDS(summod2,"./Output/cases_model_summary.RDS")


#fullmod <- lmer(data = small_covi,
 #               formula = deaths/cases ~ date + (1 | state/county/elevation))
 




