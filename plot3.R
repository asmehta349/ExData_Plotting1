## Purpose: This script creates a line chart of sub-metered power usage data in a household
## on February 01 and 02 2007 for each minute and saves it as a PNG file.

## Assumptions: All necessary R packages are installed and loaded.

# Set the initial working directory to the current directory of the script.
script.dir <- dirname(sys.frame(1)$ofile)
setwd(script.dir)

# Download and unzip the data file if it does not exist.
if(!file.exists("exdata-data-household_power_consumption.zip")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileUrl, destfile = "./exdata-data-household_power_consumption.zip", mode = "wb")
    unzip("./exdata-data-household_power_consumption.zip")
}

# Unzip the data file if it exists but the txt file was deleted for some reason.
if(!file.exists("household_power_consumption.txt")){
    unzip("./exdata-data-household_power_consumption.zip")
}

# Read the electric power consumption data for February 01 and 02 2007 in a data frame.
df<-fread("./household_power_consumption.txt", skip="1/2/2007", nrows=2880, colClass="character",na="?")

# Set the column names of the data fram to the ones in the raw data file.
cols <- fread("./household_power_consumption.txt", nrows=1, header=FALSE, colClass="character")
cols <- as.character(cols[1,])
#colnames(df) <- cols
for (i in 1:length(colnames(df))){
    setnames(df, colnames(df)[i], cols[i])
}

# Create a date & time variable to plot the power usage data against it.
datetime <- paste(df$Date, df$Time)
datetime <- strptime(datetime, "%d/%m/%Y %H:%M:%S")

# Open the PNG graphics device, set the size to 480x480 pixels, and make the background transparent.
png(filename = "./plot3.png", width = 480, height = 480, units = "px", bg = "transparent")

# Create a line chart with legends for sub-metered power usage data.
plot(datetime,as.numeric(df$Sub_metering_1), xlab = "",
     ylab= "Energy sub metering", type = "l", col = "black")
lines(datetime,as.numeric(df$Sub_metering_2), col = "red")
lines(datetime,as.numeric(df$Sub_metering_3), col = "blue")
legend("topright", legend=c(cols[7], cols[8], cols[9]), lty=1,
       col=c("black", "red", "blue"), text.font = 1.5, cex = 0.9)

# Close the PNG graphics device.
dev.off()
