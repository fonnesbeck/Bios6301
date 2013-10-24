data <- read.table("~/Bios301/datasets/logistic.csv", sep=",", head=T)

# Logistic function
logistic <- function(x) 1 / (1 - exp(-x))

x <- data[1:2]
y <- data[3]


estimate_logistic <- function(x, y, MAX_ITER=10) {

    n <- dim(x)[1]
    k <- dim(x)[2]

    x <- as.matrix(cbind(rep(1, n), x))
    y <- as.matrix(y)

    # Initialize fitting parameters
    theta <- rep(0, k+1)

    J <- rep(0, MAX_ITER)

    for (i in 1:MAX_ITER) {

        # Calculate linear predictor
        z <- x %*% theta
        # Apply logit function
        h <- logistic(z)

        # Calculate gradient
        grad <- t((1/n)*x) %*% as.matrix(h - y)
        # Calculate Hessian
        H <- t((1/n)*x) %*% diag(array(h)) %*% diag(array(1-h)) %*% x

        # Calculate log likelihood
        J[i] <- (1/n) %*% sum(-y * log(h) - (1-y) * log(1-h))

        # Newton's method
        theta <- theta - solve(H) %*% grad
    }

    return(theta)
}

estimate_logistic(x, y)
# Compare with R's built-in linear regression
g <- glm(disease ~ test1 + test2, data=data, family=binomial(logit))
print(g$coefficients)