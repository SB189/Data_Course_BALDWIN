library(tidyverse)
library(tidyr)
library(stringr)
#There were a few errors on the .txt, namely making the fourth graph also
#save as Fig_3 and task label IV being repeated twice.
#I numbered them based off of the tasks in order and graph 4 is BALDWIN_Fig_4.jpg
#All the test material is in the same folder as the answers.
#The code in each task may contain necessary objects for subsequent tasks.

#1####

#clean for plot
ld <- read.csv("./landdata-states.csv")
ld <- rename(ld, LandValue = Land.Value)
ld$Year <- as.numeric(ld$Year)
ld <- rename(ld, Region = region)
#Plot
p1 <- ggplot(ld,aes(y=`LandValue`,x=`Year`,color=Region)) +
  geom_smooth() +
  labs(y="Land Value (USD)") +
  options(scipen = 999)
p1
ggsave("./BALDWIN_Fig_1.jpg",width = 7, height = 6, dpi = 700)

#How do I get str_squish() to only act on column headers?
#I had to resort to a rename...

#2####

#Show states to which NA applies
NA_States <- filter(ld,is.na(Region)) %>% select(State) %>% unique()
View(NA_States)

#3####

#Loading ugly dataframe and viewing it.
ew <- read.csv("./unicef-u5mr.csv")
View(ew)
#cleaning time
ew <- pivot_longer(ew, cols = starts_with("U5MR"),
                      names_to = "Year", values_to = "U5MR_Values")
ew$Year <- str_remove_all(ew$Year, "U5MR.")
ew$Year <- as.numeric(ew$Year)
#Tidy... I think

#4####

ggplot(ew,aes(x=Year,y=U5MR_Values,color = Continent)) +
  geom_point() + labs(y="MortalityRate")
  
ggsave("./BALDWIN_Fig_2.jpg",width = 7, height = 6, dpi = 700)

#5####

#prep into averages with mutate
ew2 <- ew %>% group_by(Continent,Year) %>%
  summarise(mean(U5MR_Values, na.rm = TRUE))
ew2 <- rename(ew2, MortRate = "mean(U5MR_Values, na.rm = TRUE)")

#plot it
ggplot(ew2,aes(x=Year,y=MortRate,color = Continent)) +
   geom_line(size=2) +
labs(y="Mean Mortality Rate (deaths per 1000 live births)")

#Save it
ggsave("./BALDWIN_Fig_3.jpg",width = 7, height = 6, dpi = 700)

#6####

#Prepping
ew3 <- mutate(ew,proportion = U5MR_Values/1000)

#Plotting
ggplot(ew3,aes(x=Year,y=proportion)) +
  geom_point(color = "blue", size = .5) +
  facet_wrap(~Region) +
  theme_minimal()

#Save it

ggsave("./BALDWIN_Fig_4.jpg",width = 8.5, height = 6, dpi = 700)





#Pushed####