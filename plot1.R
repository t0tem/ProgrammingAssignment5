## this script follows Course Project 2 of 'Exploratory data analysis' from JHU on Coursera
## and creates Plot 1 answering Question 1

#creating data folder in working directory
if (!file.exists("data")) dir.create("data")

# function to download and unzip the data archive to 'data' folder in R working directory
get_file <- function () {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, "data/NEI_data.zip")
    unzip("data/NEI_data.zip", exdir = "data")
}

# getting data archive if it doesn't exist in data folder
if (!file.exists("data/NEI_data.zip"))  get_file() 
