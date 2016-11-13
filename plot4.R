## this script follows Course Project 2 of 'Exploratory data analysis' from JHU on Coursera
## and creates Plot 4 from Question 4

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

# looking for sources matching to 'coal' in 'SCC.Level.Three'
coal_ind <- grepl("coal", as.character(SCC$SCC.Level.Three), ignore.case = TRUE)

# looking for sources matching to 'comb' (for combustion) in 'EI.Sector'
comb_ind <- grepl("comb", as.character(SCC$EI.Sector), ignore.case = TRUE)

# merging vectors to get indices of coal combustion-related sources
coal_comb_ind <- coal_ind & comb_ind

# subsetting global SCC df and getting SCC # for the coal combustion-related sources
coal_comb_sources <- as.character(SCC[coal_comb_ind, 1])

# subsetting global data for the coal combustion-related sources
coalcomb <- subset(NEI, SCC %in% coal_comb_sources)

# grouping data for further plotting
coalcombbyyear <- with(coalcomb, tapply(Emissions, year, sum))

# plotting
par(mar = c(3,5,5,4))
plot(names(coalcombbyyear), coalcombbyyear, ann=FALSE, type = "o", pch = 20, xaxt="n")
axis(1, at = names(coalcombbyyear))
title(main = "Total emissions from PM2.5 in the US 
            from coal combustion-related sources
            from 1999 to 2008",
      ylab = "Amount of PM2.5 emitted, in tons")

# copying to png file
dev.copy(png, file = "plot4.png")
dev.off()
