#Quiz 3

#Question 1

library(datasets)
data(iris)
?iris

tapply(iris$Sepal.Length, iris$Species, mean)[['virginica']]


#Question 2

apply(iris[, 1:4], 2, mean)


#Question 3

library(datasets)
data(mtcars)
?mtcars

#All of the following are equivalent
tapply(mtcars$mpg, mtcars$cyl, mean)
sapply(split(mtcars$mpg, mtcars$cyl), mean)
with(mtcars, tapply(mpg, cyl, mean))

#Question 4

hpByCyls <- tapply(mtcars$hp, mtcars$cyl, mean)
abs(hpByCyls[['4']] - hpByCyls[['8']])


#Question 5

debug(ls)
