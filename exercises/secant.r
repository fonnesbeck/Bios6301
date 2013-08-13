f_test <- function(x) cos(x) - x

secant <- function(fun, x0, x1, tol=1e-9, max_iter=100) {
    # Keep track of number of interations
    iter <- 0
    # Evaluate function at initial points
    f1 <- fun(x1)
    f0 <- fun(x0)
    # Loop
    while((abs(x1-x0) > tol) && (iter<max_iter)) {
        # Calculate new value
        x_new <- x1 -  f1*(x1 - x0)/(f1 - f0)
        # Replace old value with current
        x0 <- x1
        x1 <- x_new
        f0 <- f1
        f1 <- fun(x1)
        # Increment counter
        iter <- iter + 1
    }

    if (abs(x1-x0) > tol) {
        cat("Algorithm failed to converge\n")
        return(NA)
    } 
    else {
        cat("Algorithm converged in", iter, "iterations\n")
        return(x1)
    }
}

secant(f_test, 2, 3)