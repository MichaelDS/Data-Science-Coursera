#Quiz3

setwd("/media/michael/PATRIOT/Self-Education/John Hopkins Data Science Specialization/3. Getting and Cleaning Data/week3/quiz")

# Question 1

if(!file.exists('data')) {
  dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
codeBookUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf'

download.file(fileUrl, destfile = 'data/housing.csv', method = 'curl')  # do not use method = 'curl' on Windows
download.file(codeBookUrl, destfile = 'data/housingCodeBook.pdf', method = 'curl')
dataDownloaded1 <- date()

data <- read.csv('data/housing.csv')
agricultureLogical <- data$ACR == 3 & data$AGS == 6
which(agricultureLogical)

# Question 2

library(jpeg)
if(!file.exists('data')) {
  dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg'

download.file(fileUrl, destfile = 'data/picture.jpg', method = 'curl')
dateDownloaded2 <- date()

nativeRasterIMG <- readJPEG('data//picture.jpg', native = TRUE)

quantile(nativeRasterIMG, c(.30, .80))

# Question 3

if(!file.exists('data')) {
  dir.create('data')
}

GPD_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv'
EDU_url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv'

download.file(GPD_url, destfile = 'data/gdp.csv', method = 'curl')
download.file(EDU_url, destfile = 'data/edu.csv', method = 'curl')

#gdpData requires cleaning
gdpData <- read.csv('data/gdp.csv')
str(gdpData)
gdpData <- read.csv('data/gdp.csv', header = FALSE, stringsAsFactors = FALSE)
str(gdpData)
head(gdpData)
tail(gdpData)
gdpData <- gdpData[,c(1,2,4,5)]
names(gdpData) <- c('CountryCode', 'ranking', 'country', 'USD(millions)')
gdpData[gdpData == '' | gdpData == '..'] <- NA
gdpData <- gdpData[rowSums(is.na(gdpData)) != 4,]
head(gdpData)
tail(gdpData)
dim(gdpData)
gdpData <- gdpData[4:231,]
gdpData <- gdpData[!is.na(gdpData$ranking),]

eduData <- read.csv('data/edu.csv')

mergedData <- merge(gdpData, eduData, by = 'CountryCode')  #
length(mergedData$CountryCode)
mergedData$ranking <- as.numeric(mergedData$ranking)
mergedData[order(mergedData$ranking, decreasing = TRUE), ][13, ]

## Alternative streamlined solution to Question 3 
library(dplyr)
colClasses <- c('character', 'character', 'NULL', 'character', 'character', 'character', 'NULL', 'NULL', 'NULL', 'NULL')
gdpData <- read.csv('data/gdp.csv', header = FALSE, colClasses = colClasses, skip = 5, na.strings = c('', '..'))
names(gdpData) <- c('CountryCode', 'ranking', 'country', 'USDmillions', 'X')
gdpData <- filter(gdpData, !is.na(CountryCode))

eduData <- read.csv('data/edu.csv')

mergedData <- merge(gdpData, eduData, by = 'CountryCode')
mergedData <- mergedData %>% filter(!is.na(ranking)) %>% mutate(ranking = as.integer(ranking), USDmillions = as.numeric(gsub(",","", USDmillions))) %>% arrange(desc(ranking))
mergedData$ranking
nrow(mergedData)
mergedData[13,]$country

#may have wanted to remove unused columns

# Question 4

group_by(mergedData, Income.Group) %>% summarize(mean(ranking))
tapply(mergedData$ranking, mergedData$Income.Group, mean)

# Question 5

library(Hmisc)
mergedData$ranking.Group <- cut2(mergedData$ranking, g = 5)
table(mergedData$ranking.Group, mergedData$Income.Group)
