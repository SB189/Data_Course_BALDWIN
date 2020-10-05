data(mtcars)
str(mtcars)
?mtcars
library(ggplot2)
library(patchwork)

#Start Here.
data(mtcars)

#Subset automatic cars into autocar.
auto <- mtcars$am == 0
autocar <- mtcars[mtcars$am == 0,]

#Save as a CSV.
write.csv(autocar, "./automatic_mtcars.csv")

#My evil plot
p1 <- ggplot(mtcars, aes(x=hp,y=mpg)) + geom_point() + geom_smooth(method = "lm") +
  labs(title = "Miles Per Gallon vs Horse Power", x = "Horse Power", y = "Miles Per Gallon")
p1
p1 + coord_cartesian(xlim=c(60,350),ylim=c(0,40))

#Saving My Plot
ggsave("./mpg_vs_hp_auto.png", width = 6, height = 4, dpi = 700)

#My second evil plot. wt vs mpg
p2 <- ggplot(mtcars, aes(x=wt,y=mpg)) + geom_point() + geom_smooth(method = "lm") +
  labs(title = "Miles Per Gallon vs Weight", x = "Weight", y = "Miles Per Gallon")
p2
p2 + coord_cartesian(xlim=c(1.8,6),ylim=c(0,40))

#Saving This tiff
ggsave("./mpg_vs_wt_auto.tiff", width = 6, height = 4, dpi = 700)

#Subsetting disp <= 200 into petite
smiley <- mtcars$disp <= 200
petite <- mtcars[smiley == TRUE,]

#Saving petite
write.csv(petite, "./mtcars_max200_displ.csv")

#Find the max for hp mtcars, autocar and petite
mmtcars <- as.character(max(mtcars$hp))
mautocar <- as.character(max(autocar))
mpetite <- as.character(max(petite))

#get it into a .txt
add.strong[1:9] <- paste('The maximum horsepower for all cars in mtcars, automatic ', 
                      'cars in mtcars and mtcars with a displacement equal to ', 
                      'or less than two hundred are: ', mmtcars, 
                     ', ', mautocar, ' and ', mpetite, ' respectively.')

#I realize I did not have to do it like this now, did not when I made it.
line1 = "The maximum horsepower for all cars in mtcars and automatic "
line2 = "cars in mtcars and mtcars with a displacement equal to "
line3 = "or less than two hundred are: "
line4 = mmtcars
line5 = ", "
line6 = mautocar
line7 = " and "
line8 = mpetite
line9 = " respectively."
strong <- paste(line1,line2,line3,line4,line5,line6,line7,line8,line9)

#Saving the data as a sensible .txt file.
write(strong,"./hp_maximums.txt")

#Patchwork Plot
#?`patchwork-package

#First creating the plots
q1 <- ggplot(mtcars, aes(x=cyl,y=mpg, fill = as.factor(cyl))) +
  geom_violin() + labs(color = "Cylinder Count") + labs(fill = "Cylinder Count")

q2 <- ggplot(mtcars, aes(x=hp,y=mpg,color=as.factor(cyl))) + geom_point() + 
  geom_smooth(method = "lm") +
  labs(title = "Miles Per Gallon vs Horse Power", x = "Horse Power", y = "Miles Per Gallon") +
   coord_cartesian(xlim=c(60,350),ylim=c(0,40)) +
  labs(color = "Cylinder Count")

q3 <- ggplot(mtcars, aes(x=wt,y=mpg,color = as.factor(cyl))) + geom_point() + geom_smooth(method = "lm") +
  labs(title = "Miles Per Gallon vs Weight", x = "Weight", y = "Miles Per Gallon") + 
  coord_cartesian(xlim=c(1.8,6),ylim=c(0,40)) + labs(color = "Cylinder Count")
q4 <- q1 + q2 + q3
q4
ggsave("./combined_mtcars_plot.png", width = 15, height = 4, dpi = 800)
#DONE AAAAAA

                    