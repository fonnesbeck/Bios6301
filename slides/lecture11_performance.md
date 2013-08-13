Performance Computing in R
==========================

---

Performance
===========

There are two axes to performance in computer science: execution speed and memory usage. We would like our programs to run faster and use as little memory as possible.

These aspects are often traded off.

R is an interpreted language, which means that code written in R can be slower (often **much** slower) than equivalent implementations in compiled languages.

All objects in R are stored in system memory. Large objects are going to use up available RAM.

---

Interpreted Languages
=====================

Compiled languages convert source code to machine code that is directly executed by the CPU.

Interpreted languages are executed indirectly from the source code by an *interpreter* that reduces it to machine code at runtime.

![compiled vs interpreted](images/code.png)

---

R Benchmarks
============

Language benchmark times relative to C++ (smaller is better):

<table class="benchmarks">
<colgroup>
<col class="name"></col>
<col class="relative" span="7"></col>
</colgroup>
<thead>
<tr><td></td><th class="system">Fortran</th><th class="system">Julia</th><th class="system">Python</th><th class="system">Matlab</th><th class="system">Octave</th><th class="system">R</th></tr>
<!-- <tr><td></td><td class="version">GCC 4.5.1</td><td class="version">12b1d5a7</td><td class="version">2.7.3</td><td class="version">R2011a</td><td class="version">3.4</td><td class="version">2.14.2</td></tr> -->
</thead>
<tbody>
<tr><th>fib</th><td class="data">0.28</td><td class="data">1.97</td><td class="data">46.03</td><td class="data">1587.03</td><td class="data">2748.74</td><td class="data">275.63</td></tr>
<tr><th>parse_int</th><td class="data">9.22</td><td class="data">1.72</td><td class="data">25.29</td><td class="data">846.67</td><td class="data">7364.87</td><td class="data">353.48</td></tr>
<tr><th>quicksort</th><td class="data">1.65</td><td class="data">1.37</td><td class="data">69.20</td><td class="data">133.46</td><td class="data">3341.94</td><td class="data">708.76</td></tr>
<tr><th>mandel</th><td class="data">0.76</td><td class="data">1.45</td><td class="data">34.88</td><td class="data">74.61</td><td class="data">988.74</td><td class="data">184.71</td></tr>
<tr><th>pi_sum</th><td class="data">1.00</td><td class="data">1.00</td><td class="data">33.64</td><td class="data">1.46</td><td class="data">457.26</td><td class="data">253.45</td></tr>
<tr><th>rand_mat_stat</th><td class="data">2.23</td><td class="data">1.95</td><td class="data">29.01</td><td class="data">7.71</td><td class="data">31.04</td><td class="data">12.66</td></tr>
<tr><th>rand_mat_mul</th><td class="data">1.14</td><td class="data">1.00</td><td class="data">1.75</td><td class="data">1.08</td><td class="data">1.93</td><td class="data">9.58</td></tr>
</tbody>
</table>

---

Speeding Up R
=============

There are three main ways of improving the performance of your R code:

* Optimize your R code through vectorization, use of byte-code compilation, and other approaches.
* Write the key, CPU-intensive parts of your code in a compiled language such as C, C++ or Fortran.
* Write your code in some form of parallel R.

In this lecture, we will deal with the first approach.

---

Avoiding Loops
==============

Frequently, the slowest part of a program will be parts of the code that are called repeatedly through one of the loop structures that you have learned in this course.

How do we perform iterative operations without using loops?

In interpreted languages, one can often achieve a dramatic speedup by **vectorizing**, rather than looping, certain operations.

---

Vectorization
=============

We have already seen vectorized operations in R:

    !r
    > x <- 1:5
    > y <- c(-5, 3, 7, 0, 2)
    > (z <- x + y)
    [1] -4  5 10  4  7
    
Without vectorization, we would have had to construct:

    !r
    for (i in 1:length(x)) {
        z[i] <- x[i] + y[i]
    }
    
This is not only more verbose, but much slower.

    !r
    > x <- runif(1000000)
    > y <- runif(1000000)
    > z <- vector(length=1000000)
    > system.time(z <- x + y)
       user  system elapsed 
      0.018   0.002   0.021 
    > system.time(for (i in 1:length(x)) z[i] <- x[i] + y[i])
       user  system elapsed 
      2.845   0.023   2.887

---

Vectorization
=============

The vectorized code is two orders of magnitude faster! What causes the slowdown in loops?

Numerous function calls

* `for` is a function
* `:` in `1:length(x)` is a function:

        > ":"(1,10)
         [1]  1  2  3  4  5  6  7  8  9 10

* each indexing operation is a function call

Function calls are computationally costly, resulting in increased processing time  at every iteration of the loop.

The vectorized version has only two function calls, called once each.

---

Vector Filtering    
================

Here is some code for counting the number of odd numbers in a vector:

    !r
    oddcount <- function(x) {
        c <- 0
        for (i in 1:length(x))
            if (x[i] %% 2 == 1) c <- c+1
        return(c)
    }

Compare this to a vectorized implementation:

    !r
    oddcount_fast <- function(x) return(sum(x%%2==1))
    
We again see a dramatic difference:

    !r
    > x <- sample(1:1000000, 100000, replace=T)
    > system.time(oddcount(x))
       user  system elapsed 
      0.138   0.001   0.138 
    > system.time(oddcount_fast(x))
       user  system elapsed 
      0.003   0.000   0.003 

Presenter Notes
===============

If this code had been part of an enclosing loop, with many iterations, the difference could be important indeed.

---

Vectorized Functions
====================

Commonly-used vectorized functions in R include:

* `ifelse`
* `which`
* `where`
* `any`
* `all`
* `cumsum`
* `cumprod`
* `rowSums`
* `colSums`

Note that the `apply` family of functions, though vectorized, do not offer substantial speedups in execution time. This is because they are implemented in R rather than C.

---

Example: Monte Carlo Simulation
===============================

Simulation models can often require hours, days or weeks of computing time, so it is worthwhile pursuing performance improvements.

This simulation samples a pair of standard normal variates, and sums the largest of each pair, then calculates the mean.

    !r
    max_norm <- function(nreps) {
        sum <- 0
        for (i in 1:nreps) {
           xy <- rnorm(2)  # generate 2 N(0,1)s
           sum <- sum + max(xy)
        }
        return(sum/nreps)
    }

Here's vectorized version:

    !r
    max_norm_vect <- function(nreps) {
        xymat <- matrix(rnorm(2*nreps),ncol=2)
        maxs <- pmax(xymat[,1],xymat[,2])
        return(mean(maxs))
    }

Presenter Notes
===============

In this code, we generate all the random variates at once, storing them in a matrix xymat, with one (X,Y) pair per row
Next, we find all the max(X,Y) values, storing those values in maxs, and then simply call mean

---

Example: Monte Carlo Simulation
===============================

The speedup is dramatic again:

    !r
    > system.time(max_norm(100000))
       user  system elapsed 
      0.468   0.034   0.508 
    > system.time(max_norm_vect(100000))
       user  system elapsed 
      0.022   0.002   0.029 
      
In this example also shows the tradeoff between speed and memory. Note that in the vectorized version, the random numbers are stored in a matrix, rather than being discarded as they are generated:

    !r
    xymat <- matrix(rnorm(2*nreps),ncol=2)

---

Example: Powers Matrix
======================

Recall from last week's polynomial regression example, we needed to generate a matrix of the powers of the predictor variable. The function for this was:

    !r
    powers <- function(x, dg) {
        pw <- matrix(x,nrow=length(x))
        prod <- x
        for (i in 2:dg) {
            prod <- prod * x
            pw <- cbind(pw,prod)
        }
        return(pw)
    }
    
The biggest performance issue with this function is the repeated use of `cbind` to build up the matrix. A better approach is to pre-allocate an empty matrix:

    !r
    powers_fast <- function(x,dg) {
        pw <- matrix(nrow=length(x),ncol=dg)
        pw[,1] <- x
        for (i in 2:dg) {
            pw[,i] <- pw[,(i-1)] * x
        }
        return(pw)
    }
    
Presenter Notes
===============

This results in a series of memory-allocation operations, which is time-consuming. 

---
    
Example: Powers Matrix
======================

And indeed, the preallocated version is a lot faster.

    !r
    > x <- runif(1000000)
    > system.time(powers(x,8))
       user  system elapsed 
      0.330   0.110   0.475 
    > system.time(powers_fast(x,8))
       user  system elapsed 
      0.171   0.026   0.198 

**Can we do better??**

We can try replacing the loop using the vectorized `outer` function:

    !r
    powers_vect <- function(x, dg) return(outer(x, 1:dg, "^"))
    
This has to be faster, because it is vectorized and concise!

---

Example: Powers Matrix
======================

    !r
    > system.time(powers_vect(x,8))
       user  system elapsed 
      0.492   0.032   0.531 
      
### Boo.

Performance issues can be unpredictable!

---

Vector Assignment
=================

Consider the simple vector assignment operation:

    !r
    > x[3] <- 17
    
This operation is actually a call to an unfriendly-sounding function `"[<-"`:

    !r
    > x <- "[<-"(x, 3, 17)

This replacement function does the following:

* makes an entire copy of vector `x`
* the 3rd element is changed to 17
* new vector is assigned to `x`

So, to replace one element of the vector, *the entire vector is recomputed*!

---

Copy-on-Change
==============

When the value of one variable is assigned to another (*e.g.* `y <- x`), they initially share memory locations. If we change either `x` or `y`, then a copy is made in a different area of memory. 

    !r
    > z <- runif(10)
    > tracemem(z)
    [1] "<0x8bfff28>"
    > y <- z
    > tracemem(y)
    [1] "<0x8bfff28>"
    > z[3] <- 8
    > tracemem(z)
    [1] "<0x895e230>"

You can often detect when copying occurs:

    !r
    > z <- 1:10000000
    > system.time(z[3] <- 8)
       user  system elapsed 
      0.041   0.022   0.063 
    > system.time(z[312] <- 18)
       user  system elapsed 
          0       0       0 
          
---

Example: Avoiding Memory Copy
=============================

Consider the contrived example of replacing individual elements of a set of vectors. One alternative is to store vectors in a list as they are generated:

    !r
    > m  <- 5000
    > n <- 1000
    > z <- list()
    > for (i in 1:m) z[[i]] <- sample(1:10,n,replace=T)
    > system.time(for (i in 1:m) z[[i]][3] <- 8)
       user  system elapsed
      0.288   0.024   0.321
      
Compare this to a matrix formulation:

    > z <- matrix(sample(1:10,m*n,replace=T),nrow=m)
    > system.time(z[,3] <- 8)
       user  system elapsed
      0.008   0.044   0.052
      
One of the reasons for better performance is that in the list version the memory-copy operation occurs in each iteration of the loop, while the matrix version we encounter it only once. 

---

Example: Avoiding Memory Copy
=============================

How about using an `apply` function this time?

And, of course, the matrix version is vectorized.
But what about using lapply() on the list version?

    !r
    set3 <- function(lv) {
    + lv[3] <- 8
    + return(lv)
    +}
    > z <- list()
    > for (i in 1:m) z[[i]] <- sample(1:10,n,replace=T) 
    > system.time(lapply(z,set3))
                    user  system elapsed
                   0.100   0.012   0.112
                   
Again, no performance benefit to using `apply`.

---

Profiling
=========

Rather than guessing at what might be causing performance slowdowns, R includes *profiling* tools to help you identify bottlenecks.

The function `Rprof` generates a report that lists how much time R spends in each section of your code.             

Calling `Rprof()` starts the monitor, while `Rprof(NULL)` turns monitoring off.    

    !r
    > x <- runif(1000000)
    > Rprof()
    > invisible(powers(x, 8))
    > Rprof(NULL)
    > summaryRprof()
    
---

Profiling
=========

    !r
    $by.self
            self.time self.pct total.time total.pct
    "cbind"      0.58    96.67       0.58     96.67
    "*"          0.02     3.33       0.02      3.33

    $by.total
             total.time total.pct self.time self.pct
    "powers"       0.60    100.00      0.00     0.00
    "cbind"        0.58     96.67      0.58    96.67
    "*"            0.02      3.33      0.02     3.33

    $sample.interval
    [1] 0.02

    $sampling.time
    [1] 0.6
    


* `by.self`: Timings sorted by time spend in function alone
* `by.total`: Timings sorted by time spend in function and callees
* `sample.interval`: The sampling interval
* `sampling.time`: Total length of profiling run    
    
As we predicted, `cbind` is the major bottleneck.

Presenter Notes
===============

`invisible` suppresses output

---

Profiling
=========

No obvious bottlenecks in the preallocated version:

    !r
    > Rprof()
    > invisible(powers_fast(x,8))
    > Rprof(NULL)
    > summaryRprof()
    $by.self
                  self.time self.pct total.time total.pct
    "powers_fast"      0.30    65.22       0.46    100.00
    "matrix"           0.10    21.74       0.10     21.74
    "*"                0.06    13.04       0.06     13.04

    $by.total
                  total.time total.pct self.time self.pct
    "powers_fast"       0.46    100.00      0.30    65.22
    "matrix"            0.10     21.74      0.10    21.74
    "*"                 0.06     13.04      0.06    13.04

    $sample.interval
    [1] 0.02

    $sampling.time
    [1] 0.46

---

`Rprof`
=======

Under `Rprof`, every 0.02 seconds R "samples" the call stack to determine which function calls are in effect at that time. 

It writes the result of each inspection to a file `Rprof.out`:

    sample.interval=20000
    "cbind" "powers" 
    "cbind" "powers" 
    "cbind" "powers" 
    "cbind" "powers" 
    "cbind" "powers" 
    ...
    
`summaryRprof` summarizes this file, assuming that the recorded functions were indeed representative of the sampling interval.

If there are a lot of function calls, the summary may be harder to interpret.

---

`knit("homework3_solutions.rmd")`
===================================

    !r
    > summaryRprof()
    $by.self
                            self.time self.pct total.time total.pct
    "<Anonymous>"                0.14     8.14       1.70     98.84
    "grid.Call.graphics"         0.12     6.98       0.18     10.47
    "lazyLoadDBfetch"            0.10     5.81       0.24     13.95
    "lapply"                     0.06     3.49       0.74     43.02
    "FUN"                        0.06     3.49       0.68     39.53
    "dev.off"                    0.06     3.49       0.06      3.49
    "grid.Call"                  0.06     3.49       0.06      3.49
    "list.files"                 0.06     3.49       0.06      3.49
    "unlist"                     0.04     2.33       1.46     84.88
    "sapply"                     0.04     2.33       0.52     30.23
    "valid.unit"                 0.04     2.33       0.12      6.98
    "data.frame"                 0.04     2.33       0.08      4.65
    "pdf"                        0.04     2.33       0.06      3.49
    "*"                          0.04     2.33       0.04      2.33
    "as.list"                    0.04     2.33       0.04      2.33
    ...
    "set"                        0.02     1.16       0.02      1.16
    "setwd"                      0.02     1.16       0.02      1.16

    $by.total
                             total.time total.pct self.time self.pct
    "doTryCatch"                   1.72    100.00      0.00     0.00
    "knit"                         1.72    100.00      0.00     0.00
    "process_file"                 1.72    100.00      0.00     0.00
    "try"                          1.72    100.00      0.00     0.00
    "tryCatch"                     1.72    100.00      0.00     0.00
    "tryCatchList"                 1.72    100.00      0.00     0.00
    "tryCatchOne"                  1.72    100.00      0.00     0.00
    "<Anonymous>"                  1.70     98.84      0.14     8.14
    "block_exec"                   1.70     98.84      0.00     0.00
    "call_block"                   1.70     98.84      0.00     0.00
    "process_group.block"          1.70     98.84      0.00     0.00
    ...


---

Byte Code Compiling
===================

Starting with version 2.13, R has included a byte code compiler, which you can use to try to speed up your code. 

![Byte code](images/bytecode.png)

Recall the simple example of non-vectorized vector addition:

    !r
    > system.time(for (i in 1:length(x)) z[i] <- x[i] + y[i])
       user  system elapsed 
      3.397   0.058   3.557 
      
We can speed this up somewhat by byte compiling with the `compiler` library:

    !r
    > library(compiler)
    > f <- function() for (i in 1:length(x)) z[i] <- x[i] + y[i]
    > cf <- cmpfun(f)
    > system.time(cf())
       user  system elapsed 
      0.805   0.002   0.809 
      
---

Large Memory Requirements
=========================

The maximum size of any object in R is $2^{31}-1$, regardless of whether in 32- or 64-bit versions. This corresponds to approximately 2 billion elements in a vector.

One approach of getting around this limitation is **chunking**. This involves reading in data from a file one *chunk* at a time. 

The `read.table` function includes a `skip` argument that skips a specified number of rows before reading, and a `nrows` argument to specify the number of rows to read. For example:

    !r
    > chunk <- read.table("huge_file.csv", skip=1000000, nrows=200000, sep=",")
    
would read in 200,000 rows starting at line 1,000,001.

Statistical operations can be applied to each chunk, and the estimates from each chunk combined to produce an overall result.

---

R Packages for Memory Management
================================

There are specialized R packages for accommodating large memory requirements:

* database packages, such as `RMySQL` and `RSQLite` allow for selective querying of large datasets.
* `biglm` performs linear modeling on very large datasets, which implements chunking.
* `ff` works with data directly on disk storage, rather than loading data objects into memory.
* `bigmemory` allows users to exploit shared (among machines) memory to store large objects.

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    extensions: ["tex2jax.js"],
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
      processEscapes: true
    },
    "HTML-CSS": { availableFonts: ["TeX"] }
  });
</script>
<!--<script type="text/javascript"
    src="../MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>-->
<script type="text/javascript"
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>