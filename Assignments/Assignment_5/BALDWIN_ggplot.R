#
# I am assuming that this is being done from my main folder.
#

library(tidyverse)
library(carData)
library(RColorBrewer)
library(colorblindr)
#1)
data(iris)
#2)

#Plot 1
p1 <- ggplot(iris,aes(y=Petal.Length,x=Sepal.Length),color = Species) +
  geom_point(aes(color = Species)) + geom_smooth(method = "lm",aes(color = Species)) +
  coord_cartesian(y=c(1,7),x=c(5,8)) + theme_minimal() +
  labs(title = "Sepal length vs petal length", subtitle = "for three iris species")
p1

#Save Plot 1
jpeg("./Assignments/Assignment_5/iris_fig1.png")
p1
dev.off()

#Plot 2
p2 <- ggplot(iris,aes(x = Petal.Width, fill = Species)) + geom_density(alpha = .5) +
  labs(title = "Distribution of Petal Widths", x = "Petal Width", subtitle = "for three iris species") +
   theme_minimal()
p2

#Save Plot 2
jpeg("./Assignments/Assignment_5/iris_fig2.png")
p2
dev.off()

#Plot 3
p3 <- ggplot(iris,aes(x = Species, y = Petal.Width / Sepal.Width, fill = Species)) +
  geom_boxplot() + labs(title = "Sepal- to Petal-Width Ratio", subtitle = "for three iris species",
                        y = "Ratio of Sepal Width to Petal Width") + theme_minimal()
p3

#Save Plot 3
jpeg("./Assignments/Assignment_5/iris_fig3.png")
p3
dev.off()

#Challenge Plot

#poke <- model.frame(iris)
#?model
#objecto <- poke[1:150,1]
#class(object)
#is.recursive(objecto)
#is.recursive(iris)
#deviance(poke)
#devious <- model.frame(deviance(object = iris$Sepal.Length))
#View(hektor)
#?deviance()
#str(objecto)
#View(objecto)
#class(thing1$iris.Species)
#str(thing1)
?geom_bar
#Oh look, a note
avg1 <- mean(iris$Sepal.Length)
thing1 = data.frame(iris$Species)
store <- iris$Sepal.Length - avg1
thing1[,2] <- data.frame(store)
thing1 <- thing1[order(thing1$store), ]
#View(thing1)
p4 <- ggplot(thing1,aes(x = iris.Species, y = store, label=store)) + 
  geom_bar(stat = "identity", aes(fill = iris.Species), width = .5) +
  scale_fill_manual() +
  scale_fill_manual(name="Species", 
                    labels = c("setosa", "versicolor", "virginica"), 
                    values = c("versicolor"="#00ba38", "setosa"="#f8766d", "virginica" = "#34cfeb")) +
  coord_flip()
p4

