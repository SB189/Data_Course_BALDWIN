# Assignment 7 messy code
# Change this to "tidy" format using dplyr verbs

# There's an intuitive dplyr version for almost everything you see here.

# Note: Do not erase the original code, just comment it out and put your own equivalent code below each section
# i.e., change each line of indicated code to a tidy version that does the same thing.


#library(tidyverse)
library(tidyverse)

##########################
#        Part 1          #
##########################
View(utah)
# load data (wide format)
#utah = read.csv("./Utah_Religions_by_County.csv")
utah = read.csv("./Utah_Religions_by_County.csv")
# subset to only counties with buddhists observed
#buddhist = utah[utah$Buddhism.Mahayana > 0,]
buddhist <- gather(utah, key = Religion, value = Proportion, -c(1:3)) %>%
  filter(Religion %in% "Buddhism.Mahayana")
  
# order rows by population (descending)
#buddhist = buddhist[order(buddhist$Pop_2010, decreasing = TRUE),]
buddhist <- buddhist %>% arrange(Pop_2010)

# write this new dataframe to a file
write.csv(buddhist, file = "./buddhist_counties.csv", row.names = FALSE, quote = FALSE)

## get group summaries of religiousity based on population ##

# divide each county into one of six groups based on populations
# note: keep these two lines the same in your updated code!
groups = kmeans(utah$Pop_2010,6) # clusters data into 6 groups based on proximity to mean of potential groups
utah$Pop.Group = groups$cluster # assigns a new variable to utah giving group for each county

# subset to each group and find summary stats on Religiosity for each

groups_religion <- group_by(utah,Pop.Group) %>% summarise(mean(Religious, na.rm = TRUE))
groups_religion <- groups_religion %>% rename(Religiosity_Mean = "mean(Religious, na.rm = TRUE)") #rename
#group1 = mean(utah[utah$Pop.Group == 1,]$Religious)
#group2 = mean(utah[utah$Pop.Group == 2,]$Religious)
#group3 = mean(utah[utah$Pop.Group == 3,]$Religious)
#group4 = mean(utah[utah$Pop.Group == 4,]$Religious)
#group5 = mean(utah[utah$Pop.Group == 5,]$Religious)
#group6 = mean(utah[utah$Pop.Group == 6,]$Religious)

# same, but mean population
groups.pop <- group_by(utah,Pop.Group) %>% summarise(mean(Pop_2010, na.rm = TRUE))
groups.pop <- groups.pop %>% rename(Pop_Mean = "mean(Pop_2010, na.rm = TRUE)") #rename
       
#group1.pop = mean(utah[utah$Pop.Group == 1,]$Pop_2010)
#group2.pop = mean(utah[utah$Pop.Group == 2,]$Pop_2010)
#group3.pop = mean(utah[utah$Pop.Group == 3,]$Pop_2010)
#group4.pop = mean(utah[utah$Pop.Group == 4,]$Pop_2010)
#group5.pop = mean(utah[utah$Pop.Group == 5,]$Pop_2010)
#group6.pop = mean(utah[utah$Pop.Group == 6,]$Pop_2010)


# make data frame of each group and mean religiosity
#religiosity = data.frame(Pop.Group = c("group1","group2","group3","group4","group5","group6"),
 #         Mean.Religiosity = c(group1,group2,group3,group4,group5,group6),
  #         Mean.Pop = c(group1.pop,group2.pop,group3.pop,group4.pop,group5.pop,group6.pop))

 #chop off redundant groups column.
religiosity <- left_join(groups_religion, groups.pop)


religiosity # take quick look at resulting table

# order by decreasing population
#religiosity = religiosity[order(religiosity$Mean.Pop, decreasing = TRUE),]
religiosity <- religiosity %>% arrange(desc(Pop_Mean))

religiosity # take quick look at resulting table


# plot that table (redo this using ggplot)
#plot(x=religiosity$Mean.Pop,y=religiosity$Mean.Religiosity)
ggplot(religiosity, aes(x=Pop_Mean,y=Religiosity_Mean)) + geom_point() + geom_smooth(method = "lm")




#####################################
#              Part 2               #
# Beginning to look at correlations #
# run this code without changing it #
# it's already in very tidy form    #
#####################################

# Look for correlations between certain religious groups and non-religious people
religions = names(utah)[-c(1:4)]

utah %>%
  pivot_longer(names_to = "Religion", values_to = "Proportion",religions) %>%
  ggplot(aes(x=Proportion,y= 1-Religious)) + geom_point() + geom_smooth(method="lm") + lims(y=c(0,1)) +
  facet_wrap(~Religion,scales = "free") + theme_bw() + theme(panel.grid = element_blank(), strip.background = element_rect(fill="Gray")) +
  coord_cartesian(ylim = c(0,1))


# Look through those plots and answer the following questions:
# 1.  Which religious group correlates most strongly in a given area with the proportion of non-religious people?
# 2.  What is the direction of that correlation?
# 3.  What can you say about the relationships shown here?
# 4.  Examine the axis scales. How could you modify the code above to more accurately portray values on an "equal footing?"
# UPLOAD YOUR ANSWERS TO CANVAS
# DON'T FORGET TO PUSH YOUR TIDY CODE TO GITHUB AS WELL!