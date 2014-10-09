
## ------------------------------------------------------------------------
runif(2)
old.seed <- .Random.seed # Store the seed
set.seed(20090425)
runif(2)
set.seed(20090425)  # Reset it
runif(2)
.Random.seed <- old.seed  # Restore old seed


## ------------------------------------------------------------------------
RNGkind()
RNGkind('Wich')
RNGkind()


## ------------------------------------------------------------------------
binom_cdf <- function(x, n, p) {
    Fx <- 0
    for (i in 0:x) {
        Fx <- Fx + choose(n, i) * p^i * (1-p)^(n-i)
    }
    return(Fx)
}

# same thing, different way
binom_pmf <- function(x, n, p) choose(n, x) * p^x * (1-p)^(n-x)
binom_cdf <- function(x, n, p) sum(sapply(seq(0,x), binom_pmf, n, p))


## ------------------------------------------------------------------------
gen_variate <- function(F, ...) {
    x <- 0
    u <- runif(1)
    while (F(x, ...) < u) x <- x + 1
    return(x)
}


## ------------------------------------------------------------------------
x <- numeric(100)
for (i in 1:100) x[i] <- gen_variate(binom_cdf, 10, 0.25)
# use replicate function
x <- replicate(100, gen_variate(binom_cdf, 10, 0.25))
hist(x, prob=T)
lines(0:10, dbinom(0:10,10,0.25))


## ------------------------------------------------------------------------
rnorm(n=5, mean=3, sd=4)
rbinom(n=5, 10, 0.3)


## ------------------------------------------------------------------------
getpower = function(delta, delta.sd, siglevel, n, nsim) {
  pvals = numeric(nsim)
  set.seed(1)
  for(i in seq_along(pvals)) {
    x = rnorm(n, mean=delta, sd=delta.sd)
    pvals[i] = t.test(x, alternative="two.sided", mu=0)$p.value 
  }
  mean(pvals < siglevel)
}
getpower(delta=0.5, delta.sd=2, siglevel=0.05, n=25, nsim=1000)
getpower(delta=0.5, delta.sd=2, siglevel=0.05, n=25, nsim=10000)
# note there is a function to do this
power.t.test(n=25, delta=0.5, sd=2, sig.level=0.05, type='one.sample')$power


## ------------------------------------------------------------------------
power.t.test(power=0.9, delta=0.5, sd=2, sig.level=0.05, type='one.sample')$n


## ------------------------------------------------------------------------
sample(c(-1,14,3,6,-3))
sample(5)
sample(5, replace=T)


## ------------------------------------------------------------------------
(x <- rnorm(10))
sample(x, 10, replace=TRUE)


## ------------------------------------------------------------------------
x <- rnorm(10)
s <- numeric(1000)
for(i in seq_along(s)) s[i] <- mean(sample(x, 10, replace=TRUE))
hist(s, xlab="Bootstrap means", main="")


## ------------------------------------------------------------------------
library(boot)
x <- rnorm(10)
med <- function(x,i) median(x[i])
(bmed <- boot(x, med, R=999))
boot.ci(bmed)


## ------------------------------------------------------------------------
data(anorexia, package="MASS")
hist(anorexia[,'Prewt'], breaks=ceiling(diff(range(anorexia[,'Prewt']))), main='', xlab='Weight')


## ------------------------------------------------------------------------
weight <- anorexia[,'Prewt']
bmeans <- replicate(999, mean(sample(weight, replace=TRUE)))
quantile(bmeans, c(0.025, 0.975))


## ------------------------------------------------------------------------
mean(weight, na.rm=T) + c(-1.96, 1.96)*sd(weight, na.rm=TRUE)/sqrt(length(weight))
weight_boot <- boot(weight, function(x,i) mean(x[i]), R=999)
quantile(weight_boot$t, c(0.025, 0.975))


## ------------------------------------------------------------------------
true_mu <- 0
x <- rnorm(100, true_mu)
R <- 999

lower <- numeric(R)
upper <- numeric(R)

for (i in 1:R) {

    s <- x[sample(length(x), replace=TRUE)]
    xbar <- mean(s)
    s <- sd(s)

    lower[i] = xbar + qnorm(0.025) * (s / sqrt(length(x)))
    upper[i] = xbar + qnorm(0.975) * (s / sqrt(length(x)))
}

mean(lower < true_mu & upper > true_mu)


## ------------------------------------------------------------------------
x <- 5492364201


## ------------------------------------------------------------------------
(y <- as.character(x**2))


## ------------------------------------------------------------------------
options(scipen=10)
as.numeric(substring(y,6,15))


## ------------------------------------------------------------------------
m <- 10; A <- 103; B <- 17; x <- 2
(x <- (A*x + B) %% m)
(x <- (A*x + B) %% m)
(x <- (A*x + B) %% m)


## ------------------------------------------------------------------------
m <- 2^32; A <- 1644525; B <- 1013904223
x <- (A*x + B) %% m; x/m
x <- (A*x + B) %% m; x/m
x <- (A*x + B) %% m; x/m


## ------------------------------------------------------------------------
geom_sample <- function(p) {
    x <- 0
    success <- FALSE
    while (!success) {
        u <- runif(1)
        if (u < p) {
            success <- TRUE
        } else {
            x <- x + 1
        }
    }
    return(x)
}


## ------------------------------------------------------------------------
f <- function(x,lam) -1/lam * log(1-x)
hist(f(runif(1000), 3), prob=T, xlab="x", main="")
lines((1:300)/100, dexp((1:300)/100, 3))


## ------------------------------------------------------------------------
triangular <- function(x){
    if ((0<x) && (x<1)) {
        return(x)
    } else if ((1<x) && (x<2)) {
        return(2-x)
    } else {
        return(0)
    }
}


## ------------------------------------------------------------------------
rejectionK <- function(fx, a, b, K) {
    while (TRUE) {
        x <- runif(1, a, b)
        y <- runif(1, 0, K)
        if (y < fx(x)) return(x)
    }
}


