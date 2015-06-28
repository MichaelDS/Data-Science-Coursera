# Course Project

## download and decompress the raw data
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, 'UCI HAR Data.zip', method = 'curl') # DO NOT USE method = 'curl' ON WINDOWS MACHINES
unzip('UCI HAR Data.zip')

## read and store the feature names in a vector
features <- read.table('UCI HAR Dataset/features.txt')
features <- as.character(features[[2]])

## read in the test data and set column names using the col.names argument 
X_test <- read.table('UCI HAR Dataset/test/X_test.txt', col.names = features) 

## read in the subject and activity vectors
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt')
y_test <- read.table('UCI HAR Dataset/test/y_test.txt')

## merge the subject and activity vectors and the subset of X_test variables pertaining to mean and standard deviation
X_test <- cbind(subject_test, y_test, X_test[, grepl('mean|std', names(X_test)) & !grepl('meanFreq', names(X_test))])
names(X_test)[1:2] <- c('subject', 'activity')  # name the subject and activity columns

## read in the training data and set column names using the col.names argument 
X_train <- read.table('UCI HAR Dataset/train/X_train.txt', col.names = features)

## read in the subject and activity vectors
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt')
y_train <- read.table('UCI HAR Dataset/train/y_train.txt')

## merge the subject and activity vectors and the subset of X_train variables pertaining to mean and standard deviation
X_train <- cbind(subject_train, y_train, X_train[, grepl('mean|std', names(X_train)) & !grepl('meanFreq', names(X_train))])
names(X_train)[1:2] <- c('subject', 'activity') # name the subject and activity columns

## merge the training and test data and coerce the subject column to a factor vector
mergedData <- rbind(X_test, X_train)
mergedData$subject <- as.factor(mergedData$subject)

## replace the activity codes with activity descriptions and coerce the column to a factor vector
library(qdap)
activityCodes <- c('1', '2', '3', '4', '5', '6')
activities <- c('WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING')
mergedData$activity <- mgsub(activityCodes, activities, mergedData$activity)
mergedData$activity <- as.factor(mergedData$activity)

## reconstruct the variable names so that they don't use abbreviations, are all lowercase, and use underscores for separation
splitNames <- strsplit(names(mergedData), '\\.|\\.\\.|\\.\\.\\.')
concatNames <- tolower(sapply(splitNames, paste0, collapse = ''))
patterns <- c('acc', 'gyro', 'mag', 'mean', 'std', 'bodybody', 'jerk', 'x$', '([^t])y$', 'z$')
replacements <- c('accelerometer', 'gyroscope', '_magnitude', '_mean', '_standarddeviation', 'body', '_jerk', '_x', '\\1_y', '_z') 
finalNames <- mgsub(patterns, replacements, concatNames, fixed = FALSE)

names(mergedData) <- finalNames  # assign the new variable names

# tapply(mergedData$tBodyAcc.mean...X, mergedData$subject, mean)

## group and average the processed data by subject and activity in order to produce the final dataset
library(dplyr)
tidy_data <- mergedData %>% group_by(subject, activity) %>% summarise_each(funs(mean))

write.table(tidy_data, 'tidy_data.txt', row.names = FALSE)  # write the summarized data to a file
