# The sorting algorithms described in Jones et al. (2009), Chapter 9, Question 7

selection <- function(x) {
    
    u <- x
    s <- NULL
    
    while (length(u) > 0) {
        s <- c(s, u[which(u==min(u))])
        u <- u[-which(u==min(u))]
    }
    
    s
    
}

insertion <- function(x) {
    
    s <- x[length(x)]
    u <- x[-length(x)]
    
    while (length(u) > 0) {
        xi <- u[length(u)]
        i <- 0
        while ((xi > s[i+1]) & (i < length(s))) {
            i <- i + 1
        }
        if (i==0) {
            s <- c(xi, s)
        } else if (i==length(s)) {
            s <- c(s, xi)
        } else {
            s <- c(s[1:i], xi, s[(i+1):length(s)])
        }
        u <- u[-length(u)]
    }
    
    s
    
}

bubble <- function(x) {

    u <- x
    swapped <- TRUE
    browser()
    while (swapped == TRUE) {
    
        swapped <- FALSE
        for (i in 1:(length(u)-1)) {
            l <- u[i]
            r <- u[i+1]
            if (l > r) {
                u[i] <- r
                u[i+1] <- l
                swapped <- TRUE
            }
        }
    
    }
    u

}

quick <- function(x) { 

    if (length(x) <= 1) return(x)
      
    less <- NULL
    greater <- NULL
    
    pivot_index <- as.integer(length(x)/2)
    
    pivot <- x[pivot_index]
    u <- x[-pivot_index]
    
    for (xi in u) {
        if (xi <= pivot) {
            less <- c(less, xi)
        } else {
            greater <- c(greater, xi)
        }
    }
      
    return(c(quick(less), pivot, quick(greater)))
}