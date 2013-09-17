# Specify parameters
n <- 20
p <- 0.4
# Generate a random sample
x <- rbinom(100, n, p)
# Generate histogram of sample
hist(x, ylab="Frequency", xlab="X")