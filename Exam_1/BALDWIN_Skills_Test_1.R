# Exam_1

# -- PART 1 --

#Reading In

#Run this line
dat1 <- read.csv("./DNA_Conc_by_Extraction_Date.csv")

#This next paragraph is just poking around.
# DNA_Concentration_Katy , DNA_Concentration_Ben
Thing[1:200] <- c("Ben")
Thing[201:400] <- c("Katy")
Thing_Factor <- as.factor(Thing)
View(Thing)
Benty <- c(dat1$DNA_Concentration_Ben, dat1$DNA_Concentration_Katy)
View(Benty)
Plotty <- data.frame(Who = Thing_Factor, DNA_Concentrations = Benty)

#These are the solutions to part 1.
#Katy's Histogram
hist(dat1$DNA_Concentration_Katy, main = "Katy's DNA concentrations", xlab = "DNA Concentration")
#Ben's Histogram
hist(dat1$DNA_Concentration_Ben, main = "Ben's DNA concentrations", xlab = "DNA Concentration")

# -- PART 2 --

#Checking the class, it is wrong.
class(dat1$Year_Collected)
cookie <- as.factor(dat1$Year_Collected)
#Ben's Solution
Dayda <- data.frame("Annum" = cookie, "BenDatum" = dat1$DNA_Concentration_Ben)
plot(Dayda, main = "Ben's Extractions", xlab = "YEAR", ylab = "DNA Concentration")
#Katy's Solution
Dada <- data.frame("Annum" = cookie, "KatyDatum" = dat1$DNA_Concentration_Katy)
plot(Dada, main = "Katy's Extractions", xlab = "YEAR", ylab = "DNA Concentration")

# -- PART 3 - Saving My Dastardly Plots --

#Katy
jpeg("./BALDWIN_Plot1.jpeg")
plot(Dada, main = "Katy's Extractions", xlab = "YEAR", ylab = "DNA Concentration")
dev.off()
#Ben
jpeg(filename = "./BALDWIN_Plot2.jpeg")
plot(Dayda, main = "Ben's Extractions", xlab = "YEAR", ylab = "DNA Concentration")
dev.off()

# -- Part 4: -- This problem does not say how I need to compare their data, so I will compare the means.

# Ben's Means
#example: Plotty <- data.frame(Who = Thing_Factor, DNA_Concentrations = Benty)
setof = c(1:13)
i = 0
bmeanies = c(NULL)
for (i in setof)
{
  annum = 1999 + i
  #annum = 2000
 Question <- dat1$Year_Collected == annum
  bucket <- dat1[Question,]
  thang = as.numeric(mean(bucket$DNA_Concentration_Ben))
  bmeanies <- c(bmeanies, thang)
  #View(bmeanies)
}

# Katy's Means
setof = c(1:13)
i = 0
kmeanies = c(NULL)
for (i in setof)
{
  annum = 1999 + i
  #annum = 2000
  Question <- dat1$Year_Collected == annum
  bucket <- dat1[Question,]
  thang = as.numeric(mean(bucket$DNA_Concentration_Katy))
  kmeanies <- c(kmeanies, thang)
  #View(kmeanies)
}
# ~ Subtracting Means ~
diffmeans = c(NULL)
diffmeans = bmeanies - kmeanies
diffmeans[10] <- 1337 #For some reason it thinks "NA" is the lowest value, so I
# instead set it to an arbitrarily high value. There were no observations in this
# year so technically it was the lowest performance of Ben over Katy.
# Nonetheless, I do not think this is the answer we want, so it is removed
#by 1337

#View(diffmeans)

# ~ This next bit find the lowest difference between means.~
minvalue <- min(diffmeans)
comparisonset <- data.frame(Year = 2000:2012, performance_difference = diffmeans) #aligning years with values
yearlowrowbool <- minvalue == comparisonset$performance_difference
lowestrow <- comparisonset[yearlowrowbool,]
print(c("The answer is", lowestrow$Year)) #Prints year into terminal
#View(yearlowrowbool)
#View(lowestrow)
#?filter
# PHEEEEEEEEW. I tried filter again and again. Never did what I wanted.

# -- Part 5 -- 

#class(dat1$Date_Collected)
#?print.POSIXct(dat1$Date_Collected)
truth = dat1$Lab == "Downstairs"
downstairs <- dat1[truth,]
gooddate <- as.Date(downstairs$Date_Collected)
gooddata <- downstairs$DNA_Concentration_Ben
goodset <- data.frame(Date_Collected = gooddate, DNA_Concentration_Ben = gooddata)
plot(goodset)
jpeg("./Ben_DNA_over_time.jpg")
plot(goodset)
dev.o
#View(goodset)
#View(gooddate)
#View(downstairs)
#class(gooddate)
#class(dat1$Date_Collected)


# -- Part 6 -- BWAHAHAH! I already did all this in #4. Copy and paste time.

setof = c(1:13)
i = 0
bmeanies = c(NULL)
for (i in setof)
{
  annum = 1999 + i
  #annum = 2000
  Question <- dat1$Year_Collected == annum
  bucket <- dat1[Question,]
  thang = as.numeric(mean(bucket$DNA_Concentration_Ben))
  bmeanies <- c(bmeanies, thang)
  #View(bmeanies)
}
answer <- data.frame(Years = 2000:2012, "Year Average" = bmeanies)
write.csv(answer,"./Ben_Average_Conc.csv")
dev.off()