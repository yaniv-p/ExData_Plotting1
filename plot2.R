#setClass('myDate')
#setAs("character","myDate", function(from) as.Date(from, format="%d/%m/%Y")) 
#setClass('myTime')
#setAs("character","myTime", function(from) strptime(from, format="%H:%M:%S"))

library(sqldf)
library(dplyr)
Sys.setlocale("LC_TIME", "English")
a<-read.csv.sql('data\\household_power_consumption.txt',sql = "select * from file where Date='1/2/2007' or Date='2/2/2007' ", colClasses = rep("character",9),sep = ';')

closeAllConnections()

b<-subset(a,select = c(Global_active_power:Sub_metering_3))

c<-as.data.frame(lapply(b,as.numeric))

d<-c %>% cbind(a$Date)  %>% cbind(a$Time)
t<-names(d)
t[8]<-"Date"
t[9]="Time"
names(d)<-t

d$Date_Time=strptime(paste(d$Date,d$Time),"%d/%m/%Y %H:%M:%S")

png("plot2.png", width=480, height=480)
plot(d$Date_Time,d$Global_active_power, xlab = "",ylab = "Global Active Power (Kliowatts)", type = "l" )
dev.off()
