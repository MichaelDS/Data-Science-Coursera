#Quiz1

#This script is linux-compatible; will need slight modifications to work on Windows

#The corresponding data dictionary was referenced for this quiz

#Question 1
setwd("/media/michael/PATRIOT/Self-Education/John Hopkins Data Science Specialization/3. Getting and Cleaning Data/Week1/quiz")

if (!file.exists('data')) {
  dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(fileUrl, destfile = 'data/housing.csv', method = 'curl')
#download.file(fileUrl, destfile = 'data/housing.csv')  #Use this line instead for Windows
dateDownloaded1 <- date()
data <- read.csv('data//housing.csv')
value <- data[['VAL']]
sum(value == 24, na.rm = TRUE)

#Question 3
library(xlsx)

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
download.file(fileUrl, destfile = 'data/naturalGas.xlsx', method = 'curl')
#download.file(fileUrl, destfile = 'data/naturalGas.xslx', mode = 'wb')  #Use this line instead for Windows
dateDownloaded2 <- date()
dat <- read.xlsx('data/naturalGas.xlsx', sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
sum(dat$Zip*dat$Ext, na.rm = TRUE)

#Question 4
library(XML)

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
fileUrl2 <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml' #For some reason, the xml doc isn't properly parsed when using https, but works when using http
#download.file(fileUrl, destfile = 'data/restaurants.xml', method = 'curl') #Not necessary, but I wanted the xml
doc <- xmlTreeParse(fileUrl2, useInternal = TRUE)
dateDownloaded3 <- date()
rootNode <- xmlRoot(doc)
xpathSApply(rootNode, 'count(//row[zipcode=21231])', xmlValue)

zipcodes <- xpathSApply(doc, '//zipcode', xmlValue)
sum(zipcodes == '21231')
length(zipcodes[zipcodes == '21231'])

#Question 5
library(data.table)

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(fileUrl, destfile = 'data/idaho.csv', method = 'curl')
#download.file(fileUrl, destfile = 'data/idaho.csv') #Use this line instead for Windows
DT <- fread('data//idaho.csv')
DT[, mean(pwgtp15), by = SEX]
system.time(DT[, mean(pwgtp15), by = SEX])
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(mean(DT[DT$SEX==1,]$pwgtp15))
system.time(mean(DT[DT$SEX==2,]$pwgtp15))
