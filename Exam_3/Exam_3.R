library(tidyverse)
library(broom)
# Part I: Cleaning Up After Birds
#This exam uses Exam_3.Rproj found in the Exam_3 folder.

#I.      Load and clean FacultySalaries_1995.csv file
#Re-create the graph shown in "fig1.png"
#Export it to your Exam_3 folder as LASTNAME_Fig_1.jpg (note, that's a jpg, not a png)
#Please pay attention to what variables are on this graph.  This task is 
#really all about whether you can make a tidy dataset out of something
#a bit wonky. Refer back to the video where we cleaned "Bird_Measurements.csv"

#-------------------------------------------------------

#Part I - Cleaning and Plotting Salaries

rawfsal <- read.csv("./FacultySalaries_1995.csv")
#This line reads the uncleaned faculty salaries data into an object named rawfsal

#View(rawfsal)
#I see a few problems...

cleanfsal <- rawfsal
cleanfsal$Tier <- as.factor(rawfsal$Tier)
class(cleanfsal$Tier)

#summary(rawfsal)

#Now to rename the pay collumns to what I need in the final graph.
cleanfsal <- rename(cleanfsal, Full = AvgFullProfComp)
cleanfsal <- rename(cleanfsal, Assoc = AvgAssocProfComp)
cleanfsal <- rename(cleanfsal, Assist = AvgAssistProfComp)

#View(cleanfsal)

#Now to put the salaries all into one column and make another called Rank.
cleanfsal <- pivot_longer(cleanfsal, c("Full","Assoc","Assist"),
             names_to ="Rank",
             values_to="Salary")
cleanfsal$Rank <- as.factor(cleanfsal$Rank)

#View(cleanfsal)
#It could use some modifications to omit rank VIIB colleges.
modfsal = filter(cleanfsal, Tier == c("I", "IIA", "IIB"))
#unique(modfsal$Tier)
#unique(cleanfsal$Tier)

#Looks clean, now I believe it is time to plot it.

ggplot(modfsal,aes(x=Rank,y=Salary)) +
  geom_boxplot(aes(fill=Rank)) +
  facet_wrap(~Tier) +
  theme_minimal() +
  coord_cartesian(ylim = c(200,1050))

ggsave("./BALDWIN_Fig_1.jpg")

#Something strange is happening, the filters just makes it break...
#I will have to go with the extra rank in there.

ggplot(cleanfsal,aes(x=Rank,y=Salary)) +
  geom_boxplot(aes(fill=Rank)) +
  facet_wrap(~Tier) +
  theme_minimal() +
  coord_cartesian(ylim = c(200,1050))

ggsave("./BALDWIN_Fig_1.jpg")

#-------------------

#Juniper Oils
junframe <- read.csv("./Juniper_Oils.csv")
cleanframe <- pivot_longer(junframe,c("alpha.pinene","para.cymene","alpha.terpineol",
                        "cedr.9.ene","alpha.cedrene","beta.cedrene",
                        "cis.thujopsene","alpha.himachalene","beta.chamigrene",
                        "cuparene","compound.1","alpha.chamigrene","widdrol",
                        "cedrol","beta.acorenol","alpha.acorenol",
                        "gamma.eudesmol","beta.eudesmol","alpha.eudesmol",
                        "cedr.8.en.13.ol","cedr.8.en.15.ol","compound.2",
                        "thujopsenal"),
             names_to="Compound",values_to="Concentration")

ggplot(cleanframe, aes(y=Concentration,x=YearsSinceBurn)) +
  geom_smooth() +
  facet_wrap(~Compound) +
  theme_minimal()

ggsave("./BALDWIN_Fig_2.jpg")

?tidy

