f <- function(x) cos(x)
# Initialize value
x <- 3
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
    x <- f(x)
    # Increment counter
    iter <- iter + 1
}

if (abs(x-x_old) > tol) {
  cat("Algorithm failed to converge\n")
} else cat("Algorithm converged to", x, "\n")
print(iter)