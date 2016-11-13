## this script follows Course Project 2 of 'Exploratory data analysis' from JHU on Coursera
## and creates Plot 6 from Question 6

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

# subsetting global data for the motor vehicle sources in Baltimor and LA
vehicles <- subset(NEI, SCC %in% vehic_sources & fips %in% c("24510", "06037"))

# adding new column with county names
vehicles$county <- NA
vehicles[vehicles$fips == "24510", 7] <- "Baltimore City"
vehicles[vehicles$fips == "06037", 7] <- "Los Angeles County"

# aggregating data for further plotting
vehicles_grouped <- aggregate(Emissions ~ county + year, data = vehicles, sum)

# installing (if necessary) and loading needed packages
if(!("ggplot2" %in% rownames(installed.packages()))) {install.packages("ggplot2")}
library(ggplot2)

# creating ggplot object
g <- ggplot(vehicles_grouped, aes(year, Emissions))

# plotting
g + geom_line(lwd = 1) +
    facet_grid(. ~ county) +
    labs(title = "Total emissions from PM2.5 for the motor vehicle sources
    in Baltimore City and Los Angeles County from 1999 to 2008") +
    labs(y = "Amount of PM2.5 emitted, in tons") +
    theme_grey(base_size = 14)


# copying to png file
dev.copy(png, file = "plot6.png", width = 720, height = 480)
dev.off()

