# Data Cleaning Practice

# do the top ten most stable countries grow more apples or oranges (in total volume)
# what is the average amount of railroad in countries that grow more apples than oranges, and vis versa.

# if(!file.exists('data')) {
#   dir.create('data')
# }
# 
# ao_url <- 'https://www.dropbox.com/s/fjeld6rv81jg06f/appleorange.csv'
# stability_url <- 'https://www.dropbox.com/s/t7jq9d8esip1aqj/stability.csv'
# download.file(ao_url, destfile = 'data/appleorange.csv', method = 'curl')
# download.file(stability_url, destfile = 'data/stability.csv', method = 'curl')

ao <- read.csv('data/appleorange.csv')
str(ao)  # mess

aoraw <- read.csv("data/appleorange.csv", stringsAsFactors=FALSE, header=FALSE)
head(aoraw,10)
tail(aoraw,10)
#so the data are actually between rows 3 and 700

aodata <- aoraw[3:700,]
names(aodata) <- c("country", "countrynumber", "products", "productnumber", "tonnes", "year")
aodata$countrynumber <- as.integer(aodata$countrynumber)
edit(aodata)

# The observations on 'Food supply quantity' are noise and should be removed
fslines <- which(aodata$country == "Food supply quantity (tonnes) (tonnes)")
aodata <- aodata[(-1 * fslines),]  
edit(aodata)

# The tonnes field needs find and replacement of text n order to make it suitable for conversion to numeric
aodata$tonnes <- gsub("\xca", "", aodata$tonnes)
aodata$tonnes <- gsub(", tonnes \\(\\)", "", aodata$tonnes)
aodata$tonnes <- as.numeric(aodata$tonnes)

# For completeness, adding year which was listed at top of file
aodata$year <- 2009

# Want to format the data so that there is only one line per country instead of multiples instances of the same country so that
# the merging of the files doesn't blow up to a massive number.  Want to go from long data to wide data.

# METHOD 1
# Make a subset of the apple tonnes and a subset of the orange tonnes; use the merge function, joining them together 
# by the country identifier, in order to get wide data.
apples <- aodata[aodata$productnumber == 2617, c(1,2,5)]
names(apples)[3] <- "apples"
oranges <- aodata[aodata$productnumber == 2611, c(2,5)]
names(oranges)[2] <- "oranges"
cleanao2 <- merge(apples, oranges, by="countrynumber", all=TRUE)

#METHOD 2
# It is easy to rearrange data using reshape2
library(reshape2)
cleanao3 <- dcast(aodata[,c(1:3,5)], formula = country + countrynumber ~ products, value.var="tonnes")
names(cleanao3)[3:4] <- c("apples", "oranges")

# Identifying potential problem entries
cleanao2[!(complete.cases(cleanao2)),]
cleanao3[!(complete.cases(cleanao3)),]

# Identifying those entries that have an apple or an orange entry, but not both
table(aodata$country)[table(aodata$country) == 1]
#These manner of missing values can cause issues if sloppy merging methods are used

#This uses essentially the same process as with the other sheet (but then they did come from the same data source- the FAO- so 
#you would expect the data organisation to be the same). So it is find the data, fix variable names, clear out unwanted heading 
#rows, remove the added textfrom the actual measurements so we can make it a numeric variable, make it wide data for the merge. 
#It is just with what is essentially three variables in the one file, we need to fix each thing in three different ways.
stblraw <- read.csv("data/stability.csv", stringsAsFactors=FALSE, header=FALSE)
stbldata <-stblraw[6:960,]
names(stbldata) <- c("country", "countrynumber", "measure", "measurecode", "score", "year")
stbldata$countrynumber <- as.integer(stbldata$countrynumber)
edit(stbldata)

#clear out the headings that are not country names
vilines <- which(stbldata$country == "Value (index)")
stbldata <- stbldata[(-1 * vilines),]
vklines <-which(stbldata$country == "Value (kcal/capita/day)")
stbldata <- stbldata[(-1 * vklines),]
v100lines <-which(stbldata$country == "Value (per 100 square km of land area)")
stbldata <- stbldata[(-1 * v100lines),]
edit(stbldata)

#remove the text in the numbers column
stbldata$score <- gsub(", index \\(\\)", "", stbldata$score)
stbldata$score <- gsub(", per 100 square km of land area \\(\\)", "", stbldata$score)
stbldata$score <- gsub(", kcal/capita/day \\(\\)", "", stbldata$score)
stbldata$score <- as.numeric(stbldata$score)
stbldata$year <- 2009

#make the measures a bit more suitable for becoming headings
stbldata$measure[stbldata$measure =="Rail-lines density (per 100 square km of land area)"] <- "railLines"
stbldata$measure[stbldata$measure =="Per capita food supply variability (kcal/capita/day)"] <- "foodVariation"
stbldata$measure[stbldata$measure =="Political stability and absence of violence/terrorism (index)"] <- "stability"

#use the reshape2 to cast the data into wide format
library(reshape2)
cleanst3 <- dcast(stbldata[,c(1:3,5)], formula = country + countrynumber ~ measure, value.var="score")

# Having two clean data sets, cleanao3 and cleanst3, that share a country name and code in common, we can bring the information 
# together. Because we have a code number, we would normally join on that, but for the purposes of demonstration let's have a 
# look at what happens with joining by the name of the country.

# If we want a result which only contains entries for countries that are in both tables, we want the option 
mergeddata <- merge(cleanao3, cleanst3, by="country")

# Which is going with the default value of all=FALSE. If we want all the entries in cleanao3 (the first part of the merge, 
# the x value) with the information from the other combined if avaliable, we want
mergeddata <- merge(cleanao3, cleanst3, by="country", all.x = all)

# If we want all of the information from cleanst3 plus the information 
mergeddata <- merge(cleanao3, cleanst3, by="country", all.y = all)

# If we want all of the information for both, with blank entries on either side where it cannot find a match, then the appropriate 
# version is 
mergeddata <- merge(cleanao3, cleanst3, by="country", all = TRUE)

# Because the match is being made on the country name, one thing we want to have a think about is if there are country names that 
# are meant to be the same country, but the text is not identical. In those cases it will fail to find a match when there should 
# be a match.
#
# If we are doing a default merge, the country will be left out of the final set.
# If we are using all.x or all.y we will only get half the information for the country.
# If we are merging with all=TRUE, then we will get two half entries rather than one full entry.
# 
# So, let's see what records it is going to have problems with, by seeing what countries are in cleanao3 that it will not be able 
# to find a match for in cleanst3
cleanao3$country[!(cleanao3$country %in% cleanst3$country)]

# This says "find all the countries in cleanst3" then uses the ! operator to reverse it, tell R those are the ones we do not want. 
# We get character(0), which means a character vector of length 0 so it could not find any that were not in cleanst3. We check 
# the other way with
cleanst3$country[!(cleanst3$country %in% cleanao3$country)]

# From which we get the list of countries for which we have political stability information but no information about apples 
# or oranges. If we had any countries which had been on both lists under slightly different names, we would have needed to do 
# some corrections to the data so that they matched. But in this case it is just we have more countries with stablity data, 
# though we knew that from nrow(cleanao3) and nrow(cleanst3). What we now know is that there are no unwanted differences in 
# country names.

# So we consider what kind of merge is appropriate to the question and use that form of merge().

# Finally we are at a point where we can make nice neat subsets and summaries.