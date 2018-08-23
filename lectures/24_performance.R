set.seed(111)
n <- 1e3
x <- runif(n, max=n)
match <- sample(n)

`%d%` <- function(i,j) abs(i-j)

getMatches1 <- function(x, match) {
    n <- length(x)
    dist <- outer(x, x, `%d%`)
    matches <- data.frame(row1=numeric(n), row2=numeric(n), distance=numeric(n))
    for(i in seq.int(n)) {
         matches[i,] <- c(i, match[i], dist[i, match[i]])
    }
    matches
}
m <- getMatches1(x, match)

system.time(getMatches1(x, match))

library(microbenchmark)
microbenchmark(getMatches1(x, match))

set.seed(111)
n <- 1e4
x <- runif(n, max=n)
match <- sample(n)

Rprof()
m <- getMatches1(x, match)
Rprof(NULL)
summaryRprof()

getMatches2 <- function(x, match) {
    n <- length(x)
    dist <- lapply(x, `%d%`, x)
    matches <- data.frame(row1=seq.int(n), row2=match, distance=numeric(n))
    for(i in seq_along(dist)) {
        matches[i,'distance'] <- dist[[i]][match[i]]
    }
    matches
}

getMatches3 <- function(x, match) {
    n <- length(x)
    dist <- outer(x, x, `%d%`)
    i <- seq.int(n)
    data.frame(row1=i, row2=match, distance=dist[cbind(i, match)])
}

getMatches4 <- function(x, match) {
    n <- length(x)
    dist <- lapply(x, `%d%`, x)
    zm <- mapply("[", dist, match)
    data.frame(row1=seq.int(n), row2=match, distance=zm)
}

# garbage collection
gc()

set.seed(111)
n <- 1e3
x <- runif(n, max=n)
match <- sample(n)

microbenchmark(
    getMatches1(x, match),
    getMatches2(x, match),
    getMatches3(x, match),
    getMatches4(x, match)
)

gc()
set.seed(111)
n <- 1e4
x <- runif(n, max=n)
match <- sample(n)

Rprof()
m <- getMatches4(x, match)
Rprof(NULL)
summaryRprof()

# Use microbenchmarking to rank the basic arithmetic operators (+, -, *, /, and ^) in terms of their speed.
# Visualise the results.
# Compare the speed of arithmetic on integers vs. doubles.
