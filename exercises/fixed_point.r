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

# > x
# [1] 1.3098
# > abs(x-x_old)
# [1] 4.49629e-10
# > iter
# [1] 22
