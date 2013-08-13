Writing and Using Functions
===========================



---

Functions
=========

Functions provide the foundation for building large programs, allowing complex algorithms to be efficiently structured. 

Just as data structures combine related values in a single object, functions combine related commands and variables in a single object.

Functions are just computer implementations of mathematical functions: 

* they encapsulate a strict set of rules that take some **input** and use it to calculate one or more **output** values.

We have already seen a suite of built-in functions in R:

* `exp()`
* `log()`
* `ifelse()`
* `which()`
* `max()`

---

Calling Functions
=================

Functions are used by *calling* them, which involves passing zero or more arguments to the function by enclosing them in parentheses after the function name.

**Example:** the linear model (`lm`) function:

    !r
    > data(iris)
    > iris_model <- lm(Sepal.Length ~ Sepal.Width, data=iris)
    > summary(iris_model)

    Call:
    lm(formula = Sepal.Length ~ Sepal.Width, data = iris)

    Residuals:
        Min      1Q  Median      3Q     Max 
    -1.5561 -0.6333 -0.1120  0.5579  2.2226 

    Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
    (Intercept)   6.5262     0.4789   13.63   <2e-16 ***
    Sepal.Width  -0.2234     0.1551   -1.44    0.152    
    ---
    Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

 
---

Writing Functions
=================

We write functions because we often find ourselves going through the same sequence of steps in the R shell. It is more efficient to take a sequence of commands and bind it together into an integrated procedure, so that then we can think about the function as a whole, rather than the individual steps. 

It also reduces error, because by invoking the same function every time, we don’t have to worry about missing a step, or about whether code will behave consistently each time we use it.

We can write (or *declare*) functions using a function  ... called `function`:

    !r
    my_function <- function(first_argument, second_argument, ...) {
      # do some stuff
      return(return_value)
    }

---

Writing Functions
=================

An example of a very simple (and redundant) function is one which returns the absolute value of its argument(1):

    !r
    absval <- function(value) { 
        if (value<0) {
            -value 
        } else {
            value 
        }
    
By default, a function returns the last evaluation, but it is often better (clearer) to explicitly use the `return` statement:

    !r
    return(value)

Function's inputs (arguments) and outputs (return values) are called *interfaces*.

1. *Can also be written as:* 

        absval <- function(value) if (value<0) -value else value

---

Exercise
========

### Vectorize the `absval` function

Presenter Notes
===============

Hint: use vector indexing!

---

Operators are Functions
=======================

Even the simple arithmetic operators are functions, which are simply allowed to be called differently so that they can be used more naturally.

    !r
    > '+'(4,5)
    [1] 9
    
Users can write custom operators. In order that they may be used like an operator, the name must be enclosed within percentage symbols (%). For example, suppose we wanted an operator that divided the value on the left by the square root of the value on the left:

    !r
    > "%!%" = function(x,y) x/sqrt(y)
    > 6 %!% 7
    [1] 2.267787
    

---

Default Argument Values
=======================

We sometimes want to make arguments optional, or to have a default value when it is an extremely common choice. We can use *named arguments* for this:

    !r
    psi <- function(x, c=1) {
      loss <- ifelse(x^2 > c^2, c*abs(x), x^2)
      return(loss)
    }
    
The above is a loss function for robust regression. The point at which we switch from using absolute value loss and squared loss is set to 1 if it is not specified by the user.

    > identical(psi(z,c=1), psi(z)) 
    [1] TRUE

Arguments can go in any order when explicitly named:

    > identical(psi(x=z,c=2), psi(c=2,x=z)) 
    [1] TRUE

---

Example: Pareto Quantiles
=========================

Let's code a real (non-trivial) function in R. The **Pareto distribution** is a continuous random variable that is often used to describe the "80/20" rule.

$$f(x|a,c) = ca^cx^{-(c+1)}$$
$$x \ge a$$
$$a,c > 0$$

The cumulative distribution function (CDF) is:

$$F(x|a,c) = 1 - \left(\frac{x}{a}\right)^{-c}$$

and so the quantile function is:

$$Q(p|a,c) = a(1-p)^{-1/c}$$

---

Example: Pareto Quantiles
=========================

So, to find the median of the Pareto distribution with $a=10$ and $c=4.5$, we can calculate:

    !r
    > 10*(1 - 0.5)^(-1/4.5)
    [1] 11.66529
    
For the 90th percentile:

    !r
    > 10*(1 - 0.9)^(-1/4.5)
    [1] 16.68101
    
If we want to change the scale parameter to 6 and the location parameter to 25:

    !r
    > 25*(1 - 0.9)^(-1/6)
    [1] 36.69498

However, re-submitting a slightly different calculation every time is tedious and prone to error. A better approach is to generalize the calculation in a re-usable function.

---

Example: Pareto Quantiles
=========================

One possible implementation of the Pareto quantile function:

    !r
    qpareto <- function(p, scale, loc) {
        q <- loc*(1 - p)^(-1/scale)
        return(q)
    }

Here, we have declared a function using `function` and assigned it to a variable, `qpareto`. We can now call the function with any combination of parameters, as required:

    !r  
    > qpareto(0.5, scale=4.5, location=10)
    [1] 11.66529
    > qpareto(0.9, scale=4.5, location=10)
    [1] 16.68101
    > qpareto(0.9, scale=6, location=25)
    [1] 36.69498

However, our function leaves room for improvement:

    !r
    > qpareto(0.9, 6, -1)
    [1] -1.467799
    
---

Error Checking
==============

To make this function more robust, we can add some simple error checking statements that prevent illegal parameters from generating invalid results:

    !r
    qpareto <- function(p, scale, loc) {
        if ((scale<=0)|(loc<=0)) {
            stop("'qpareto' parameters must be greater than zero.")
        }
        q <- loc*(1 - p)^(-1/scale)
        return(q)
    }
    
Now, entering negative parameters raises an exception that must be dealt with, rather than an invalid result that could silently corrupt subsequent results.

    !r
    > qpareto(0.4, 5, -1)
    Error in qpareto(0.4, 5, -1) : 
      'qpareto' parameters must be greater than zero.

We could improve this further by checking to ensure that `p` is a valid probability.

---

Error Checking
==============

To avoid a long series of conditional statements, we can use a convenience function, `stopifnot`:

    !r
    qpareto <- function(p, scale, loc) {
        stopifnot(p>=0, p<=1, scale>0, loc>0)
        q <- loc*(1 - p)^(-1/scale)
        return(q)
    }

`stopifnot` halts the execution of the function, with an error message, if all of its arguments do not evaluate to TRUE. If all those conditions are met, however, R just goes on to the next command.

    !r
    > qpareto(-0.1, 4, 5)
    Error: p >= 0 is not TRUE
    > qpareto(0.5, 0, 12)
    Error: scale > 0 is not TRUE
    
Presenter Notes
===============

If the arguments violate two conditions, only the first one is cited.

---

Function Scope
==============

Variables defined inside a function, or in its arguments, are only available inside the function. 

    !r
    > (x <- 7)
    [1] 7
    > square <- function(y) { x <- y^2; return(x) } 
    > square(7)
    [1] 49 
    > x 
    [1] 7
    > y
    Error: object 'y' not found

The assignment of 7 to `y` and of 49 to `x` only applies within the *scope* of the function. In other words, `y` is *local* to `square`, but `x` is *global*.

On the other hand, functions can see variables described in its environment:

    !r
    > z <- 10
    > adder <- function(x) { return(x+z) }
    > adder(5)
    [1] 15

Presenter Notes
===============

Relying on variables outside the function is bad practice

---

Environments and Scoping
========================

In the previous slide, both the variable `x` and the function `square` were created in the top-level environment, `.GlobalEnv`.

    !r
    > ls()
    [1] "square" "x"     
    > ls.str()
    square : function (y)  
    x :  num 7
    > environment(square)
    <environment: R_GlobalEnv>

Here's another example with a function `h` that is created inside of another function `f`. Its environment is referred to by its memory location:

    !r
    > w <- 12
    > f <- function(y) {
       d <- 8
       h <- function() return(d*(w+y))
       print(environment(h))
       return(h())
    }
    > f(2)
    <environment: 0x875753c>
    [1] 112

---

Respect Interfaces
==================

Interfaces allow us to completely control what is calculated inside a function. 

Best practices:

* explicitly pass all external information required by a function via its arguments
* only allow a function to modify its environment through its return value

There are a few exceptions to these rules, such as universal constants and plotting behavior.

---

Side Effects
============

When functions change non-local variables, this is known as a *side-effect*.

In general, side effects are considered poor practice because it is easy to produce unexpected results. 

R makes it difficult to generate side effects because it makes local copies of all global variables when they are used inside a function.

    !r
    > v <- 1:10
    > u <- function() {v[3] <- 0}
    > u()
    > v
     [1]  1  2  3  4  5  6  7  8  9 10
     
      

---

Example: Fixed-point Iteration
==============================

Here is the algorithm for fixed-point iteration:

    !r
    # Initialize value
    x <- 10
    x_old <- x + 1e6
    # Set tolerance
    tol <- 1e-9
    # Specify maximum number of iterations
    max_iter <- 100
    # Keep track of number of interations
    iter <- 0
    # Loop
    while((abs(x-x_old) > tol) && (iter<max_iter)) {
        # Replace old value with current
        x_old <- x
        # Calculate new value
        x <- exp(exp(-x))
        # Increment counter
        iter <- iter + 1
    }

   
---

Encapsulate in a Function
=========================

To avoid cutting-and-pasting every time we want to re-run the code, we can make a function:


    !r
    fixedpoint <- function(x) {
        x_old <- x + 1e6
        # Set tolerance
        tol <- 1e-9
        # Specify maximum number of iterations
        max_iter <- 100
        # Keep track of number of interations
        iter <- 0
        # Loop
        while((abs(x-x_old) > tol) && (iter<max_iter)) {
            # Replace old value with current
            x_old <- x
            # Calculate new value
            x <- exp(exp(-x))
            # Increment counter
            iter <- iter + 1
        }
        return(x)
    }
    
*That was easy!*

---

Default Arguments
=================

We may want to specify alternate tolerance or stopping time, so we can make these arguments with reasonable defaults:


    !r
    fixedpoint <- function(x, tol=1e-9, max_iter=100) {
        x_old <- x + 1e6
        # Keep track of number of interations
        iter <- 0
        # Loop
        while((abs(x-x_old) > tol) && (iter<max_iter)) {
            # Replace old value with current
            x_old <- x
            # Calculate new value
            x <- exp(exp(-x))
            # Increment counter
            iter <- iter + 1
        }
        return(x)
    }

*Are we finished?*


---

Generalization
==============

We may wish to find the root of a different function, so lets allow it to be passed as an argument:

    !r
    f <- function(x) exp(exp(-x))
    
    fixedpoint <- function(fun, x=1, tol=1e-9, max_iter=100) {
        x_old <- x + 1e6
        # Keep track of number of interations
        iter <- 0
        # Loop
        while((abs(x-x_old) > tol) && (iter<max_iter)) {
            # Replace old value with current
            x_old <- x
            # Calculate new value
            x <- fun(x)
            # Increment counter
            iter <- iter + 1
        }
        return(x)
    }
    
    > f2 <- function(x) x - log(x) + exp(-x)
    > fixedpoint(f2)
    [1] 1.3098

*One more thing ...*
    

---

Error-checking
==============

We should ensure that the algorithm actually converged:

    !r
    fixedpoint <- function(fun, x=0, tol=1e-9, max_iter=100) {
        x_old <- x + 1e6
        # Keep track of number of interations
        iter <- 0
        # Loop
        while((abs(x-x_old) > tol) && (iter<max_iter)) {
            # Replace old value with current
            x_old <- x
            # Calculate new value
            x <- fun(x)
            # Increment counter
            iter <- iter + 1
        }
        
        # Check convergence
        if (abs(x-x_old) > tol) {
          cat("Algorithm failed to converge\n")
          return(NULL)
        } else {
          cat("Algorithm converged\n")
          return(x)
        }
        
    }
    


---

Exercise
========

### Implement the Newton-Raphson algorithm as a **function**

<!-- Scripts -->
<script type="text/javascript"
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/javascript">MathJax.Hub.Config({tex2jax: {processEscapes: true,
    processEnvironments: false, inlineMath: [ ['$','$'] ],
    displayMath: [ ['$$','$$'] ] },
    asciimath2jax: {delimiters: [ ['$','$'] ] },
    "HTML-CSS": {minScaleAdjust: 125 } });
</script>