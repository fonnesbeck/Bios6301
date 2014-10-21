
## ------------------------------------------------------------------------
newton <- function(f, x0, tol = 1e-9, n_max = 100) {
    x <- x0
    f_x <- f(x)
    n <- 0
    while ((abs(f_x[2]) > tol) & (n < n_max)) {
        # Newton's update
        x <- x - f_x[2]/f_x[3]
        f_x <- f(x)
        # Increment counter
        n <- n + 1
    }
    if (n == n_max) {
        cat('newton failed to converge\n')
    } else {
        return(x)
    }
}


## ------------------------------------------------------------------------
gamma32 <- function(x) {
    # Error checking
    if (x < 0) return(c(0, 0, 0))
    if (x == 0) return(c(0, 0, NaN))
    y <- exp(-2*x)
    return(c(4*x^2*y, 8*x*(1-x)*y, 8*(1-2*x^2)*y))
}

x <- seq(0, 5, by=0.01)
plot(x, sapply(x, gamma32)[1,], ylab='y', main='Gamma(3,2)', type='l')

newton(gamma32, 4)
newton(gamma32, 0.1)
newton(gamma32, 20)


## ------------------------------------------------------------------------
line_search <- function(f, x, y, eps=1e-9, amax=2^5) {

    # specify function g(alpha) to optimize
    g <- function(a) f(x + a*y)

    # get left point
    a_l <- 0
    g_l <- g(a_l)

    # get mid point
    a_m <- 1
    g_m <- g(a_m)
    # make a_m smaller until g(a_m) > g(a_l)
    while ((g_m < g_l) & (a_m > eps)) {
        a_m <- a_m/2
        g_m <- g(a_m)
    }

    # use 0 for a if we cannot get a suitable mid-point
    if ((a_m <= eps) & (g_m < g_l)) return(0)

    # get right point
    a_r <- 2*a_m
    g_r <- g(a_r)
    # make a_r larger until g(a_m) > g(a_r)
    while ((g_m < g_r) & (a_r < a_max)) {
        a_m <- a_r
        g_m <- g_r
        a_r <- 2*a_m
        g_r <- g(a_r)
    }

    # use a_max for a if we cannot get a suitable right point
    if ((a_r >= a_max) & (g_m < g_r)) return(a_max)

    # apply golden-section algorithm to g to find a
    a <- gsection(g, a_l, a_r, a_m)

    return(a)

} # end of function


## ------------------------------------------------------------------------
ascent <- function(f, grad_f, x0, eps = 1e-9, max_iter = 100) {

    # Initialize x values
    x_old <- x0
    gx <- grad_f(x0)
    a <- line_search(f, x0, gx)
    x <- x + a*gx
    # Initialize counter
    i <- 1
    while ((abs(f(x) - f(x_old)) > eps) & (i < max_iter)) {
        x_old <- x
        gx <- grad_f(x)
        a <- line_search(f, x, gx)
        x <- x + a*gx
        # Increment counter
        i <- i + 1
    }
    return(x)
}


## ------------------------------------------------------------------------
newton <- function(H, grad, x0, eps = 1e-9, max_iter = 100) {

    x <- x0
    gradx <- grad(x)
    Hx <- H(x)
    i <- 0
    while ((max(abs(gradx)) > eps) && (i < max_iter)) {
        x <- x - solve(Hx, gradx)
        gradx <- grad(x)
        Hx <- H(x)
        i <- i + 1
    }
    if (i == max_iter) {
        cat('newton failed to converge\n')
    } else {
        return(x)
    }
}


