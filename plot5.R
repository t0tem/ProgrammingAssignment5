## this script follows Course Project 2 of 'Exploratory data analysis' from JHU on Coursera
## and creates Plot 5 from Question 5

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

# looking for sources matching to 'vehicle' in 'EI.Sector'
vehic_ind <- grepl("vehicle", as.character(SCC$EI.Sector), ignore.case = TRUE)

# subsetting global SCC df and getting SCC # for the motor vehicle sources
vehic_sources <- as.character(SCC[vehic_ind, 1])

# subsetting global data for the motor vehicle sources in Baltimore City
vehicles <- subset(NEI, SCC %in% vehic_sources & fips == "24510")

# grouping data for further plotting
vehiclesbyyear <- with(vehicles, tapply(Emissions, year, sum))

# plotting
par(mar = c(3,5,5,4))
plot(names(vehiclesbyyear), vehiclesbyyear, ann=FALSE, type = "o", pch = 20, xaxt="n")
axis(1, at = names(vehiclesbyyear))
title(main = "Total emissions from PM2.5 in Baltimore City 
from motor vehicle sources from 1999 to 2008",
      ylab = "Amount of PM2.5 emitted, in tons")

# copying to png file
dev.copy(png, file = "plot5.png")
dev.off()
