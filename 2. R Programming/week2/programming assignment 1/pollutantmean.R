pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors listed
  ## in the 'id' vector (ignoring NA values)
  x <- NULL
  
  for(i in id) {
    filename <- paste(sprintf('%.03d', i), '.csv', sep = '')
    path <- paste(directory, '/', filename, sep = '')
    x <- c(x, read.csv(path)[[pollutant]])  #using [[ instead of $ because the index is computed; $ needs a literal name
  }
  
  mean(x, na.rm = TRUE)
}

