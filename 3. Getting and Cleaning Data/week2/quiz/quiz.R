#Quiz2

#Question 1
library(httr)
library(httpuv) #required for oauth
library(jsonlite)

oauth_endpoints('github')

myapp <- oauth_app('github', '72fb7626dd5c0793b7c3', 'fe681a5b0856640ed2435e5be710ac145e4f8df1')
github_token <- oauth2.0_token(oauth_endpoints('github'), myapp)

req <- GET('https://api.github.com/users/jtleek/repos', config(token = github_token))#print this and derived objects to see structure
stop_for_status(req)
messyData <- content(req)
formattedData <- fromJSON(toJSON(messyData))
formattedData[formattedData$name == 'datasharing',]$created_at

#Question 2
library(sqldf)  #for running sql queries on data frames
setwd("/media/michael/PATRIOT/Self-Education/John Hopkins Data Science Specialization/3. Getting and Cleaning Data/week2/quiz")

if(!file.exists('data')) {
  dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(fileUrl, destfile = 'data/q2data.csv', method = 'curl')
dateDownloaded <- date()
acs <- read.csv('data/q2data.csv')
queryResult1 <- sqldf("select pwgtp1 from acs where AGEP < 50")  #select only the data for the probability weights pwgtp1 with ages less than 50

#Question 3
queryResult2 <- sqldf("select distinct AGEP from acs") #equivalent function to unique(acs$AGEP)

#Question 4
con <- url('http://biostat.jhsph.edu/~jleek/contact.html')
htmlcode <- readLines(con)
close(con)
nLines <- c(nchar(htmlcode[10]), nchar(htmlcode[20]), nchar(htmlcode[30]), nchar(htmlcode[100]))
nLines  #Number of lines in the 10th, 20th, 30th and 100th lines of HTML

#Question 5
if(!file.exists('data')) {
  dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for'
download.file(fileUrl, destfile = 'data/q5data.for', method = 'curl')
fixedWidthData <- read.fwf('data/q5data.for', widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4), skip = 4)
sum(fixedWidthData[[4]])
