Data Processing in R
====================

Presenter Notes
===============

This will be a *hands-on* lecture!

---

Data Frames
===========

Data frames are the default data structure in R for manipulating large, multi-column, heterogeneous datasets.

Recall that in data frames, data are organized into rows and columns, with rows
representing individual observational units and columns representing the variables
for each.

There are several functions that are important for being able to use data frames effectively for processing your data.

---

Sample Dataset: HAART
=====================

Our sample database is some de-identified data for Highly Active Antiretroviral Therapy (HAART) patients. The data file, `haart.csv` is located in the `datasets` folder on the GitHub repository.

Here is what are first 4 lines (header + 3 data rows) of the table:

    !r
    "male","age","aids","cd4baseline","logvl","weight","hemoglobin","init.reg",
        "init.date","last.visit","death","date.death","event","followup","lfup","pid"
    1,25,0,NA,NA,NA,NA,"3TC,AZT,EFV","2003-07-01","2007-02-26",0,NA,0,365,0,1
    1,49,0,143,NA,58.0608,11,"3TC,AZT,EFV","2004-11-23","2008-02-22",0,NA,0,365,
        0,2
    1,42,1,102,NA,48.0816,1,"3TC,AZT,EFV","2003-04-30","2005-11-21",1,"2006-01-11",
        0,365,0,3

Since this data is in csv format, it can be easily imported to R with `read.csv`:

    !r
    > haart <- read.csv("haart.csv")


---

HAART data frame
================

You can examine the first few lines of a large data frame using the `head` function:

    !r
    > head(haart)
      male age aids cd4baseline logvl  weight hemoglobin    init.reg  init.date
    1    1  25    0          NA    NA      NA         NA 3TC,AZT,EFV 2003-07-01
    2    1  49    0         143    NA 58.0608         11 3TC,AZT,EFV 2004-11-23
    3    1  42    1         102    NA 48.0816          1 3TC,AZT,EFV 2003-04-30
    4    0  33    0         107    NA 46.0000         NA 3TC,AZT,NVP 2006-03-25
    5    1  27    0          52     4      NA         NA 3TC,D4T,EFV 2004-09-01
    6    0  34    0         157    NA 54.8856         NA 3TC,AZT,NVP 2003-12-02
      last.visit death date.death event followup lfup pid
    1 2007-02-26     0       <NA>     0      365    0   1
    2 2008-02-22     0       <NA>     0      365    0   2
    3 2005-11-21     1 2006-01-11     0      365    0   3
    4 2006-05-05     1 2006-05-07     1       43    0   4
    5 2007-11-13     0       <NA>     0      365    0   5
    6 2008-02-28     0       <NA>     0      365    0   6

Similarly, `tail` gives the last several lines of the data frame.

---

Data Frame Structure
====================

The function `str` reveals the structure of the data frame, including the number of variables (columns) and observations (rows), as well as the data types of each column:

    !r
    > str(haart)
    'data.frame':	1000 obs. of  12 variables:
     $ male       : int  1 1 1 0 1 0 0 1 1 1 ...
     $ age        : num  25 49 42 33 27 34 39 31 52 23 ...
     $ aids       : int  0 0 1 0 0 0 0 0 0 1 ...
     $ cd4baseline: int  NA 143 102 107 52 157 65 NA NA 3 ...
     $ logvl      : num  NA NA NA NA 4 ...
     $ weight     : num  NA 58.1 48.1 46 NA ...
     $ hemoglobin : num  NA 11 1 NA NA NA 11 NA NA NA ...
     $ init.reg    : Factor w/ 47 levels "3TC,ABC,AZT",..: 10 10 10 17 19 17 17 10 1 27 ...
     $ init.date   : Factor w/ 681 levels "1/1/02","1/1/03",..: 508 150 384 319 635 188 278 675 581 484 ...
     $ last.visit  : Factor w/ 509 levels "","1/10/05","1/10/08",..: 195 189 103 352 90 201 220 167 86 468 ...
     $ death      : int  0 0 1 1 0 0 0 0 0 1 ...
     $ date.death  : Factor w/ 113 levels "","1/11/06","1/22/04",..: 1 1 2 70 1 1 1 1 1 107 ...

Several columns were imported as a `Factor` type by default.

---

Attaching Data Frames
=====================

If you do not wish to prefix each variable by the name of the data frame, it is
possible to `attach` the data frame to the current environment.

    !r
    > attach(haart)
    > weight[1:20]
     [1]      NA 58.0608 48.0816 46.0000      NA 54.8856 55.3392      NA      NA
    [10]      NA 57.0000 48.0000 55.3392 53.0000      NA      NA      NA 64.0000
    [19] 61.2360 73.0000

This function should be used carefully: it is easy to cause namespace conflicts,
that is, variables that already exist in one environment are silently overwritten
by other variables that are attached.

If you do choose to use `attach`, it is good practice to detach the workspace at
the end of any script that attaches it:

    !r
    > detach(haart)
    > weight
    Error: object 'weight' not found

Presenter Notes
===============

Note that the changing the variables that are attached to a particular
environment does not change them in the original data frame

---

Factors
=======

The `factor` type represents variables that are categorical, or nominal. That is, they are not ordinal or rational. We can think of factors as variables whose value is one of a set of labels, with no intrinsic label relative to the other labels. Examples include:

* party membership: Republican, Democrat, Independent
* zip code
* gender
* nationality

For example, let's look at the `init.reg` variable in the HAART dataset, which shows the initial drug regimen for each patient:

    !r
    > str(haart$init.reg)
     Factor w/ 47 levels "3TC,ABC,AZT",..: 10 10 10 17 19 17 17 10 1 27 ...

This shows each drug combination has a label and a unique number for each combination. These numbers, however, have no intrinsic order.

---

Factors
=======

Levels may be defined that may not actually be present in the data. For example, let's generate some random data between 0 and 4, and turn it into a factor:

    !r
    > (x <- factor(rbinom(20, 4, 0.5)))
     [1] 3 1 2 2 1 1 2 4 1 4 2 2 3 0 2 2 2 0 1 3
    Levels: 0 1 2 3 4
    
We can redefine the levels to contain the value 5, even though it is not present:

    !r
    > levels(x) <- 0:5
    > table(x)
    x
    0 1 2 3 4 5 
    2 5 8 3 2 0 
    
However, we cannot assign values to a factor variable that is not already among the levels:

    !r
    > x[4] <- 17
    Warning message:
    In `[<-.factor`(`*tmp*`, 4, value = 17) :
      invalid factor level, NAs generated
    
---

Generating Factor Variables
===========================

As an example, lets convert the `male` variable into a factor. By default, since it is an indicator variable that equals 1 for male patients and 0 for females, `read.table` assumes it is an integer-valued variable and imports it as such. But, there is no intrinsic ordering to gender, so it is more useful treating it as a factor.

    !r  
    > (haart$gender <- factor(haart$male))
     [1] 1 1 1 0 1 0 0 1 1 1 1 1 0 0 0 0 1 1 0 1 0 1 0 0 0 0 1 0 1 0 0 0 1 1 1 1 0
     ...
     [963] 1 1 1 1 1 0 1 0 1 1 1 1 1 1 0 1 0 0 1 1 1 1 1 0 0 1 1 1 1 1 1 0 1 1 0 0 0
     [1000] 0
    Levels: 0 1

We may also want to add readable labels to the levels, for use in output and plotting:

    !r
    > levels(haart$gender) <- c("female","male")
    
These steps can be combined into a single call:

    !r
    > haart$gender <- factor(haart$male, labels=c("female","male"))


---

Indexing
========

If you recall from the data structures lecture, we can *index* values from a data frame in a variety of ways. For example, if we want the ages of the first 50 observations:

    !r
    > haart$age[1:50]
     [1] 25.00000 49.00000 42.00000 33.00000 27.00000 34.00000 39.00000 31.00000
     [9] 52.00000 23.00000 49.40726 43.00000 42.00000 30.82272 37.00000 43.00000
    [17] 35.00000 33.85079 38.00000 41.00000 35.00000 39.60575 32.00000 57.00000
    [25] 29.00000 41.00000 27.00000 54.00000 42.00000 49.79877 38.00000 22.00000
    [33] 32.00000 36.00000 52.00000 31.01164 32.00000 37.00000 23.88501 32.00000
    [41] 28.00000 19.00000 29.00000 32.00000 47.52361 61.44559 50.00000 42.00000
    [49] 48.00000 24.00000
    # or equivalently ...
    > haart[[2]][1:50]
    
Multiple columns can be indexed using a vector of column names:

    !r
    > (x <- haart[c("male", "age", "death")])
        male      age death
    1      1 25.00000     0
    2      1 49.00000     0
    ...
    1000   0 40.00000     0
    
---

Indexing
========

We can also extract particular rows according to the value of one or more variables. For example, if we are interested in the above columns for males:

    !r
    > (y <- x[x$male==1,])
        male      age death
    1      1 25.00000     0
    2      1 49.00000     0
    ...
    996    1 42.00000     0

We could have combined the previous two  operations into a single call that subsets
the specified columns that correspond to male :

    !r
    > (y <- haart[haart$male==1, c("male", "age", "death")])
        male      age death
    1      1 25.00000     0
    2      1 49.00000     0
    ...
    996    1 42.00000     0


---

Modifying and Creating Variables
================================

Suppose now we wish to create a derived variable, based on the values of one or more variables in the data frame. For example, we might want to refer to the number of days between the first visit (`init.date`) and the
last (`last.visit`). 

Recall from the lecture on date-time variables that in order to efficiently calculate temporal variables, we need to convert the date fields from character strings to `POSIXct` or `POXIXlt` objects.

    !r
    > haart$last.visit <- as.POSIXct(haart$last.visit)
    > haart$init.date <- as.POSIXct(haart$init.date)
    > haart$date.death <- as.POSIXct(haart$date.death)

Now we can subtract the later date from the earlier to get the time elapsed
between visits:

    !r
    > (haart$last.visit - haart$init.date)[1:50]
    Time differences in secs
     [1] 115434000 102470400  80874000   3538800 100918800 133833600 129164400
     [8] 171680400  70851600   7257600  21942000  37846800  77065200  42253200
    [15]   7344000    432000  56761200  45795600 154137600  68688000 107139600
    ...

---

Modifying and Creating Variables
================================

However, given the context of the data, we are probably interested in days elapsed between visits, rather than seconds. 

    !r
    > difftime(haart$last.visit, haart$init.date, units="days")[1:50]
    Time differences in days
     [1] 1336.04167 1186.00000  936.04167   40.95833 1168.04167 1549.00000
     [7] 1494.95833 1987.04167  820.04167   84.00000  253.95833  438.04167
    [13]  891.95833  489.04167   85.00000    5.00000  656.95833  530.04167
    ...

Even easier, since we are only interested in days, is to convert the dates to `Date` objects, which ignores time information:

    !r
    > (haart$time.diff <- as.Date(haart$last.visit) - as.Date(haart$init.date))
    Time differences in days
     [1] 1336 1186  936   41 1168 1549 1495 1987  820   84  254  438  892  489   85
    [16]    5  657  530 1784  795 1240  405 1090 1302  241 1270  413   21  286  710
    [31] 1110  265 1098 1051 1372  565  944  105  821 1169  405   24 1120 1272  693
    ...
    
---

Binning Data
============

Another common operation is the creation of variable categories from raw
values. The built-in function `cut` discretizes variables based on boundary values of the implied groups:

    !r
    > haart$age_group <- cut(haart$age, c(min(haart$age),30,50,max(haart$age)))

This creates a group for each group of ages in (18,30], (30, 50], and
(50, 89]:

    !r
    > table(haart$age_group)

     (0,30]  (30,50] (50,Inf] 
        1167     3021      442

If we wanted to use less than (rather than less than or equal to), we
could have specified `right=FALSE` to move the boundary values into the
upper group:

    !r
    > table(cut(haart$age, c(min(haart$age),30,50,max(haart$age)), right=FALSE))

    [18,30) [30,50) [50,89) 
       1011    3115     502
       
Presenter Notes
===============

For example, perhaps we want to classify subjects into age
groups, with those 30 or younger in the youngest group, those over 30
but no older than 50 in the middle group, and those over 50 in the
oldest group. 

---

Text Processing
===============

Often data will contain relevant information in the form of text that must be processed so that it can be used quantitatively, or appropriately displayed in a table or figure. Text is represented by the `character` type in R:

    !r
    > word <- 'foobar'
    > class(word)
    [1] "character"
    
Even though R considers text to be a vector of characters, indexing and other functions do not work the same way with characters:

    !r
    > word[1]
    [1] "foobar"
    > length(word)
    [1] 1
    
---

Text Processing
===============

R provides a separate set of functions to process text.

    !r
    > nchar(word)
    [1] 6
    > substr(word, 1, 3)
    [1] "foo"
    > substr(word, 3, 5)
    [1] "oba"
    
Not only can character strings be indexed, but they can be split up according to patterns in the text:

    !r
    > sentence <- "R provides a separate set of functions to process text"
    > (words <- strsplit(sentence, " "))
    [[1]]
     [1] "R"         "provides"  "a"         "separate"  "set"       "of"       
     [7] "functions" "to"        "process"   "text"     
     
This is useful for analysis of text, where individual words need to be counted, compared or evaluated. Note that this operation is reversible!

    !r
    > paste(unlist(words), collapse=" ")
    [1] "R provides a separate set of functions to process text"
    
---

Changing Case
=============

Character vectors can be changed to lower and upper case using the `tolower` and `toupper` functions:

    !r
    > toupper(word)
    [1] "FOOBAR"

Using these functions, you can create a custom function to convert to "title case":

    !r
    titlecase <- function(str) {
        str <- tolower(str)
        substr(str,1,1) <- toupper(substr(str,1,1))
        str
    }
    
    > titlecase(word)
    [1] "Foobar"
    
The `chartr` function translates characters to their corresponding pair in a text string:

    !r
    > (rna <- chartr('atcg', 'uagc', 'aagcgtctac'))
    [1] "uucgcagaug"
    
---

String Matching
===============

The function `charmatch` looks for unique matches for the elements of its first argument among those of its second.

If there is a single exact match or no exact match and a unique partial match then
the index of the matching value is returned; if multiple exact or multiple partial
matches are found then ‘0’ is returned and if no match is found then NA is
returned.


    !r
    > words
    [[1]]
     [1] "R"         "provides"  "a"         "separate"  "set"       "of"       
     [7] "functions" "to"        "process"   "text"   
    > charmatch('fun', unlist(words))
    [1] 7
    > charmatch('foo', unlist(words))
    [1] NA
    > charmatch('pr', unlist(words))
    [1] 0
 
---

Text Processing in Action
=========================

In the HAART database, the field `init.reg` describes the initial drug regimens of each individual, and is imported to R by default as a `factor`. 

    !r
    > head(haart$init.reg)
    [1] 3TC,AZT,EFV 3TC,AZT,EFV 3TC,AZT,EFV 3TC,AZT,NVP 3TC,D4T,EFV 3TC,AZT,NVP
    47 Levels: 3TC,ABC,AZT 3TC,ABC,AZT,LPV,RTV 3TC,ABC,AZT,RTV,SQV ... LPV,NVP,RTV
    > table(haart$init.reg)

            3TC,ABC,AZT 3TC,ABC,AZT,LPV,RTV 3TC,ABC,AZT,RTV,SQV         3TC,ABC,EFV 
                     29                   1                   1                  11 
        3TC,ABC,IDV,RTV         3TC,ABC,NVP         3TC,ABC,RTV     3TC,ABC,RTV,SQV 
                      1                   2                   1                   4 
            3TC,AZT,DDI         3TC,AZT,EFV     3TC,AZT,EFV,NFV     3TC,AZT,FPV,RTV 
                      1                 421                   1                   1 
            3TC,AZT,IDV     3TC,AZT,IDV,RTV     3TC,AZT,LPV,RTV         3TC,AZT,NFV 
                     12                   8                  16                   4 

However, each entry is in fact a list of drugs, and we may not want to analyze the data based on the unique combinations of drugs. 


---

Creating a List Variable
========================

One approach is to change the variable to a useful data structure like a list or a vector, which can be easily queried for individual drugs.

First, we will convert the variable to a `character` type, and assign it to a temprorary variable:

    > init.reg <- as.character(haart$init.reg)

Now, we can use some of our text processing skill to extract the individual drug names:

    > (haart$init.reg_list <- strsplit(init.reg, ","))
    [[1]]
    [1] "3TC" "AZT" "EFV"

    [[2]]
    [1] "3TC" "AZT" "EFV"

    [[3]]
    [1] "3TC" "AZT" "EFV"

    ...
    
---

The `apply` Functions
=====================

In some situations, users may want to apply functions to elements of a
list or data frame. To facilitate this, there is a family of functions
called `apply` functions that permit functions to be called on subsets
of data without having to manually loop over elements in complex data
structures.

`tapply` applies a function to different subsets of the data, grouped
according to factor variables. For example, suppose we wanted to know
the mean weight of subjects by gender:

    !r
    > tapply(haart$weight, haart$male, mean, na.rm=TRUE)
           0        1 
    51.65059 60.33728

* first argument is the target vector to which the function will be
applied
* second argument is the index variable that dictates by what
factor the application of the function will be grouped
* third argument is the function that will be used
* fourth argument is a flag to tell `tapply` to ignore the missing
values

---

Cross-tabulation with `tapply`
==============================

Multiple factors can be passed to `tapply` simultaneously, resulting in
cross-tabulated output:

    !r
    > tapply(haart$weight, haart[c("male", "aids")], mean, na.rm=TRUE)
        aids
    male        0        1
       0 53.95558 48.41616
       1 63.11145 57.38151

This can be further expanded to a 3-way cross-tabulation, if appropriate:

    !r
    > tapply(haart$weight, haart[c("male", "aids", "death")], mean, na.rm=TRUE)
    , , death = 0

        aids
    male        0        1
       0 54.18083 49.51265
       1 64.80861 59.56368

    , , death = 1

        aids
    male        0        1
       0 50.43750 39.78671
       1 52.57965 49.04523
    

---

`lapply`
========

The `lapply` function, after applying the specified function, attempts to coerce output into a list.

For example, if we want to take the means of several quantitative variables:

    !r
    > (haart_means <- lapply(haart[,4:6], mean, na.rm=T))
    $cd4baseline
    [1] 137.1859

    $logvl
    [1] 4.84446

    $weight
    [1] 57.00708

    > haart_means$weight
    [1] 57.00708

This allows the results to be indexed by name.

---

`sapply`
========

`sapply` tries to return a simpler data structure, generally a vector. For
example, we may simply want to quickly query which of our variables are numeric:

    !r
    > sapply(haart, is.numeric)
            male          age         aids  cd4baseline        logvl       weight 
            TRUE         TRUE         TRUE         TRUE         TRUE         TRUE 
      hemoglobin      init.reg     init.date    last.visit        death    date.death 
            TRUE        FALSE        FALSE        FALSE         TRUE        FALSE 
    init.reg_list       gender 
           FALSE        FALSE 

Or, perhaps we are interested in standardizing some of the variables in
our data frame:

    !r
    > sapply(haart[c("cd4baseline", "weight", "hemoglobin")], scale)[1:5,]
         cd4baseline      weight  hemoglobin
    [1,]          NA          NA          NA
    [2,]  0.08539255  0.09425106 -0.06792736
    [3,] -0.24968729 -0.72919671 -4.23067363
    [4,] -0.20882389 -0.90096287          NA
    [5,] -0.65832124          NA          NA


   
---

Querying List Variables
=======================

Now, let's use one of these `apply` functions to query our variable containing the vectors of drugs. For example, we might want to know all the patients that have D4T
as part of their regimens. 

    !r
    > d4t_index <- sapply(haart$init.reg_list, function(x) 'D4T' %in% x)
    > haart_D4T <- haart[d4t_index, ]
    > head(haart_D4T)
       male      age aids cd4baseline    logvl weight hemoglobin     init.reg
    5     1 27.00000    0          52 4.000000     NA         NA 3TC,D4T,EFV
    16    0 43.00000    1          49       NA     NA    3.00000 3TC,D4T,NVP
    18    1 33.85079    1           4       NA     64   12.00000 3TC,D4T,EFV
    25    0 29.00000   NA          25 4.463878     44         NA 3TC,D4T,EFV
    30    0 49.79877    1         207       NA     36   10.66667 3TC,D4T,EFV
    38    0 37.00000    1          NA       NA     NA   12.80000 3TC,D4T,NVP
       init.date last.visit death date.death  init.reg_list gender
    5    9/1/04  11/13/07     0           3TC, D4T, EFV   male
    16   6/7/04   6/12/04     1   6/12/04 3TC, D4T, NVP female
    18 10/12/04   3/26/06     0           3TC, D4T, EFV   male
    25  8/15/06   4/13/07     0           3TC, D4T, EFV female
    30   3/5/04   2/13/06     0           3TC, D4T, EFV female
    38   9/5/07  12/19/07     0           3TC, D4T, NVP female
    
The `%in%` operator, returns `TRUE` if the value on the left hand side of the
operator is contained in the vector on the right hand side, or `FALSE` otherwise.

---

Creating Indicator Variables
============================

Another approach for transforming `init.reg` is to
break it into multiple columns of indicators, which specify whether each
drug is in that individual's regimen. 

The first lets create a unique list of all the drugs in all the regimens. Recall `unlist`, which takes all the list elements and concatenates them
together. We can use this to get a non-unique vector of drugs:

    !r
    > unlist(haart$init.reg_list)
       [1] "3TC" "AZT" "EFV" "3TC" "AZT" "EFV" "3TC" "AZT" "EFV" "3TC" "AZT" "NVP"
      [13] "3TC" "D4T" "EFV" "3TC" "AZT" "NVP" "3TC" "AZT" "NVP" "3TC" "AZT" "EFV"
      [25] "3TC" "ABC" "AZT" "3TC" "DDI" "NVP" "3TC" "AZT" "NVP" "3TC" "AZT" "IDV"
      ...
      [3073] "NVP" "3TC" "AZT" "NVP" "3TC" "D4T" "NVP"
      
Now, we use the function `unique` to extract the unique items within
this vector, which comprises a list of all the drugs:

    !r
    > (all_drugs <- unique(unlist(haart$init.reg_list)))
     [1] "3TC"         "AZT"         "EFV"         "NVP"         "D4T"         "ABC"         "DDI"        
     [8] "IDV"         "LPV"         "RTV"         "SQV"         "FTC"         "TDF"         "DDC"        
    [15] "NFV"         "T20"         "ATV"         "FPV"         "TPV"         "DLV"         "HIDROXIUREA"
    [22] "APV"


---

Creating Indicator Variables
============================

Now that we have all the drugs, we want a logical vector for each drug
that identifies its inclusion for each individual. We have already seen
how to do this, for D4T:

    !r
    > sapply(haart$init.reg_list, function(x) 'D4T' %in% x)
       [1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
      [13] FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
      ...
      [997] FALSE FALSE FALSE  TRUE
    
Now we generalize this by writing a loop that performs this operation for each drug:

    !r
    for (drug in all_drugs) {
        sapply(haart$init.reg_list, function(x) drug %in% x)
    }


Presenter Notes
===============

Notice that when you run this function, nothing is returned. This is
because we have not assigned the resulting vectors to variables, nor
have we specified that they be printed to the screen.

---

Creating Indicator Variables
============================

The strategy is to create an empty vector, then to `cbind` (column-bind) successive indicator variables for each drug:

    > reg_drugs <- c()
    > for (drug in all_drugs) {
    + reg_drugs <- cbind(reg_drugs,
    + sapply(haart$init.reg_list, function(x) drug %in% x))
    + }
    > head(reg_drugs)
         [,1]  [,2]  [,3]  [,4]  [,5]  [,6]  [,7]  [,8]  [,9] [,10] [,11] [,12] [,13] [,14] [,15] [,16]
    [1,] TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    [2,] TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    [3,] TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    [4,] TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    [5,] TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    [6,] TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
         [,17] [,18] [,19] [,20] [,21] [,22]
    [1,] FALSE FALSE FALSE FALSE FALSE FALSE
    [2,] FALSE FALSE FALSE FALSE FALSE FALSE
    [3,] FALSE FALSE FALSE FALSE FALSE FALSE
    [4,] FALSE FALSE FALSE FALSE FALSE FALSE
    [5,] FALSE FALSE FALSE FALSE FALSE FALSE
    [6,] FALSE FALSE FALSE FALSE FALSE FALSE


---

Creating Indicator Variables
============================

Turning this into a data frame is as simple as a call to `data.frame`,
using `all_drugs` as a set of column labels:

    > reg_drugs <- data.frame(reg_drugs)
    > names(reg_drugs) <- all_drugs

Now use `cbind` to merge the indicator variables with the original data frame:

    > haart_merged <- cbind(haart, reg_drugs)
    > head(haart_merged)
      male age aids cd4baseline logvl  weight hemoglobin     init.reg init.date
    1    1  25    0          NA    NA      NA         NA 3TC,AZT,EFV   7/1/03
    2    1  49    0         143    NA 58.0608         11 3TC,AZT,EFV 11/23/04
    3    1  42    1         102    NA 48.0816          1 3TC,AZT,EFV  4/30/03
    4    0  33    0         107    NA 46.0000         NA 3TC,AZT,NVP  3/25/06
    5    1  27    0          52     4      NA         NA 3TC,D4T,EFV   9/1/04
    6    0  34    0         157    NA 54.8856         NA 3TC,AZT,NVP  12/2/03
      last.visit death date.death  init.reg_list gender  3TC   AZT   EFV   NVP   D4T
    1   2/26/07     0           3TC, AZT, EFV   male TRUE  TRUE  TRUE FALSE FALSE
    2   2/22/08     0           3TC, AZT, EFV   male TRUE  TRUE  TRUE FALSE FALSE
    3  11/21/05     1   1/11/06 3TC, AZT, EFV   male TRUE  TRUE  TRUE FALSE FALSE
    4    5/5/06     1    5/7/06 3TC, AZT, NVP female TRUE  TRUE FALSE  TRUE FALSE
    5  11/13/07     0           3TC, D4T, EFV   male TRUE FALSE  TRUE FALSE  TRUE
    6   2/28/08     0           3TC, AZT, NVP female TRUE  TRUE FALSE  TRUE FALSE
        ABC   DDI   IDV   LPV   RTV   SQV   FTC   TDF   DDC   NFV   T20   ATV   FPV
    1 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    2 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    3 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    4 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    5 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    6 FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE


---

Subsetting
==========

Though you can manually extract subsets of a particular data frame by manually
indexing rows, the `subset` function is a more convenient method for extensive
subsetting.

For example, we may want to select the endpoint event, weight and hemoglobin for
just the male subjects over 30 years old. This is straightforward:

    !r
    > haart_m30 <- subset(haart, gender=="male" & age>30, select=c(death, weight, hemoglobin))
    > head(haart_m30)
       death  weight hemoglobin
    2      0 58.0608   11.00000
    3      1 48.0816    1.00000
    8      0      NA         NA
    9      0      NA         NA
    11     1 57.0000   12.33333
    12     0 48.0000         NA

So, the first argument is the data frame of interest, the second argument are the
subset conditions and the third is a vector of variables to be included in the
resulting dataset.

---

Missing Values
==============

Real-world data are rarely complete. Though analytic methods for dealing with missing values is outside the scope of this lecture, it is useful to know how to identify and remove records with missing values.

The convenience function `complete.cases` returns a logical vector identifying which rows have no missing values across the entire sequence.

    !r
    > complete.cases(haart$weight)
       [1] FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE
      [13]  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE
      ...
      [997] FALSE  TRUE  TRUE  TRUE
      
Which is the equivalent of `!is.na(haart$weight)`. We can use this logical vector to extract all observations for which weight is present:

    !r
    > head(haart[complete.cases(haart$weight),])
       male      age aids cd4baseline logvl  weight hemoglobin     init.reg init.date
    2     1 49.00000    0         143    NA 58.0608   11.00000 3TC,AZT,EFV 11/23/04
    3     1 42.00000    1         102    NA 48.0816    1.00000 3TC,AZT,EFV  4/30/03
    4     0 33.00000    0         107    NA 46.0000         NA 3TC,AZT,NVP  3/25/06
    6     0 34.00000    0         157    NA 54.8856         NA 3TC,AZT,NVP  12/2/03
    7     0 39.00000    0          65    NA 55.3392   11.00000 3TC,AZT,NVP   2/6/04
    11    1 49.40726    1          NA    NA 57.0000   12.33333 3TC,AZT,NVP   1/7/02
       last.visit death date.death  init.reg_list gender
    2    2/22/08     0           3TC, AZT, EFV   male
    3   11/21/05     1   1/11/06 3TC, AZT, EFV   male
    4     5/5/06     1    5/7/06 3TC, AZT, NVP female
    6    2/28/08     0           3TC, AZT, NVP female
    7    3/11/08     0           3TC, AZT, NVP female
    11   9/18/02     1   9/18/02 3TC, AZT, NVP   male
    

---

Sorting
=======

Though the `sort` function in R is the easiest way to sort the elements
of a single vector, we are usually interested in sorting entire
records/observations/rows according to the value of one or more
parameters. In this case, it is a two-step process.

First, we create a numeric vector of the indices of each row in our data
frame, according to the order that we wish to have them. 

    !r
    > order(haart$init.date, haart$last.visit)
       [1]  829   93  155  143  451  786  328  998  787  105  130  882  474  745
      [15]  733  917  826  256   98  603  765  283  715  801  620  324  510  552
    ...
     [995]   91  229  866  388  287   22

The `order` function generates indices of every row in the HAART database, sorted first by `init.date` and then by `last.visit`.

---

Sorting
=======

The second step is to use these index values to generate a sorted
version of our data frame:

    !r
    > haart_sorted <- haart[order(haart$init.date, haart$last.visit),]
    > head(haart_sorted)
        male age aids cd4baseline logvl  weight hemoglobin     initreg initdate
    829    1  19    0         216    NA 62.5000         NA 3TC,D4T,NFV   1/1/02
    93     1  51    0          NA    NA      NA         NA 3TC,D4T,NVP   1/1/03
    155    1  39    0          NA    NA 63.0000         NA 3TC,AZT,EFV   1/1/04
    143    0  45    0          35    NA 48.5352         10 3TC,AZT,EFV  1/10/05
    451    1  43    1          NA    NA      NA         NA 3TC,AZT,EFV  1/11/04
    786    1  42    0         282    NA 66.2256         NA 3TC,AZT,EFV  1/11/05
        lastvisit death datedeath  initreg_list gender
    829   7/30/06     0           3TC, D4T, NFV   male
    93    4/19/07     0           3TC, D4T, NVP   male
    155   2/23/07     0           3TC, AZT, EFV   male
    143   1/10/05     0           3TC, AZT, EFV female
    451   7/10/06     0           3TC, AZT, EFV   male
    786   2/27/08     0           3TC, AZT, EFV   male

---

Merging Data Frames
===================

We have seen how to combine data frames using `cbind` to add additional columns to an existing data frame. Similarly, data frames can be combined by row using `rbind`:

    !r
    > dim(rbind(haart[1:500,], haart[501:1000,]))
    [1] 1000   14
    
This works, provided that the number of columns match:

    !r
    > dim(rbind(haart[1:500,], haart[501:1000,1:10]))
    Error in rbind(deparse.level, ...) : 
      numbers of columns of arguments do not match
      
In some situations, we may have information in one table that *partially* matches information in a second table. What if we want to integrate this information into a single data frame?

---

Merging Data Frames
===================

To combine data frames based on the values of common variables, we can use the built-in `merge` function. By default, `merge` joins rows of the data frames based on the values of the columns that the data frames have in common. 

Let's look at a trivial example of two data frames with partial overlap in information:

    !r
    > df1 <- data.frame(a=c(1,2,4,5,6),x=c(9,12,14,21,8))
    > df2 <- data.frame(a=c(1,3,4,6),y=c(8,14,19,2))
    > merge(df1, df2)
      a  x  y
    1 1  9  8
    2 4 14 19
    3 6  8  2
    
Note that though there were 6 unique values for `a` among the two data frames, only those rows with values of `a` in both data frames are included in the merged data frame.

---

Merging Data Frames
===================

If we want to include all observations from both data frames, we can set the appropriate flag, which will result in missing values:

    !r
    > merge(df1, df2, all=TRUE)
      a  x  y
    1 1  9  8
    2 2 12 NA
    3 3 NA 14
    4 4 14 19
    5 5 21 NA
    6 6  8  2
    
Or we may wish to include all records from just one of the two tables:

    !r
    > merge(df1, df2, all.x=TRUE)
      a  x  y
    1 1  9  8
    2 2 12 NA
    3 4 14 19
    4 5 21 NA
    5 6  8  2
    > merge(df1, df2, all.y=TRUE)
      a  x  y
    1 1  9  8
    2 3 NA 14
    3 4 14 19
    4 6  8  2
    