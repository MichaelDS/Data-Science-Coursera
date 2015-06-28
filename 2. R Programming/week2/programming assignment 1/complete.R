complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases
  completeCases <- numeric(length(id))
  
  for(i in 1:length(id)) {
    filename <- paste(sprintf('%03d', id[i]), '.csv', sep = '')
    path <- paste(directory, '/', filename, sep = '')
    completeCases[i] <- sum(complete.cases(read.csv(path)))
  }
  
  data.frame(id = id, nobs = completeCases)
}