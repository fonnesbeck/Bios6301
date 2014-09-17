
## ------------------------------------------------------------------------
cat("Happy Tuesday!", "\n")
iterations <- 10
for (j in 1:iterations) {
  cat(j, "...")
  if (j==iterations) cat("Done!", "\n")
}


## ------------------------------------------------------------------------
some_file <- tempfile()
cat(file=some_file, "foo", "bar", seq(1:10), sep="\n")
some_file


## ------------------------------------------------------------------------
my_mat <- outer(c(1,4,6),c(8,-1,4))
write(my_mat, "my_mat.dat", ncolumn=3)
system("cat my_mat.dat", TRUE)


## ------------------------------------------------------------------------
write.table(my_mat, "my_df.dat")
system("cat my_df.dat", TRUE)


## ------------------------------------------------------------------------
x <- data.frame(id=seq(10), height=round(rnorm(10,70,4)), weight=round(rnorm(10,180,20)*2)/2)
write.table(x, file = "foo.csv", sep = ",", col.names = NA)


## ------------------------------------------------------------------------
read.table("foo.csv", header = TRUE, sep = ",", row.names=1)


## ------------------------------------------------------------------------
fixed_data <- tempfile()
cat(file=fixed_data, "1 -14  23", "1   7 -10", sep="\n")
read.fwf(fixed_data, width=c(1,4,4))


## ------------------------------------------------------------------------
cat("2 3 5 7", "11 13 17 19", file="ex.dat", sep="\n")
scan(file="ex.dat")
scan(file="ex.dat", what=list(x=0, y="", z=0), flush=TRUE)


## ------------------------------------------------------------------------
# play intramural softball so I can track your stats
read.csv('http://data.vanderbilt.edu/~graywh/intramurals/softball/batting_stats_career.txt', row.names=1, strip.white=TRUE)["Cole",]


## ------------------------------------------------------------------------
x <- 1:4
save(x, file="x.Rdata") # encode
rm(x)
load("x.Rdata") # decode
x


## ----echo=FALSE, results='hide'------------------------------------------
# clean-up files created during session
file.remove('x.Rdata','ex.dat','foo.csv','my_df.dat','my_mat.dat')


## ------------------------------------------------------------------------
cat(file="file1.dat", 5, 12, 13, sep=',')
cat(file="file2.dat", 7, 6, 1, sep=',')
cat(file="file3.dat", 14, 5, 5, sep=',')


## ------------------------------------------------------------------------
sumfiles <- function(dname) {
    # Initialize sum
    tot <- 0
    # Get names of all files in the directory
    fls <- dir(dname)
    # Loop over directory contents
    for (f in fls) {
        # Determine if item is a data file
        if (substr(f, nchar(f)-3, nchar(f)) == '.dat') {
            # Sum contents and add to total
            tot <- tot + sum(scan(f,sep=',',quiet=TRUE))
        }
    }
    return(tot)
}
sumfiles('.')


## ------------------------------------------------------------------------
sumfiles <- function(dname) {
  tot <- 0
  for(f in dir(dname, pattern='.dat$')) {
    tot <- tot + sum(scan(f,sep=',',quiet=TRUE))
  }
  tot
}
sumfiles('.')


## ----echo=FALSE, results='hide'------------------------------------------
# clean-up files created during session
file.remove('file1.dat', 'file2.dat', 'file3.dat')


## ------------------------------------------------------------------------
getwd()
file <- file.path("~", "Documents", "junk091814.txt")
file
file.create(file)
dirname(file)
basename(file)
file.remove(file)
setwd("~")

