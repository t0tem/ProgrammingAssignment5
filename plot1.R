## this script follows Course Project 2 of 'Exploratory data analysis' from JHU on Coursera
## and creates Plot 1 from Question 1

# function to download and unzip the data archive to R working directory
get_file <- function () {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, "NEI_data.zip")
    unzip("NEI_data.zip")
}

# getting data archive if it doesn't exist in R working directory
if (!file.exists("NEI_data.zip"))  get_file() 

file1 <- "summarySCC_PM25.rds"
file2 <- "Source_Classification_Code.rds"

# checking existence of files and reading data
if (file1 %in% dir() & file2 %in% dir()) {
    NEI <- readRDS("summarySCC_PM25.rds")
    SCC <- readRDS("Source_Classification_Code.rds")
} else {
    warning("files were not found in working directory")
}

# grouping data for further plotting
sumbyyear <- with(NEI, tapply(Emissions, year, sum))

# plotting
par(mar = c(3,5,5,4))
plot(names(sumbyyear), sumbyyear/1000, ann=FALSE, type = "o", pch = 20, xaxt="n")
axis(1, at = names(sumbyyear))
title(main = "Total emissions from PM2.5 in the US from 1999 to 2008",
      ylab = "Amount of PM2.5 emitted, in thousands of tons")

# copying to png file
dev.copy(png, file = "plot1.png")
dev.off()





