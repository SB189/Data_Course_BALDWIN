What <- read.csv("../../Data/ITS_mapping.csv", sep = cat("_", " ", "_", fill = TRUE, blank.lines.skip = TRUE))
What <- read.table("../../Data/ITS_mapping.csv", sep = cat("_", " ")) # This one will not even run.
#It appears that is is seperated by underscores and spaces. Even with that something is still wrong.
# For some reason there are underscores it refuses to split...
# The only column in alignment is the first one... It is as if it is ignore columns.
#Yeah, I am not figuring this out on my own. It just won't take it.

?read.csv
summary(What) 
head(What) 
dim(What) 
str(What)



#  + Somehow summarize all of the columns and do a bit of additional exploration (play with some functions)
str(What$Type.Host)
str(What[0,1:16])


# Make a boxplot where "Ecosystem" is on the x-axis and "Lat" is on the y-axis
