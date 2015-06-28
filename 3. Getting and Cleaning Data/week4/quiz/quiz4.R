#Quiz4

setwd("F:/Self-Education/John Hopkins Data Science Specialization/3. Getting and Cleaning Data/week4/quiz")

# Question 1

if(!file.exists('data'))
  dir.create('data')

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(url, destfile = 'data/idaho.csv', method = 'curl')  # do not use curl on Windows machines

data <- read.csv('data/idaho.csv')

splitNames <- strsplit(names(data), 'wgtp')
splitNames[[123]]

# Question 2
library(dplyr)

if(!file.exists('data'))
  dir.create('data')

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
download.file(url, destfile = 'data/gdp.csv', method = 'curl')  # do not use curl on Windows machines

colClasses <- c('character', 'character', 'NULL', 'character', 'character', 'character', 'NULL', 'NULL', 'NULL', 'NULL')
gdpData <- read.csv('data/gdp.csv', header = FALSE, colClasses = colClasses, skip = 5, na.strings = c('', '..'))
names(gdpData) <- c('CountryCode', 'ranking', 'country', 'USDmillions', 'X')
gdpData <- filter(gdpData, !is.na(CountryCode) & !is.na(ranking))   # only want the 190 ranked countries

mean(as.numeric(gsub(',', '', gdpData$USDmillions)), na.rm = TRUE)

# Question 3

length(grep('^United', gdpData$country))

# Question 4

if(!file.exists('data'))
  dir.create('data')

url1 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
download.file(url1, destfile = 'data/gdp.csv', method = 'curl')  # do not use curl on Windows machines

url2 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'
download.file(url2, destfile = 'data/edu.csv', method = 'curl')  # do not use curl on Windows machines

colClasses <- c('character', 'character', 'NULL', 'character', 'character', 'character', 'NULL', 'NULL', 'NULL', 'NULL')
gdpData <- read.csv('data/gdp.csv', header = FALSE, colClasses = colClasses, skip = 5, na.strings = c('', '..'))
names(gdpData) <- tolower(c('CountryCode', 'ranking', 'country', 'USDmillions', 'X'))
gdpData <- filter(gdpData, !is.na(countrycode) & !is.na(ranking))   # only want the 190 ranked countries

eduData <- read.csv('data/edu.csv')
names(eduData) <- tolower(names(eduData))
names(eduData)

mergedData <- inner_join(gdpData, eduData, by = 'countrycode')
length(grep('[Ff]iscal *[Yy]ear *[Ee]nd: June', mergedData$special.notes))

# Question 5

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

library(lubridate)
sum(year(sampleTimes) == 2012)

length(sampleTimes[year(sampleTimes) == 2012 & wday(sampleTimes, label = TRUE) == 'Mon'])
