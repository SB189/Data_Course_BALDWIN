?read.table()
df <-  read.csv("../../Data/landdata-states.csv")
class(df) # class is data.frame
head(df) #ran it
?read.csv

class(df$State) #character
class(df$Date) #numeric

df <-  read.csv("../../Data/landdata-states.csv", colClasses = c(State = "character")) 
# ^ from Q4 ^

dim(df) # 7803 11 or 7803 rows and 11 collumns.
str(df) # 7803 obs. of 11 variables and a summary before it runs out of room.
summary(df) # It gave me a lot of stats on each category. Quartiles.

hist(df$Land.Value)
plot(x=df$region,y=df$Land.Value)
plot(x=df$Year,y=df$Land.Value) # uuuuuuh. It somehow pasted into the code itself.

plot(x=df$Year,y=df$Land.Value,col=df$region)