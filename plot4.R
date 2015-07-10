## Exploratory Data Analysis - Course Project 1
## 
## Creates 'Plot 4'.
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

## Create Plot 4 on screen
par(mfrow = c(2, 2), cex.lab = 0.75, cex.axis = 0.75)
with(hpc_data, {
        plot(Global_active_power ~ DateTime, xlab = "", ylab = "Global Active Power",
             type = "l")
        plot(Voltage ~ DateTime, xlab = "datetime", ylab = "Voltage",
             type = "l")
        plot(Sub_metering_1 ~ DateTime, type = "l",
             xlab = "", ylab = "Energy sub metering")
        lines(Sub_metering_2 ~ DateTime,
              xlab = "", col = "red")
        lines(Sub_metering_3 ~ DateTime,
              xlab = "", col = "blue")
        legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n",
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               cex = 0.75)
        plot(Global_reactive_power ~ DateTime, xlab = "datetime",
             ylab = "Global_reactive_power", type = "l")
})

## Rebuild the plot in the png device.
## Do not copy the "screen" plot to the png device, because this seems
## to truncate the legend text on the right for the lower left plot in
## the .png file. Instead, create the .png file directly (this solves the problem).


png(file = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2), cex.lab = 0.75, cex.axis = 0.75)
with(hpc_data, {
        plot(Global_active_power ~ DateTime, xlab = "", ylab = "Global Active Power",
             type = "l")
        plot(Voltage ~ DateTime, xlab = "datetime", ylab = "Voltage",
             type = "l")
        plot(Sub_metering_1 ~ DateTime, type = "l",
             xlab = "", ylab = "Energy sub metering")
        lines(Sub_metering_2 ~ DateTime,
              xlab = "", col = "red")
        lines(Sub_metering_3 ~ DateTime,
              xlab = "", col = "blue")
        legend("topright", lty = 1, col = c("black", "red", "blue"), bty = "n",
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
               cex = 0.95) # Adjusted to resemble required plot closely.
        plot(Global_reactive_power ~ DateTime, xlab = "datetime",
             ylab = "Global_reactive_power", type = "l")
})
dev.off()
