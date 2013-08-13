f_test <- function(x) cos(x) - x

secant <- function(fun, x0, x1, tol=1e-9, max_iter=100) {
    # Keep track of number of interations
    iter <- 0
    # Evaluate function at initial points
    f1 <- fun(x1)
    f0 <- fun(x0)
    cat("f1:", f1, "f0:", f0, "\n")
    # Loop
    while((abs(x1-x0) > tol) && (iter<max_iter)) {
        # Calculate new value
        x_new <- x1 -  f1*(x1 - x0)/(f1 - f0)
        print(sprintf("The new x value is %f", x_new))
        # Replace old value with current
        x0 <- x1
        x1 <- x_new
        f0 <- f1
        f1 <- fun(x1)
        # Increment counter
        iter <- iter + 1
    }
}

secant(f_test, 2, 3)