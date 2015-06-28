#Question 11
data <- read.csv('hw1_data.csv')
names(data)

#Question 12
data[1:2,]

#Question 13
nrow(data)

#Question 14
tail(data, 2)

#Question 15
data[['Ozone']][47]
data$Ozone[47]
data[47, 'Ozone']

#Question 16
sum(is.na(data$Ozone))

#Question 17
mean(data$Ozone)
mean(data$Ozone, na.rm = TRUE)

#Question 18
subset <- data[data$Ozone > 31 & data$Temp > 90, ]
subset
mean(subset$Solar.R, na.rm = TRUE)

data[data$Ozone > 31 & data$Temp > 90, 'Solar.R']

#Question 19
mean(data[data$Month == 6,]$Temp, na.rm = TRUE)
mean(data[data$Month == 6, 'Temp'], na.rm = TRUE)

#Question 20
max(data[data$Month == 5,]$Ozone, na.rm = TRUE)
max(data[data$Month == 5, 'Ozone'], na.rm = TRUE)
