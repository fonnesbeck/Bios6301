Data Types and Structures in R
==============================

---

Data Types
==========

R has several elemental data types.

* numeric
* integer
* complex
* logical
* character

---

Numeric
=======

Floating-point numbers are represented by the `numeric` type in R. It is the default computational data type.

    !r
    > x <- 10.5      # assign a decimal value 
    > x              
    [1] 10.5 
    > class(x)       # print the class name of x 
    [1] "numeric"
    
Even if we assign an integer to a variable, it gets saved as a `numeric` type:

    !r
    > k <- 1 
    > k              
    [1] 1 
    > class(k)       # print the class name of k 
    [1] "numeric"
    
We can query this directly:

    !r
    > is.integer(k)  # is k an integer? 
    [1] FALSE
    
---

Integer
=======

Integers can be created only by *casting* a numeric value, using the `as.integer()` function:

    !r
    > y <- as.integer(3) 
    > y              
    [1] 3 
    > class(y)       
    [1] "integer" 
    > is.integer(y)  
    [1] TRUE

We can cast other types to integers this way:

    !r
    > as.integer(42.1343)
    [1] 42
    > as.integer("6.778")
    [1] 6
    > as.integer(TRUE)
    [1] 1
    
---

Complex
=======

A complex value in R is defined via the pure imaginary value i.

    !r
    > z <- 1 + 2i      
    > z              
    [1] 1+2i 
    > class(z)       
    [1] "complex"
    
The following gives an error as −1 is not a complex value.

    !r
    > sqrt(−1)      
    [1] NaN 
    Warning message: 
    In sqrt(−1) : NaNs produced

Instead, we have to use the complex value −1 + 0i.

    !r
    > sqrt(−1+0i)  
    [1] 0+1i
    > sqrt(as.complex(−1)) 
    [1] 0+1i

---

Logical
=======

A logical value is often created via comparison between variables.

    > x <- 1; y <- 2   
    > z <- x > y      
    > z              
    [1] FALSE 
    > class(z)       
    [1] "logical"
    
Standard logical operations are "&" (and), "|" (or), and "!" (negation).

    > u <- TRUE; v <- FALSE 
    > u & v          # u AND v 
    [1] FALSE 
    > u | v          # u OR v 
    [1] TRUE 
    > !u             # negation of u 
    [1] FALSE

---

Character
=========

A character object is used to represent string values in R. We convert objects into character values with the as.character() function:

    > (x = as.character(3.14))
    [1] "3.14" 
    > class(x)       
    [1] "character"
    
Two character values can be concatenated with the paste function.

    > fname = "Joe"; lname ="Smith" 
    > paste(fname, lname) 
    [1] "Joe Smith" 
    
---



Vectors
=======

The *fundamental* data structure in R.

A vector is a data structure composed of multiple elements, all of the same *mode*.

    !r
    > x <- c(88,5,12,13)
    > x
    [1] 88 5 12168 13
    > mode(x)
    [1] "numeric"

The function `c` combines the elements specified into a vector.

    !r
    > x[3] <- 'a'
    [1] "88" "5"  "a"  "13"
    > mode(x)
    [1] "character"

Presenter Notes
===============

The size of the vector is allocated to memory when it is created.

---

Indexing
========

The elements of a vector can be accessed via *indexing*, using square brackets.

    !r
    > x[2]
    [1] 5
    > x[1:3]
    [1] 88  5 12
    > x[c(4,1)]
    [1] 13 88
    > x[-2]
    [1] 88 12 13
    > x[x>10]
    [1] 88 12 13
    > big <- which(x>10)
    > x[big]
    [1] 88 12 13

Scalars are just one-element vectors:

    !r
    > y <- 10
    > y[1]
    [1] 10
    > y[2]
    [1] NA

Presenter Notes
===============

which() takes a Boolean vector and gives a vector of indices for the TRUE values; useful with tests

---

Vector Arithmetic
=================

Operators apply to vectors “pairwise”:

    !r
    > y <- c(-7, -8, -10, -45)
    > x+y
    [1]  81  -3   2 -32

**Recycling**: elements in shorter vector are repeated when combined with a longer vector

    !r
    > x + c(-7,-8)
    [1] 81 -3  5  5


Presenter Notes
===============


---

Vector Comparisons
==================

Can also do pairwise comparisons, which returns a boolean vector:

    !r
    > x > 9
    [1]  TRUE FALSE  TRUE  TRUE

Boolean operators work pairwise; but written double, combines individual values into a single Boolean:

    !r
    > (x > 9) & (x < 20)
    [1] FALSE FALSE  TRUE  TRUE
    > (x > 9) && (x < 20)
    [1] FALSE

To compare whole vectors, best to use `identical()` or `all.equal()`:

    !r
    > x == y
    [1] FALSE FALSE FALSE FALSE
    > identical(c(0.5-0.3,0.3-0.1),c(0.3-0.1,0.5-0.3))
    [1] FALSE
    > all.equal(c(0.5-0.3,0.3-0.1),c(0.3-0.1,0.5-0.3))
    [1] TRUE

Presenter Notes
===============


---

Special Values
==============

In addition to the standard data types and data structures, there are four "special" values that you will encounter in R.

* NA
* Inf
* NaN
* NULL

---

NA
==

`NA` is used to represent missing values (*i.e.* not available). For example, if you expand the length of a vector beyond the indices where values were defined, `NA` values are inserted:

    > v <- c(1,2,3) 
    > v
    [1] 1 2 3
    > length(v) <- 4 
    > v
    [1] 1 2 3 NA


---

Inf
===

`Inf` represents infinity. It is most commonly encountered when a computation results in a number that is too big:

     > 2^1024
     [1] Inf
     > -2^1024
     [1] -Inf

This is also the value returned when you divide by 0:

    > 1/ 0 
    [1] Inf

---

NaN
===

`NaN` stands for "not a number", and it is returned when a computation is nonsensical:

    > Inf - Inf 
    [1] NaN 
    > 0/0
    [1] NaN


---

NULL
====

The `NULL` value indicates that there is no value assigned to a particular object. Note the difference between this and the notion of a missing value or a nonsensical value.



---

Vectorized Functions
====================

Lots of functions take vectors as arguments:

- `mean()`, `median()`, `sd()`, `var()`, `max()`, `min()`, `length()`, `sum()` yield single numbers
- `sort()` returns a new vector
- `hist()` takes a vector of numbers and produces a histogram and plots it
- `summary()` gives a five-number summary of numerical vectors 
- `any()` and `all()` are useful on Boolean vectors

For example:

    !r
    > mean(x)
    [1] 29.5
    > sort(x)
    [1]  5 12 13 88
    > summary(x)
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
       5.00   10.25   12.50   29.50   31.75   88.00 
    > any(x > 10)
    [1] TRUE

Presenter Notes
===============

Making a plot is a "side-effect"

---

Named Elements
==============

You can give names to elements or components of vectors
    
    !r
    > names(x) <- c("v1","v2","v3","foo")
    > names(x)
    [1] "v1"   "v2"   "v3"   "foo"
    > x[c("foo","v1")]
    foo  v1 
     13  88

Labels are not actually part of the value
`names(x)` is just another vector (of characters):

    > names(y) <- names(x)
    > sort(names(x))
    [1] "foo" "v1"   "v2"   "v3"
    > which(names(x)=="foo")
    [1] 4

Presenter Notes
===============


---

Arrays
======

Arrays add additional structure to vectors.

    !r
    > x_arr <- array(x,dim=c(2,2))
    > x_arr
         [,1] [,2]
    [1,]   88   12
    [2,]    5   13

Notice the array is filled column-wise. Arrays have several properties:

    !r
    > dim(x_arr)
    [1] 2 2
    > is.vector(x_arr)
    [1] FALSE
    > is.array(x_arr)
    [1] TRUE
    > typeof(x_arr)
    [1] "double"
    > str(x_arr)
    num [1:2, 1:2] 88 5 12 13
    > attributes(x_arr)
    $dim
    [1] 2 2

Presenter Notes
===============

- arrays can be n-dimensional.
- typeof() returns the type of the elements
- str() gives the structure: here, a numeric array

---

Array Indexing
==============

Can access a 2-D array either by pairs of indices or by the underlying vector:
    
    !r
    > x_arr[1,2]
    [1] 12
    > x_arr[3]
    [1] 12

Omitting an index means “all of it”:

    !r
    > x_arr[c(1:2),2]
    [1] 12 13
    > x_arr[,2]
    [1] 12 13

Presenter Notes
===============

---

Operating on Arrays
===================

Some functions do not respect array structure, and operate on the underlying vector instead:
    
    !r
    > which(x_arr > 9)
    [1] 1 3 4

Other functions preserve array structure:

    !r
    > y_arr <- array(y,dim=c(2,2))
    > y_arr + x_arr
         [,1] [,2]
    [1,]   81    2
    [2,]   -3  -32

Others specifically act on each row or column of the array separately:
    
    !r
    > rowSums(x_arr)
    [1] 100 18

Presenter Notes
===============

---

Matrices
========

In R, a matrix is a specialization of a 2D array, with attributes for the numbers of columns and rows.

    !r
    > dataset <- matrix(c(1,40,1,60),nrow=2)
    > dataset
         [,1] [,2]
    [1,]    1    1
    [2,]   40   60
    > is.array(dataset)
    [1] TRUE
    > is.matrix(dataset)
    [1] TRUE
    > (dataset2 <- matrix(c(1,40,1,60),nrow=2,byrow=T))
         [,1] [,2]
    [1,]    1   40
    [2,]    1   60

Matrices can be compared using functions like `identical` and `all.equal`:

    !r
    > identical(dataset, dataset2)
    [1] FALSE
    > all.equal(dataset, dataset2)
    [1] "Mean relative difference: 1.902439"

Presenter Notes
===============

Alternately, could specify `ncol`.
Element-wise operations with the usual arithmetic and comparison operators.

---

Matrix Multiplication
=====================

Matrix multiplication has a special operator:

    !r
    > (diag_3 <- diag(2)*3)
         [,1] [,2]
    [1,]    3    0
    [2,]    0    3
    > dataset2 %*% diag_3
         [,1] [,2]
    [1,]    3  120
    [2,]    3  180

Multiplying by a vector:

    !r
    > y <- c(10,20)
    > dataset2 %*% y
         [,1]
    [1,]  810
    [2,] 1210
    > y %*% dataset2
         [,1] [,2]
    [1,]   30 1600

Presenter Notes
===============

R silently casts the vector as a row or column matrix.

---

Matrix Operations
=================

Matrix transpose:

    !r
    > t(dataset2)
         [,1] [,2]
    [1,]    1    1
    [2,]   40   60

Matrix determinant:

    !r
    > det(dataset2)
    [1] 20

Extracting or replacing the diagonal:

    !r
    > diag(dataset2)
    [1]  1 60
    > diag(dataset2) <- c(4,12)
    > dataset2
         [,1] [,2]
    [1,]    4   40
    [2,]    1   12

Presenter Notes
===============


---

Matrix Operations
=================

Creating a diagonal matrix or an identity matrix:
    
    !r
    > diag(c(3,4))
         [,1] [,2]
    [1,]    3    0
    [2,]    0    4
    > diag(2)
         [,1] [,2]
    [1,]    1    0
    [2,]    0    1

Inverting a matrix:

    !r
    > solve(dataset)
         [,1]  [,2]
    [1,]    3 -0.05
    [2,]   -2  0.05
    > solve(dataset) %*% dataset # Just to check!
         [,1] [,2]
    [1,]    1    0
    [2,]    0    1

Presenter Notes
===============


---

`solve()`
=========

Solving the linear system \\(\mathbf{A}\mathbf{x} = \mathbf{b}\\) for unknown \\(\mathbf{x}\\):

    !r
    > solve(dataset, y)
    [1]  29 -19
    > dataset %*% solve(dataset,y)
         [,1]
    [1,]   10
    [2,]   20

Presenter Notes
===============


---

Naming Rows and Columns
=======================

We can name either rows or columns or both, with rownames() and colnames():

    !r
    > rownames(dataset2) <- c("subject1", "subject2")
    > colnames(dataset2) <- c("intercept", "dose")
    > dataset2
             intercept dose
    subject1         1   40
    subject2         1   60

Presenter Notes
===============

These are just character vectors, and we use the same function to get and to set their values
Names help us understand what we’re working with

---

Lists
=====

Lists allow for the storage of a sequence of values, not necessarily of the same type:

    > my_distribution <- list("exponential",7,FALSE)
    > my_distribution
    [[1]]
    [1] "exponential"

    [[2]] 
    [1] 7

    [[3]]
    [1] FALSE

Most of things which you can do with vectors you can also do with lists!

---

Indexing Lists
==============

Use single square brackets (`[]`) to index a sub-list and double square brackets (`[[]]`) to access the list element.

    !r
    > class(my_distribution)
    [1] "list"
    > class(my_distribution[1])
    [1] "list"
    > class(my_distribution[[1]])
    [1] "character"

What happens when you index a vector with double brackets?

Presenter Notes
===============


---

List Manipulation
=================

Add to lists with c() (also works with vectors):
    
    !r
    > my_distribution <- c(my_distribution,7)
    > my_distribution
    [[1]]
    [1] "exponential"
    [[2]]
    [1] 7
    [[3]]
    [1] FALSE
    [[4]]
    [1] 7

Chop off the end of a list by setting length to something smaller:

    !r
    > length(my_distribution)
    [1] 4
    > length(my_distribution) <- 3
    > my_distribution
    [[1]]
    [1] "exponential"
    [[2]]
    [1] 7
    [[3]]
    [1] FALSE

Presenter Notes
===============


---

Named List Elements
===================

Lists are most effective when the list items are named:

    !r
    > another_distribution <- list(family="gaussian",mean=7,sd=1,is.symmetric=TRUE)
    > another_distribution
    $family
    [1] "gaussian"

    $mean
    [1] 7

    $sd
    [1] 1

    $is.symmetric
    [1] TRUE

This allows access by name:

    !r
    > another_distribution$family
    [1] "gaussian"
    > another_distribution["family"]
    $family
    [1] "gaussian"

Presenter Notes
===============

Lists give us a way to store and look data up by name rather than number (key-value pairs, dictionary, associative array, hash)

---

Named List Elements
===================

Similarly, list elements can be added by name:

    !r
    > another_distribution$was_estimated <- FALSE
    > another_distribution
    $family
    [1] "gaussian"
    $mean
    [1] 7
    $sd
    [1] 1
    $is.symmetric
    [1] TRUE
    $was_estimated
    [1] FALSE

Remove an entry in the list by assigning it the value NULL.
    
    !r
    > another_distribution$was.estimated <- NULL

Presenter Notes
===============


---

Data Frames
===========

The `data.frame` is an analog of a spreadsheet data table, with `n` rows, representing observations or cases, and `p` columns, representing variables.

`data.frame` generalizes both the `matrix` and `list`

- columns are named
- columns can be of different types
- many matrix functions work: `rowSums()`, `summary()`
- no matrix operations (*e.g.* multiply, transpose)

The "default" data strucuture for statistical operations in R.

---

Data Frames
===========

    !r
    > (data_matrix <- matrix(c(55.5,69.5,1,41,81.5,1,53.5,86,1), ncol=3, byrow=T)
    <55.5,69.5,1,41,81.5,1,53.5,86,1), ncol=3, byrow=T))
         [,1] [,2] [,3]
    [1,] 55.5 69.5    1
    [2,] 41.0 81.5    1
    [3,] 53.5 86.0    1
    > colnames(data_matrix) <- c("test1","test2","disease")
    > data_matrix
         test1 test2 disease
    [1,]  55.5  69.5       1
    [2,]  41.0  81.5       1
    [3,]  53.5  86.0       1
    > data_matrix$test2
    Error in data_matrix$test2 : $ operator is invalid for atomic vectors
    > df <- data.frame(data_matrix)
    > df$disease <- as.logical(df$disease)
    > df
      test1 test2 disease
    1  55.5  69.5    TRUE
    2  41.0  81.5    TRUE
    3  53.5  86.0    TRUE
    > df['test2']
      test2
    1  69.5
    2  81.5
    3  86.0
    > df[2,]
      test1 test2 disease
    2    41  81.5    TRUE

Presenter Notes
===============


---

Manipulating Data Frames
========================

We can add rows or columns to an array or data-frame with `rbind()` and `cbind()`.

    !r
    > rbind(df, list(test1=55.1, test2=80.4, disease=FALSE))
      test1 test2 disease
    1  55.5  69.5    TRUE
    2  41.0  81.5    TRUE
    3  53.5  86.0    TRUE
    4  55.1  80.4   FALSE
    > rbind(df, c(55.1, 80.4, 2))
      test1 test2 disease
    1  55.5  69.5       1
    2  41.0  81.5       1
    3  53.5  86.0       1
    4  55.1  80.4       2
    > cbind(df, list(sex=c('M','F','F')))
      test1 test2 disease sex
    1  55.5  69.5    TRUE   M
    2  41.0  81.5    TRUE   F
    3  53.5  86.0    TRUE   F

Presenter Notes
===============

be careful about forced type conversions

---

Structures of Structures
========================

Arbitrarily-complex data structures can be constructed from basic ones.

- lists of lists
- lists of vectors
- lists of lists of lists of vectors

Recursion allows us to build them.

---

Example: eigenstructure
=======================

`eigen()` calculates eigenvalues and eigenvectors of a matrix, and places them in a list:

    !r
    > eigen(dataset2)
    $values
    [1] 60.6703497  0.3296503

    $vectors
               [,1]        [,2]
    [1,] -0.5568163 -0.99985960
    [2,] -0.8306356  0.01675639

    > class(eigen(dataset2))
    [1] "list"
    > str(eigen(dataset2))
    List of 2
     $ values : num [1:2] 60.67 0.33
     $ vectors: num [1:2, 1:2] -0.5568 -0.8306 -0.9999 0.0168
    > dataset2 %*% eigen(dataset2)$vectors[,2]
                 [,1]
    [1,] -0.329604035
    [2,]  0.005523749
    > eigen(dataset2)[[1]][[2]]
    [1] 0.3296503

Presenter Notes
===============


<!-- Mathjax -->
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      processEscapes: true
    }
  });
</script>
<script type="text/javascript"
    src="../MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>