unzip('rprog_data_ProgAssignment3-data.zip')

outcome <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
head(outcome)

outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])

best <- function(state, outcome) {
  measures <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
  
  if(!(state %in% measures$State))
    stop('invalid state')
  
  if(outcome == 'heart attack') 
    outcome <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
  else if(outcome == 'heart failure')
    outcome <- 'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
  else if(outcome == 'pneumonia')
    outcome <- 'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'
  else
    stop('invalid outcome')
  
  suppressWarnings(measures[, outcome] <- as.numeric(measures[, outcome]))
  measures <- measures[measures$State == state,]
  measures$rank <- rank(measures[, outcome], ties.method = 'min') # create a ranking of outcome values
  result <- sort(measures[measures$rank == 1,]$Hospital.Name)     # sort the top ranking hospitals by name
  result[1]                                                       # return the first one
}