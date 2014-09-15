
## ------------------------------------------------------------------------
data(iris)
iris_model <- lm(Sepal.Length ~ Sepal.Width, data=iris)
summary(iris_model)


## ------------------------------------------------------------------------
my_function <- function(first_argument, second_argument, ...) {
  # do some stuff
  return(return_value)
}


## ------------------------------------------------------------------------
absval <- function(value) {
    if (value<0) {
        -value
    } else {
        value
    }
}


## ------------------------------------------------------------------------
absval <- function(value) if (value<0) -value else value


## ------------------------------------------------------------------------
'+'(4,5)


## ------------------------------------------------------------------------
"%!%" = function(x,y) x/sqrt(y)
6 %!% 7


## ------------------------------------------------------------------------
psi <- function(x, c=1) {
  loss <- ifelse(x^2 > c^2, c*abs(x), x^2)
  return(loss)
}
z <- 0.5
psi(z)


## ------------------------------------------------------------------------
identical(psi(z,c=1), psi(z))


## ------------------------------------------------------------------------
identical(psi(x=z,c=2), psi(c=2,x=z))


## ------------------------------------------------------------------------
10*(1 - 0.5)^(-1/4.5)


## ------------------------------------------------------------------------
10*(1 - 0.9)^(-1/4.5)


## ------------------------------------------------------------------------
25*(1 - 0.9)^(-1/6)


## ------------------------------------------------------------------------
qpareto <- function(p, scale, location) {
    q <- location * (1 - p)^(-1/scale)
    return(q)
}


## ------------------------------------------------------------------------
qpareto(0.5, scale=4.5, location=10)
qpareto(0.9, scale=4.5, location=10)
qpareto(0.9, scale=6, location=25)


## ------------------------------------------------------------------------
qpareto(0.9, 6, -1)


## ------------------------------------------------------------------------
  qpareto <- function(p, scale, loc) {
    if ((scale<=0) | (loc<=0)) {
        stop("'qpareto' parameters must be greater than zero.")
    }
    q <- loc*(1 - p)^(-1/scale)
    return(q)
}


## ------------------------------------------------------------------------
tryCatch(qpareto(0.4, 5, -1), error=function(e) e)


## ------------------------------------------------------------------------
qpareto <- function(p, scale, loc) {
    stopifnot(p>=0, p<=1, scale>0, loc>0)
    q <- loc*(1 - p)^(-1/scale)
    return(q)
}


## ------------------------------------------------------------------------
tryCatch(qpareto(-0.1, 4, 5), error=function(e) e)
tryCatch(qpareto(0.5, 0, 12), error=function(e) e)


## ------------------------------------------------------------------------
(x <- 7)
square <- function(y) { x <- y^2; return(x) }
square(7)
x
tryCatch(y, error = function(e) e)


## ------------------------------------------------------------------------
z <- 10
adder <- function(x) { return(x+z) }
adder(5)


## ----, echo=FALSE--------------------------------------------------------
# remove all variables except x and square (and metadata)
rm(list=setdiff(ls(), c('x','square','metadata')))


## ------------------------------------------------------------------------
ls()
ls.str()
environment(square)


## ------------------------------------------------------------------------
w <- 12
f <- function(y) {
   d <- 8
   h <- function() return(d*(w+y))
   print(environment(h))
   return(h())
}
f(2)


## ------------------------------------------------------------------------
v <- 1:10
u <- function() { v[3] <- 0 }
u()
v


## ------------------------------------------------------------------------
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
while((abs(x-x_old) > tol) && (iter < max_iter)) {
    # Replace old value with current
    x_old <- x
    # Calculate new value
    x <- exp(exp(-x))
    # Increment counter
    iter <- iter + 1
}
x


## ------------------------------------------------------------------------
fixedpoint <- function(x) {
    x_old <- x + 1e6
    # Set tolerance
    tol <- 1e-9
    # Specify maximum number of iterations
    max_iter <- 100
    # Keep track of number of interations
    iter <- 0
    # Loop
    while((abs(x-x_old) > tol) && (iter < max_iter)) {
        # Replace old value with current
        x_old <- x
        # Calculate new value
        x <- exp(exp(-x))
        # Increment counter
        iter <- iter + 1
    }
    return(x)
}
fixedpoint(10)


## ------------------------------------------------------------------------
fixedpoint <- function(x, tol=1e-9, max_iter=100) {
    x_old <- x + 1e6
    # Keep track of number of interations
    iter <- 0
    # Loop
    while((abs(x-x_old) > tol) && (iter < max_iter)) {
        # Replace old value with current
        x_old <- x
        # Calculate new value
        x <- exp(exp(-x))
        # Increment counter
        iter <- iter + 1
    }
    return(x)
}


## ------------------------------------------------------------------------
fixedpoint <- function(fun, x=1, tol=1e-9, max_iter=100) {
    x_old <- x + 1e6
    # Keep track of number of interations
    iter <- 0
    # Loop
    while((abs(x-x_old) > tol) && (iter < max_iter)) {
        # Replace old value with current
        x_old <- x
        # Calculate new value
        x <- fun(x)
        # Increment counter
        iter <- iter + 1
    }
    return(x)
}

f <- function(x) exp(exp(-x))
f2 <- function(x) x - log(x) + exp(-x)
fixedpoint(f)
fixedpoint(f2)


## ------------------------------------------------------------------------
fixedpoint <- function(fun, x=0, tol=1e-9, max_iter=100) {
    x_old <- x + 1e6
    # Keep track of number of interations
    iter <- 0
    # Loop
    while((abs(x-x_old) > tol) && (iter < max_iter)) {
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

fixedpoint(f)
fixedpoint(f, max_iter=3)


## ------------------------------------------------------------------------
myhist <- function(x, ...) {
  extArgs <- list(...)
  print(names(extArgs))
  title <- deparse(match.call())
  x <- hist(x, plot=FALSE)
  plot(NULL, xlim=range(x$breaks), ylim=range(x$counts), xlab='', ylab='', type='n', axes=FALSE, frame.plot=TRUE, main=title, ...)
  axis(1, at=x$breaks, labels=x$breaks)
  for(i in seq(length(x$counts))) {
    segments(x$mids[i], 0, x$mids[i], x$counts[i])
    text(x$mids[i], x$counts[i], x$counts[i], pos=4)
  }
}
myhist(islands, sub="Areas of major landmasses")

center <- function(x, type=c('mean','median')) {
  type <- match.arg(type)
  do.call(type, list(x))
}
set.seed(35)
x <- rnorm(10000)
center(x)
center(x, 'median')
center(x, 'med')
tryCatch(center(x, 'midpoint'), error=function(e) e)


