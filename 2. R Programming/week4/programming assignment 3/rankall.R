unzip('rprog_data_ProgAssignment3-data.zip')

rankhospital2 <- function(state, outcome, num = 'best', measures) {
  
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
  
  if(is.character(num) & !(num %in% c('best', 'worst')))
    stop('invalid num argument')
  
  suppressWarnings(measures[, outcome] <- as.numeric(measures[, outcome]))
  measures <- measures[measures$State == state,]
  
  if(!is.character(num) & num > nrow(measures))
    return(NA)
  
  if(num == 'best') {
    measures <- measures[order(measures[, outcome], measures$Hospital.Name),]  # order by outcome, break ties with hospital name
    return(measures$Hospital.Name[1])
  }
  else if(num == 'worst') {
    measures <- measures[order(measures[, outcome], measures$Hospital.Name, na.last = FALSE),] # order with NAs first to make finding the worst rank easy
    return(measures$Hospital.Name[nrow(measures)])
  }
  else
    measures <- measures[order(measures[, outcome], measures$Hospital.Name),]
    return(measures$Hospital.Name[num])
}

rankall <- function(outcome, num = 'best') {

  measures <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
  
  state <- sort(unique(measures$State))
  hospital <- sapply(state, rankhospital2, outcome = outcome, num = num, measures = measures)
  data.frame(hospital, state)
}