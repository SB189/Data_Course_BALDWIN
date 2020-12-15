library(tidyverse)

# Part I ####
#read it in.
 dat1 <- read.csv("./DNA_Conc_by_Extraction_Date.csv")
 
#Make histograms (first set)...

 #Katy's Histogram
hist(dat1$DNA_Concentration_Katy, main = "Katy's DNA concentrations",
      xlab = "DNA Concentration")
 
 #Ben's Histogram
hist(dat1$DNA_Concentration_Ben, main = "Ben's DNA concentrations",
      xlab = "DNA Concentration")
 
# Part II & III####
#Make the specific histograms from the images.

#class(dat1$Year_Collected) [1] "integer"
#class(dat1$DNA_Concentration_Katy) [1] [1] "numeric"

#Making year into a factor.
dat2 <- dat1
dat2$Year_Collected <- as.factor(dat2$Year_Collected)

katy_df <- select(dat2,YEAR = Year_Collected, DNA_Concentration = DNA_Concentration_Katy)
ben_df <- select(dat2,YEAR = Year_Collected, DNA_Concentration = DNA_Concentration_Ben)

#Similar enough.

#Katy
jpeg("./BALDWIN_Plot1.jpeg")
plot(katy_df, main = "Katy's Extractions", xlab = "YEAR",
     ylab = "DNA Concentration", col="#ffffff", scale) +
dev.off()
#Ben
jpeg(filename = "./BALDWIN_Plot2.jpeg")
plot(ben_df, main = "Ben's Extractions", xlab = "YEAR",
     ylab = "DNA Concentration", col="#ffffff")
dev.off()

#Part IV###

#Saying the year in which there was a minimum difference between the two.
dat2$difference = ben_df$DNA_Concentration - katy_df$DNA_Concentration
dat3 <- arrange(dat2,dat2$difference)
year <- as.character(dat3[1,1])
paste("The year in which Ben's DNA concentration was the lowest relative",
      "to Sally's was", year, sep = " ")
dat4 <- dat3 #Doing this to save myself class pain in the future.
#Part V####
dat3$Date_Collected <- as.POSIXct(dat3$Date_Collected)

Downstairs_Ben <- filter(dat3, Lab == "Downstairs") %>% 
   select(Date_Collected = Date_Collected,
          DNA_Concentration_Ben = DNA_Concentration_Ben)

jpeg("./Ben_DNA_over_time.jpeg")
plot(Downstairs_Ben)
dev.off()

#Bonus Problem####

ben_year_avgs <- filter(dat4, Lab == "Downstairs") %>% 
   select(Year_Collected = Year_Collected,
          DNA_Concentration_Ben = DNA_Concentration_Ben) %>% 
   group_by(Year_Collected) %>%
   summarise(mean(DNA_Concentration_Ben))


  ben_year_avgs <- rename(ben_year_avgs,
                          DNA_Concentration_Ben = "mean(DNA_Concentration_Ben)")
  
  ben_year_avgs <- arrange(ben_year_avgs,desc(DNA_Concentration_Ben))
  years <- as.vector(ben_year_avgs$Year_Collected)
  bmaxyear <- years[1]
  bmaxconc <- as.character(ben_year_avgs[1,2])
  paste("The year of maximum concentration for Ben was", bmaxyear,
        "and the concentration was", bmaxconc, sep = " ")
  
  write.csv(ben_year_avgs, "Ben_Average_Conc.csv")
  

