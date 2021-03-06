## Exploratory Data Analysis - Course Project 1
## 
## Creates 'Plot 3'.
##
## Data set information states that the source data contains 2075259 observations.
## Use lubridate library functions to simplify data and time handling
library(lubridate)

## Create data directory if it does not yet exist.
if(!file.exists("data")) {dir.create("data")}

## Download and uncompress data file.
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile = "./data/hpc.zip", mode = 'wb')
unzip(zipfile = "./data/hpc.zip", exdir = "./data")

## Extract column names from first row to set as col names in data frame.
varNames <- colnames(read.table("./data/household_power_consumption.txt", sep = ";", nrow = 1, header = TRUE)) 
columnClasses <- c("char", "char", "num", "num", "num", "num", "int", "int", "int")

## Read the file into data frame 'hpc_data'
hpc_data <- read.table("./data/household_power_consumption.txt", sep=";", as.is = TRUE, col.names = varNames, skip=0, na.strings = "?", header=TRUE)

## Convert time and date fields
## Add new column "DateTime" at the beginning of the data frame.
hpc_data <- cbind(DateTime = 0, hpc_data)

## Use "lubridate" functions to populate new column with combined date/time of class POSIXct. 
hpc_data$DateTime <- dmy(hpc_data$Date) + hms(hpc_data$Time)

## Delete unnecessary (old) 'Date' and 'Time' variables
hpc_data$Date <- NULL
hpc_data$Time <- NULL

## Subset hpc_data to observations between  2007-02-01 and 2007-02-02.

minDate <- ymd("2007-02-01")
maxDate <- ymd("2007-02-03")
hpc_data <- hpc_data[which(hpc_data$DateTime >= minDate & hpc_data$DateTime < maxDate), ]

## Create Plot 3 on screen
par(mfrow = c(1, 1), cex.lab = 0.75, mar = c(3, 4, 3.5, 5.0))
with(hpc_data, {
        plot(Sub_metering_1 ~ DateTime, type = "l",
             xlab = "", ylab = "Energy sub metering")
        lines(Sub_metering_2 ~ DateTime,
              xlab = "", ylab = "Energy sub metering", col = "red")
        lines(Sub_metering_3 ~ DateTime,
              xlab = "", ylab = "Energy sub metering", col = "blue")
        legend("topright", lty = 1, col = c("black", "red", "blue"),
               cex = 0.7, title.adj = 1, xjust = 1,
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})

## Do not copy the "screen" plot to the png device, because this seems
## to truncate the legend text on the right in the .png file. Instead,
## create the .png file directly (this solves the problem).

png(file = "plot3.png", width = 480, height = 480)
with(hpc_data, {
        plot(Sub_metering_1 ~ DateTime, type = "l",
             xlab = "", ylab = "Energy sub metering")
        lines(Sub_metering_2 ~ DateTime,
              xlab = "", ylab = "Energy sub metering", col = "red")
        lines(Sub_metering_3 ~ DateTime,
              xlab = "", ylab = "Energy sub metering", col = "blue")
        legend("topright", lty = 1, col = c("black", "red", "blue"),
               cex = 1.0, title.adj = 1, xjust = 1,
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
})
dev.off()
