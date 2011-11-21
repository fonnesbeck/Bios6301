# input
x.values <- seq(-2, 2, by = 0.1)
   
# for each x calculate y
n <- length(x.values)
y.values <- rep(0, n)

for (i in 1:n) {
	x <- x.values[i]
	if (x<=0) {
	    y.values[i] <- -x^3
	} else if (x<=1){
	    y.values[i] <- x^2
	} else {
	    y.values[i] <- sqrt(x)
	}
}

# output
# plot(x.values, y.values, type = "l")

h <- function(x, n) {
    
    value <- 1
    
    for (i in 1:n) {
        value <- value + x^i
    }
    
    value
}

hwhile <- function(x, n) {
    
    value <- 1
    i <- 1
    while (i<=n) {
        value <- value + x^i
        i <- i+1
    }
    
    value
}

sortsorted <- function(x, y) {
    # Initialize vector
    xy <- NULL
    # Copy y
    y_remaining <- y
    # Loop over x
    for (xval in x) {
        # Which values of y are smaller
        y_smaller <- xval > y_remaining
        # Add smaller y (if any), then current x
        xy <- c(xy, y_remaining[y_smaller], xval)  
        # Remove small values from remaining y
        y_remaining <- y_remaining[!y_smaller]
    }
    xy
}

growth <- function(x, r, n) {
 
    series <- numeric(n)
    series[1] <- x
    for (i in 2:n) {
        series[i] <- r * series[i-1] * (1-series[i-1])
    }
    
    plot(1:n, series, type='b')
    
}

n_choose_r <- function(n, r) {
    if (n==r | r==0) return(1)
    n_choose_r(n-1, r-1) + n_choose_r(n-1, r)
}