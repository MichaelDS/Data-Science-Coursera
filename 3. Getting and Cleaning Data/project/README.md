Getting & Cleaning Data - Course Project
========================================
All of the data processing for this project is performed in a single script, run_analysis.R, which performs
the following steps:

* Downloads and decompresses the raw data
* Reads in the raw test data and with its variable names
* Reads in the corresponding subject and activity vectors
* Subsets the raw test data to include only the measurements on the mean and standard deviation for each 
signal using regular expressions and the grepl() function
* Merges the subsetted test data with the subject and activity vectors and names the vectors appropriately
* Repeats the previous four steps on the raw training data
* Merges the training and test data
* Replaces the activity codes with activity descriptions using regular expressions and the mgsub() function 
from the qdap package
* Reconstructs the variable names using a more readable format using regular expressions and the splitnames() and mgsub() functions
* Groups and averages the data by subject and activity using the dplyr package, producing the final summarized 
data
