Data Import and Export in R
===========================



---

Data Export
===========

The most rudimentary way to export data from R is to use the `cat` function, which we have previously used to print data to the screen:

    !r
    > cat("Happy Monday!", "\n")
    Happy Monday! 
    > iterations <- 10
    > for (j in 1:iterations) {
    + cat(j, "...")
    + if (j==iterations) cat("Done!", "\n")
    + }
    1 ...2 ...3 ...4 ...5 ...6 ...7 ...8 ...9 ...10 ...Done! 
    
But if we give `cat` a file argument, it appends subsequent arguments to that file:
    
    !r
    > some_file <- tempfile()
    > cat(file=some_file, "foo", "bar", seq(1:10), sep="\n")
    > some_file
    [1] "/var/folders/yc/sh2m97w17_1dsm2bzmcj1v4m0000gn/T//RtmpWGZaPH/file1483e3a888e2f"

---

`write`
=======

If we are writing a matrix or data frame to a file, it is more convenient to use `write` or `write.table`.

`write` just writes out a matrix (transposed) or vector in a specified number of columns.

    !r
    > my_mat <- outer(c(1,4,6),c(8,-1,4))
    > write(my_mat, "my_mat.dat", ncolumn=3)
    
    $ more my_mat.dat
    8 32 48
    -1 -4 -6
    4 16 24

`write.table` exports a data frame, complete with row and column labels.

    !r
    > write.table(my_mat, "my_df.dat")
    
    $ more my_df.dat
    "V1" "V2" "V3"
    "1" 8 -1 4
    "2" 32 -4 16
    "3" 48 -6 24
    

---

`write.table`
=============

    > ?write.table
    
    write.table               package:utils                R Documentation

    Data Output

    Description:

         ‘write.table’ prints its required argument ‘x’ (after converting
         it to a data frame if it is not one nor a matrix) to a file or
         connection.

    Usage:

         write.table(x, file = "", append = FALSE, quote = TRUE, sep = " ",
                     eol = "\n", na = "NA", dec = ".", row.names = TRUE,
                     col.names = TRUE, qmethod = c("escape", "double"),
                     fileEncoding = "")
     
         write.csv(...)
         write.csv2(...)
     
    ...
    
Note that `write.table` is inefficient for very large arrays; `write.matrix` is more memory-efficient.

---

Exporting Data Frames
=====================

There are additional considerations when storing a data frame as a text file:

* precision of `numeric` values
* header information
* column separator
* missing values
* quoting strings

To write a CSV file for input to Excel:

    !r
    write.table(x, file = "foo.csv", sep = ",", col.names = NA)



---

`read.table`
============

The function `read.table` is the easiest way to read in a rectangular grid of data. Considerations include:

* Header line
* Column separator
* Quoting strings
* Missing values
* Unfilled lines
* White space in character fields Blank lines
* Classes for the variables 
* Comments

To read a comma-separated values (csv) file back into R:

    !r
    read.table("file.csv", header = TRUE, sep = ",", row.names=1)

---

`read.table`
============

    > ?read.table
    
    read.table                package:utils                R Documentation

    Data Input

    Description:

         Reads a file in table format and creates a data frame from it,
         with cases corresponding to lines and variables to fields in the
         file.

    Usage:

         read.table(file, header = FALSE, sep = "", quote = "\"'",
                    dec = ".", row.names, col.names,
                    as.is = !stringsAsFactors,
                    na.strings = "NA", colClasses = NA, nrows = -1,
                    skip = 0, check.names = TRUE, fill = !blank.lines.skip,
                    strip.white = FALSE, blank.lines.skip = TRUE,
                    comment.char = "#",
                    allowEscapes = FALSE, flush = FALSE,
                    stringsAsFactors = default.stringsAsFactors(),
                    fileEncoding = "", encoding = "unknown", text)
    

---

`read.table`
============

Due to the frequency with which they are used, there are several helper functions that call `read.table` to import several common file types:

    !r 
    read.csv(file, header = TRUE, sep = ",", quote="\"", dec=".", 
        fill = TRUE, ...)
    
    read.csv2(file, header = TRUE, sep = ";", quote="\"", dec=",", 
        fill = TRUE, ...)
    
    read.delim(file, header = TRUE, sep = "\t", quote="\"", dec=".", 
        fill = TRUE, ...)
    
    read.delim2(file, header = TRUE, sep = "\t", quote="\"", dec=",", 
        fill = TRUE, ...)
        
---
   
Fixed-width Format
==================

Sometimes data files have no field delimiters but have fields in pre-specified columns. `read.fwf` provides a simple way to read such files, specifying a vector of field widths.

    !r
    > fixed_data <- tempfile()
    > cat(file=fixed_data, "1 -14  23", "1   7 -10", sep="\n")
    > read.fwf(fixed_data, width=c(1,4,4))
      V1  V2  V3
    1  1 -14  23
    2  1   7 -10

---

`scan`
======

Under the hood, both `read.table` and `read.fwf` use the function `scan` to read the file contents into R, before processing them. For increased flexibility, we can use `scan` directly.

    > ?scan
    scan                   package:base                    R Documentation

    Read Data Values

    Description:

         Read data into a vector or list from the console or file.

    Usage:

         scan(file = "", what = double(), nmax = -1, n = -1, sep = "",
              quote = if(identical(sep, "\n")) "" else "'\"", dec = ".",
              skip = 0, nlines = 0, na.strings = "NA",
              flush = FALSE, fill = FALSE, strip.white = FALSE,
              quiet = FALSE, blank.lines.skip = TRUE, multi.line = TRUE,
              comment.char = "", allowEscapes = FALSE,
              fileEncoding = "", encoding = "unknown", text)

The `what` argument can be a list of modes for the variables in the file.

---

`scan`
======

    !r
    > cat("2 3 5 7", "11 13 17 19", file="ex.dat", sep="\n") 
    > scan(file="ex.dat")
    Read 8 items
    [1] 2 3 5 7 11 13 17 19
    > scan(file="ex.dat", what=list(x=0, y="", z=0), flush=TRUE) 
    Read 2 records
    $x
    [1] 2 11
    $y
    [1] "3"  "13"
    $z
    [1]  5 17

`scan` can also be used for rudimentary data entry:

    !r
    !r
    > x <- scan()
    1: 4
    2: 7 3
    4:
    Read 3 items 
    > x
    [1] 4 7 3
    


---

Importing Source Code
=====================

You can use source to read in R code: 

    !r
    > source("my_script.R")
    
The commands in `my_script.R` will be executed, and the objects specified will be created in your current `.RData` file. 

You can also use `source` to read in functions you wrote:

    !r
    myfunction <- source("my_function.R")

The file you read in can contain more than one function statement, where they are read in at the same time.

    !r
    source("useful_functions.R")


---

Redirecting Output
==================

You may wish to redirect output from functions or other R code to a file, rather than having it printed to the screen. `scan` will do this, taking a file as the first argument, and optionally a flag for whether you want to append or overwrite the contents of the file.

    !r
    > sink("sink-examp.txt")
    > i <- 1:10
    > outer(i, i, "*")
    > sink() # stops redirection
    
    $ more sink-examp.txt
          [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
     [1,]    1    2    3    4    5    6    7    8    9    10
     [2,]    2    4    6    8   10   12   14   16   18    20
     [3,]    3    6    9   12   15   18   21   24   27    30
     [4,]    4    8   12   16   20   24   28   32   36    40
     [5,]    5   10   15   20   25   30   35   40   45    50
     [6,]    6   12   18   24   30   36   42   48   54    60
     [7,]    7   14   21   28   35   42   49   56   63    70
     [8,]    8   16   24   32   40   48   56   64   72    80
     [9,]    9   18   27   36   45   54   63   72   81    90
    [10,]   10   20   30   40   50   60   70   80   90   100

---

Storing Data
============

Every R object can be stored into and restored from a file with the commands `save` and `load`, respectively. This uses Sun Microsystems' external data representation (XDR) standard, and is portable among platforms.

    !r
    > x <- 1:4
    > save(x,file="x.Rdata") # encode
    > rm(x)
    > load("x.Rdata") # decode
    >x
    [1] 1 2 3 4

At the end of a session the objects in the global environment are usually kept in a single binary file in the working directory called .RData. By default, this is loaded to the next session, but can also be loaded manually with `load`.

---

Importing from Other Systems
============================

The package `foreign` provides import facilities for files produced by:

* **Minitab** read.mtp
* **S-PLUS** read.S
* **SAS** read.xport,read.ssd
* **SPSS** read.spss

and export and import facilities for Stata (`read.dta`, `write.dta`).