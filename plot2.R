library(sqldf) # For the read.csv.sql
library(dplyr) # for the %>% operation
Sys.setlocale("LC_TIME", "English") # make sure the format of the date in the plot will be at English

# Assumes that by "Your code file should include code for reading the data so that the plot can be fully reproduced." we need to read it into R and dont need to have the code here for download it
# read the input file, only read records where Date='1/2/2007' or '2/2/2007', avoiding reading whole big file into memory.
# Also read all fields as charcters in order to avoid read.csv.sql to convert the ? to 0 for numerc fields.
a<-read.csv.sql('data\\household_power_consumption.txt',sql = "select * from file where Date='1/2/2007' or Date='2/2/2007' ", colClasses = rep("character",9),sep = ';')
closeAllConnections() # close the connections read.csv.sql used for reading the file

# now going to convert the number fields from charters to number, making the '?' NA
b<-subset(a,select = c(Global_active_power:Sub_metering_3)) # get the numeric fields into a new d.f.
c<-as.data.frame(lapply(b,as.numeric)) # convert them to numeric. This will make and '?' charcter to NA

d<-c %>% cbind(a$Date)  %>% cbind(a$Time) # add the date and time colunms

# set the coluonms names for the added fields
t<-names(d)
t[8]<-"Date"
t[9]="Time"
names(d)<-t

# add a datetime colunm to the data frame
d$Date_Time=strptime(paste(d$Date,d$Time),"%d/%m/%Y %H:%M:%S")

#open a png device
png("plot2.png", width=480, height=480)
#plot Global_active_power over time
plot(d$Date_Time,d$Global_active_power, xlab = "",ylab = "Global Active Power (Kliowatts)", type = "l" )
dev.off()
