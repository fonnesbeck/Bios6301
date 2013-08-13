Working with Dates and Times
============================

---

Date and Time Information
=========================

Working with dates and times is difficult because it lacks consistency:

* multiple lengths of months
* daylight savings time
* time zones
* leap years

---

Avoiding Date and Time Structure
================================

One way to avoid dealing with dates and times is to convert them to another format. For example, we could convert absolute time to an integer value relative to an arbitrary starting point.

For example, survival data can be converted to the number of days (or hours) relative to the start of the study.

This can also serve to de-identify the data.

---

`Date` Class
============

The default data structure for dates in R is the `Date` class. Internally, `Date` stores time as an integer value, which represents the number of days since January 1, 1970 (note that this allows for negative values).

    !r
    > as.Date("2012-09-30")
    [1] "2012-09-30"
    > class(Sys.Date())
    [1] "Date"
    > unclass(Sys.Date())
    [1] 15612
    > as.Date("09/30/2012", format="%m/%d/%Y") # Custom formatting
    [1] "2012-09-30"
    > as.Date(41180, origin="1900-01-01") # Choose a different origin
    [1] "2012-09-30"

`Date` objects can be subtracted from one another, or have their default units changed:

    !r
    > Sys.Date() - as.Date("2003-05-17")
    Time difference of 3425 days
    > difftime(Sys.Date(), as.Date("2003-05-17"), units="secs")
    Time difference of 295920000 secs
    
---

Date-Time Data
==============

For date-time information, there is a choice of several packages. Two standard build-in classes are the `POSIXct` and `POSIXlt` classes, which stand for calendar time and local time representations, respectively.

* `POSIXct` stores time as the number of *seconds* since the origin
* `POSIXlt` stores a list of time attributes, which can be indexed

---


    !r
    > unclass(Sys.time())
    [1] 1348938508
    > unclass(as.POSIXlt(Sys.time()))
    $sec
    [1] 46.65234
    $min
    [1] 8
    $hour
    [1] 13
    $mday
    [1] 29
    $mon
    [1] 8
    $year
    [1] 112
    $wday
    [1] 6
    $yday
    [1] 272
    $isdst
    [1] 1
    attr(,"tzone")
    [1] ""    "EST" "EDT"

---

Date-Time Formatting
====================

We can obtain date-time data in a wide variety of formats. The POSIXt classes allow for broad customization of the input format.

    !r
    > as.POSIXct("080406 10:11", format = "%y%m%d %H:%M")
    [1] "2008-04-06 10:11:00 CDT"
    > as.POSIXct("2008-04-06 10:11:01 PM", format = "%Y-%m-%d %I:%M:%S %p")
    [1] "2008-04-06 22:11:01 CDT"
    > as.POSIXct("08/04/06 22:11:00", format = "%m/%d/%y %H:%M:%S")
    [1] "2006-08-04 22:11:00 CDT"
    
It is also possible to convert POSIXt variables to character strings of an arbitrary format:

    !r
    > format(as.POSIXct("080406 10:11", format = "%y%m%d %H:%M"), 
        "%m/%d/%Y %I:%M %p")
    [1] "04/06/2008 10:11 AM"
    > as.character(as.POSIXct("080406 10:11", format = "%y%m%d %H:%M"), 
        format = "%m-%d-%y %H:%M")
    [1] "04-06-08 10:11"

Presenter Notes
===============

Note that 12-hour clock hours is denoted by %I

---

Example
=======

The following function calculates the time at which you turn a given number of seconds old, defaulting to a billion (courtesy *Cole Beck*):

    !r
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
    
    > bday_in_secs("1970-09-03 04:00:00")
    [1] "You turned 1e+09 seconds old on 2002-05-12, which was 3793 days ago."
    [1] "2002-05-12"

---

POSIXt Gotchas
==============

Sometimes R will change date-time classes on you without warning!

    !r
    dts <- data.frame(day = c("20081101", "20081101", "20081101", "20081101", "20081101", 
            "20081102", "20081102", "20081102", "20081102", "20081103"), 
        time = c("01:20:00", "06:00:00", "12:20:00", "17:30:00", "21:45:00", "01:15:00", 
            "06:30:00", "12:50:00", "20:00:00", "01:05:00"), 
        value = c("5", "5", "6", "6", "5", "5", "6", "7", "5", "5"))
    dts1 <- paste(dts$day, dts$time)
    dts2 <- as.POSIXct(dts1, format = "%Y%m%d %H:%M:%S")
    dts3 <- as.POSIXlt(dts1, format = "%Y%m%d %H:%M:%S")
    dts_all <- data.frame(dts, ct = dts2, lt = dts3)
    
    > str(dts_all)
    'data.frame': 10 obs. of 5 variables:
    $ day : Factor w/ 3 levels "20081101","20081102",..: 1 1 1 1 1 2 2 2 2 3
    $ time : Factor w/ 10 levels "01:05:00","01:15:00",..: 3 4 6 8 10 2 5 7 9 1
    $ value:Factorw/3levels"5","6","7":1122112311
    $ ct : POSIXct, format: "2008-11-01 01:20:00" "2008-11-01 06:00:00" ...
    $ lt : POSIXct, format: "2008-11-01 01:20:00" "2008-11-01 06:00:00" ... 
    
---

POSIXt Gotchas
==============

However, if we build the same data frame using a different approach, it behaves as expected!

    !r
    dts_all <- dts
    dts_all$ct <- dts2
    dts_all$lt <- dts3
    
    > str(dts_all)
    'data.frame': 10 obs. of 5 variables:
    $ day : Factor w/ 3 levels "20081101","20081102",..: 1 1 1 1 1 2 2 2 2 3
    $ time : Factor w/ 10 levels "01:05:00","01:15:00",..: 3 4 6 8 10 2 5 7 9 1
    $ value:Factorw/3levels"5","6","7":1122112311
    $ ct : POSIXct, format: "2008-11-01 01:20:00" "2008-11-01 06:00:00" ...
    $ lt : POSIXlt, format: "2008-11-01 01:20:00" "2008-11-01 06:00:00" ...
    
---

POSIXt Gotchas
==============

Rounding date-times can also result in casting to a different type:

    !r
    > dts_all[, "ct"] <- round(dts_all[, "ct"], units = "hours")
    Warning:  provided 9 variables to replace 1 variables
    > class(dts_all[, "ct"])
    [1] "POSIXct" "POSIXt" 
    
We can force it back to POSIXct:

    !r
    > dts_all[, "ct"] <- as.POSIXct(round(dts2, units = "hours"))
    
However, rounding a POSIXlt column also fails!

    !r
    > dts_all[, "lt"] <- round(dts3, units = "hours") 
    Warning message:
    In `[<-.data.frame`(`*tmp*`, , "lt", value = list(sec = c(0, 0,  :
      provided 9 variables to replace 1 variables
    > dts_all[, "lt"]
     [1] 0 0 0 0 0 0 0 0 0 0
    
But magically, assigning with a `$` works as expected:

    > dts_all$lt <- round(dts3, units = "hours")
    
---

Time Zones and DST
==================

    !r
    > (time1 <- dts_all$lt[5])
    [1] "2008-11-01 22:00:00 CDT"
    > (time2 <- dts_all$lt[7])
    [1] "2008-11-02 07:00:00 CST"
    > while (time1 < time2) {
    +     # Increment 1 hour until they are equal
    +     time1$hour <- time1$hour + 1
    + print(unlist(time1)) }
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    23     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    24     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    25     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    26     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    27     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    28     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    29     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    30     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    31     1    10   108     6   305     1 
      sec   min  hour  mday   mon  year  wday  yday isdst 
        0     0    32     1    10   108     6   305     1 
      
---

Time Zones and DST
==================

Notice, however, that the printed times are different, due to the fact that `time1` is on daylight savings time, while `time2` is on standard time. Yet, they are equal!
  
    !r
    > print(sprintf("%s -- %s", time1, time2))
    [1] "2008-11-02 08:00:00 -- 2008-11-02 07:00:00"
    > time1 == time2
    [1] TRUE
    > time1
    [1] "2008-11-02 08:00:00 CDT"
    > time2
    [1] "2008-11-02 07:00:00 CST"
    
Converting the date classes clears up the problem, as does concatenating the dates:

    !r
    > as.POSIXlt(as.POSIXct(time1))
    [1] "2008-11-02 07:00:00 CST"
    > c(time1, time2)
    [1] "2008-11-02 07:00:00 CST" "2008-11-02 07:00:00 CST"
    
---

Specifying Time Zones
=====================

It is good practice to always declare your time zone:

    !r
    round(as.POSIXlt(dts1, format = "%Y%m%d %H:%M:%S", tz = "CST"), units = "hours")
     [1] "2008-11-01 01:00:00 CST" "2008-11-01 06:00:00 CST" "2008-11-01 12:00:00 CST"
     [4] "2008-11-01 18:00:00 CST" "2008-11-01 22:00:00 CST" "2008-11-02 01:00:00 CST"
     [7] "2008-11-02 07:00:00 CST" "2008-11-02 13:00:00 CST" "2008-11-02 20:00:00 CST"
    [10] "2008-11-03 01:00:00 CST"
    
If we want to ignore daylight savings and time zones, we can store date-time information in universal time (UTC):

    !r
    (dts4 <- round(as.POSIXlt(dts1, format = "%Y%m%d %H:%M:%S", tz = "UTC"), units = "hours"))
     [1] "2008-11-01 01:00:00 UTC" "2008-11-01 06:00:00 UTC" "2008-11-01 12:00:00 UTC"
     [4] "2008-11-01 18:00:00 UTC" "2008-11-01 22:00:00 UTC" "2008-11-02 01:00:00 UTC"
     [7] "2008-11-02 07:00:00 UTC" "2008-11-02 13:00:00 UTC" "2008-11-02 20:00:00 UTC"
    [10] "2008-11-03 01:00:00 UTC"
    
---

Example
=======

For a concrete example of manipulating dates and times, consider the task of filling (interpolating) missing dates and associated values in a sequence.

Consider a simple data frame with values measured every 6 hours:

    !r
    > mydata_lt <- data.frame(date = NA, value = dts_all$value)
    > mydata_lt$date <- dts_all$lt
    > mydata_lt
                      date value
    1  2008-11-01 01:00:00     5
    2  2008-11-01 06:00:00     5
    3  2008-11-01 12:00:00     6
    4  2008-11-01 18:00:00     6
    5  2008-11-01 22:00:00     5
    6  2008-11-02 01:00:00     5
    7  2008-11-02 07:00:00     6
    8  2008-11-02 13:00:00     7
    9  2008-11-02 20:00:00     5
    10 2008-11-03 01:00:00     5
    
Let's say we actually want an entry every hour, with the value filled with the last observed value. *How would we do this?*

---

Example
=======

First, create the vector of hourly date-times:

    !r
    > dates <- seq(mydata_lt[1, "date"], mydata_lt[nrow(x), "date"], by = "hours")
    
Now, we need a data frame of the appropriate size, with empty values:

    !r
    > mydata_filled <- data.frame(date = dates, value = NA)
    
Next, match the dates in the new table with those of the original table, and copy the associated values:

    !r
    > (mydata_filled$value[match(as.character(mydata_lt$date), as.character(mydata_filled$date))] 
        <- mydata_lt$value)
                      date value
    1  2008-11-01 01:00:00     1
    2  2008-11-01 02:00:00    NA
    3  2008-11-01 03:00:00    NA
    4  2008-11-01 04:00:00    NA
    5  2008-11-01 05:00:00    NA
    6  2008-11-01 06:00:00     1
    7  2008-11-01 07:00:00    NA
    8  2008-11-01 08:00:00    NA
    
---

Example
=======

Finally, we loop over the NA values in order, filling the value from the previous row:

    !r
    > for (i in which(is.na(mydata_filled$value))) {
    +         mydata_filled[i, "value"] <- mydata_filled[i - 1, "value"]
    +     }
    > mydata_filled
                      date value
    1  2008-11-01 01:00:00     1
    2  2008-11-01 02:00:00     1
    3  2008-11-01 03:00:00     1
    4  2008-11-01 04:00:00     1
    5  2008-11-01 05:00:00     1
    6  2008-11-01 06:00:00     1
    7  2008-11-01 07:00:00     1
    8  2008-11-01 08:00:00     1
    9  2008-11-01 09:00:00     1
    10 2008-11-01 10:00:00     1
    11 2008-11-01 11:00:00     1
    12 2008-11-01 12:00:00     2
    13 2008-11-01 13:00:00     2
  
---

Example
=======

You will notice that the values 5,6,7 have been replaced by 1,2,3. This is because in the original table, `value` was a factor:

    !r
    > str(mydata_lt)
    'data.frame':	10 obs. of  2 variables:
     $ date : POSIXlt, format: "2008-11-01 01:00:00" "2008-11-01 06:00:00" ...
     $ value: Factor w/ 3 levels "5","6","7": 1 1 2 2 1 1 2 3 1 1

Recall that the levels of a factor are just labels, and that the underlying data are a series of integers, with a unique value for each label.

If we want to restore the original labels, we must first cast the `value` column to a factor:

    !r
    > mydata_filled$value <- as.factor(mydata_filled$value)
    > levels(mydata_filled$value) <- c(5,6,7)
    > head(mydata_filled)
                     date value
    1 2008-11-01 01:00:00     5
    2 2008-11-01 02:00:00     5
    3 2008-11-01 03:00:00     5
    4 2008-11-01 04:00:00     5
    5 2008-11-01 05:00:00     5
    6 2008-11-01 06:00:00     5
    
---

Lubridate
=========

A more modern approach to handling dates and times is provided by the third-party package `lubridate`. It attempts to solve some of the inconsistencies and lack of robustness inherent in the built-in classes and associated functions.

`lubridate` has a robust set of parsing functions that automatically handles a wide variety of string representations. For most formats, the parsing function name is the same as that of the order of the date elements:

    !r
    > ymd("20110604"); mdy("06-04-2011"); dmy("04/06/2011")
    [1] "2011-06-04 UTC"
    [1] "2011-06-04 UTC"
    [1] "2011-06-04 UTC"
    
Data with time information as well as dates can similarly be accomodated:

    !r
    > ymd_hms("2012-09-29 12:00:00", tz="America/Chicago")
    [1] "2012-09-29 12:00:00 CDT"
    
---

Manipulating Dates and Times
============================

`lubridate` allows for the specification of particular durations or intervals that can then be added or subtracted from dates or times.

    !r
    > (ldate <- mdy_hms("12/31/2012 23:59:59"))
    [1] "2012-12-31 23:59:59 UTC"
    > ldate + seconds(1)
    [1] "2013-01-01 UTC"
    > month(ldate) <- 8
    > ldate
    [1] "2012-08-31 23:59:59 UTC"
    
It is easy to extract information from `lubridate`'s classes using the appropriate helper function:

    !r
    > second(ldate)
    [1] 59
    > tz(ldate)
    [1] "UTC"
    > yday(ldate)
    [1] 244
    > wday(ldate)
    [1] 6
    > wday(ldate, label=TRUE)
    [1] Fri
    
    
---

Periods vs Durations
====================
    
There are two time span classes, periods and durations:

    !r
    > minutes(5)
    [1] 5 minutes
    > dminutes(5)
    [1] 300s (~5 minutes)
    
There are two classes because durations are always expected to be precise (measured exactly, to the second), while periods change according to a timeline:

    !r
    > leap_year(2011)
    [1] FALSE
    > ymd(20110101) + dyears(1)
    [1] "2012-01-01 UTC"
    > ymd(20110101) + years(1)
    [1] "2012-01-01 UTC"
    
    > leap_year(2012)
    [1] TRUE
    > ymd(20120101) + dyears(1)
    [1] "2012-12-31 UTC"
    > ymd(20120101) + years(1)
    [1] "2013-01-01 UTC"

---

Cool Date/Time Tricks
=====================

`lubridate` makes it easy to generate dates at regular intervals:

    !r
    > (meetings <- now() + weeks(0:5))
    [1] "2012-09-29 17:31:29 CDT" "2012-10-06 17:31:29 CDT"
    [3] "2012-10-13 17:31:29 CDT" "2012-10-20 17:31:29 CDT"
    [5] "2012-10-27 17:31:29 CDT" "2012-11-03 17:31:29 CDT"
    
The custom operator `%within%` tests whether two intervals overlap:    
    
    !r
    > holiday <- interval(ymd("2012/10/11"), ymd("2012/10/17"))
    > meetings %within% holiday
    [1] FALSE FALSE  TRUE FALSE FALSE FALSE

