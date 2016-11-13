## this script follows Course Project 2 of 'Exploratory data analysis' from JHU on Coursera
## and creates Plot 3 from Question 3

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

# subsetting for Baltimore City, Maryland (fips == "24510")
baltimor <- subset(NEI, fips == "24510")

# installing (if necessary) and loading needed packages
if(!("ggplot2" %in% rownames(installed.packages()))) {install.packages("ggplot2")}
library(ggplot2)

# aggregating data for further plotting
baltimor_grouped <- aggregate(Emissions ~ type + year, data = baltimor, sum)

# creating ggplot object
g <- ggplot(baltimor_grouped, aes(year, Emissions))

# plotting
print(g + geom_line(lwd = 1) +
          facet_grid(. ~ type) +
          labs(title = "Total emissions from PM2.5 in the Baltimore City, Maryland 
from 1999 to 2008 by type of source") +
          labs(y = "Amount of PM2.5 emitted, in tons") +
          theme_grey(base_size = 14))


# copying to png file
dev.copy(png, file = "plot3.png", width = 960, height = 480)
dev.off()

