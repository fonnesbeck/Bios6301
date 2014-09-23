
## ------------------------------------------------------------------------
as.Date("2012-09-30")
class(Sys.Date())
unclass(Sys.Date())
as.Date("09/30/2012", format="%m/%d/%Y") # Custom formatting
as.Date(41180, origin="1900-01-01") # Choose a different origin


## ------------------------------------------------------------------------
Sys.Date() - as.Date("2003-05-17")
difftime(Sys.Date(), as.Date("2003-05-17"), units="secs")


## ------------------------------------------------------------------------
unclass(Sys.time())
unclass(as.POSIXlt(Sys.time()))


## ------------------------------------------------------------------------
as.POSIXct("080406 10:11", format = "%y%m%d %H:%M")
as.POSIXct("2008-04-06 10:11:01 PM", format = "%Y-%m-%d %I:%M:%S %p")
as.POSIXct("08/04/06 22:11:00", format = "%m/%d/%y %H:%M:%S")


## ------------------------------------------------------------------------
format(as.POSIXct("080406 10:11", format = "%y%m%d %H:%M"), "%m/%d/%Y %I:%M %p")
as.character(as.POSIXct("080406 10:11", format = "%y%m%d %H:%M"), format = "%m-%d-%y %H:%M")


## ------------------------------------------------------------------------
bday_in_secs <- function(bday, age = 10^9, format = "%Y-%m-%d %H:%M:%S") {
    x <- as.POSIXct(bday, format = format) + age
    togo <- round(difftime(x, Sys.time(), units = "days"))
    if (togo > 0) {
        msg <- sprintf("You will be %s seconds old on %s, which is %s days from now.",
                       age, format(x, "%Y-%m-%d"), togo)
    } else {
        msg <- sprintf("You turned %s seconds old on %s, which was %s days ago.",
                       age, format(x, "%Y-%m-%d"), -1 * togo)
    }
    if (age > 125 * 365.25 * 86400)
        msg <- paste(msg, "Good luck with that.")
    print(msg)
    format(x, "%Y-%m-%d")
}

bday_in_secs("1985-09-25 14:00:00")


## ------------------------------------------------------------------------
dts <- data.frame(day = c("20081101", "20081101", "20081101", "20081101", "20081101",
        "20081102", "20081102", "20081102", "20081102", "20081103"),
    time = c("01:20:00", "06:00:00", "12:20:00", "17:30:00", "21:45:00", "01:15:00",
        "06:30:00", "12:50:00", "20:00:00", "01:05:00"),
    value = c(5, 5, 6, 6, 5, 5, 6, 7, 5, 5))
dts1 <- paste(dts$day, dts$time)
dts2 <- as.POSIXct(dts1, format = "%Y%m%d %H:%M:%S")
dts3 <- as.POSIXlt(dts1, format = "%Y%m%d %H:%M:%S")
dts_all <- data.frame(dts, ct = dts2, lt = dts3)
str(dts_all)


## ------------------------------------------------------------------------
dts_all <- dts
dts_all$ct <- dts2
dts_all$lt <- dts3
str(dts_all)


## ------------------------------------------------------------------------
dts_all[, "ct"] <- round(dts_all[, "ct"], units = "hours")
class(dts_all[, "ct"])


## ------------------------------------------------------------------------
dts_all[, "ct"] <- as.POSIXct(round(dts2, units = "hours"))


## ------------------------------------------------------------------------
dts_all[, "lt"] <- round(dts3, units = "hours")
dts_all[, "lt"]


## ------------------------------------------------------------------------
dts_all$lt <- round(dts3, units = "hours")


## ------------------------------------------------------------------------
(time1 <- dts_all$lt[5])
(time2 <- dts_all$lt[7])
while (time1 < time2) {
  # Increment 1 hour until they are equal
  time1$hour <- time1$hour + 1
  print(unlist(time1))
}


## ------------------------------------------------------------------------
print(sprintf("%s -- %s", time1, time2))
time1 == time2
time1
time2


## ------------------------------------------------------------------------
as.POSIXlt(as.POSIXct(time1))
c(time1, time2)


## ------------------------------------------------------------------------
round(as.POSIXlt(dts1, format = "%Y%m%d %H:%M:%S", tz = "CST"), units = "hours")


## ------------------------------------------------------------------------
(dts4 <- round(as.POSIXlt(dts1, format = "%Y%m%d %H:%M:%S", tz = "UTC"), units = "hours"))


## ------------------------------------------------------------------------
mydata_lt <- data.frame(date = NA, value = dts_all$value)
mydata_lt$date <- dts_all$lt
mydata_lt


## ------------------------------------------------------------------------
dates <- seq(mydata_lt[1, "date"], mydata_lt[nrow(mydata_lt), "date"], by = "hours")


## ------------------------------------------------------------------------
mydata_filled <- data.frame(date = dates, value = NA)


## ------------------------------------------------------------------------
(mydata_filled$value[match(as.character(mydata_lt$date), as.character(mydata_filled$date))] <- mydata_lt$value)


## ------------------------------------------------------------------------
for (i in which(is.na(mydata_filled$value))) {
    mydata_filled[i, "value"] <- mydata_filled[i - 1, "value"]
}
mydata_filled


## ------------------------------------------------------------------------
hasPackage <- tryCatch(find.package('lubridate'), error=function(e) e)
if(inherits(hasPackage, "error")) install.packages('lubridate')
library(lubridate)


## ------------------------------------------------------------------------
ymd("20110604")
mdy("06-04-2011")
dmy("04/06/2011")


## ------------------------------------------------------------------------
ymd_hms("2012-09-29 12:00:00", tz="America/Chicago")


## ------------------------------------------------------------------------
(ldate <- mdy_hms("12/31/2012 23:59:59"))
ldate + dseconds(1)
month(ldate) <- 8
ldate


## ------------------------------------------------------------------------
second(ldate)
tz(ldate)
yday(ldate)
wday(ldate)
wday(ldate, label=TRUE)


## ------------------------------------------------------------------------
minutes(5)
dminutes(5)


## ------------------------------------------------------------------------
leap_year(2011)
ymd(20110101) + dyears(1)
ymd(20110101) + years(1)

leap_year(2012)
ymd(20120101) + dyears(1)
ymd(20120101) + years(1)


## ------------------------------------------------------------------------
(meetings <- now() + weeks(0:5))


## ------------------------------------------------------------------------
holiday <- interval(ymd("2012/10/11"), ymd("2012/10/17"))
meetings %within% holiday

