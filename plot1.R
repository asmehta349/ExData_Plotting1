## Purpose: This script creates a histogram of global minute-averaged active power usage
## data in a household on February 01 and 02 2007 and saves it as a PNG file.

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
    
# Open the PNG graphics device.
png(filename = "./plot1.png", width = 480, height = 480)

# Create a histogram of global minute-averaged active power usage.
hist(as.numeric(df$Global_active_power), xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power", col="red")

# Close the PNG graphics device.
dev.off()
