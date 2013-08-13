library(ggplot2)
data <- read.table("~/Bios301/datasets/nashville_precip.txt", header=T)[-1]
mnth <- 10
precip_mean <- apply(data, 2, mean, na.rm=T)
precip_var <- apply(data, 2, var, na.rm=T) 
lambda.mm <- precip_mean/precip_var
m.mm <- precip_mean^2/precip_var
p <- ggplot(data, aes(Oct)) + geom_histogram(aes(y=..density..), binwidth=0.5) + xlab("precipitation") + ylab("density")
t <- seq(0, 9, 0.5)
mm <- data.frame(list(t=t, pt=dgamma(t, m.mm[mnth], lambda.mm[mnth])))
head(mm)
p <- p + geom_line(aes(x=t, y=pt), data=mm, color="blue")
x <- data$Oct[!is.na(data$Oct)]
x[x == 0] <- 0.1
newtonraphson <- function(ftn, x0, tol = 1e-9, max.iter = 100, ...) {
  # find a root of ftn(x, ...) near x0 using Newton-Raphson
  # initialise
  x <- x0
  fx <- ftn(x, ...)
  iter <-  0
  # continue iterating until stopping conditions are met
  while ((abs(fx[1]) > tol) & (iter < max.iter)) {
    x <- x - fx[1]/fx[2]
    fx <- ftn(x, ...)
    iter <-  iter + 1
  }
  # output depends on success of algorithm
  if (abs(fx[1]) > tol) {
    stop("Algorithm failed to converge\n")
  } else {
    return(x)
  }
}

dl <- function(m, log_mean, mean_log) {
  return(c(log(m) - digamma(m) - log_mean + mean_log, 1/m - trigamma(m)))
}
m.ml <- newtonraphson(dl, m.mm[mnth], log_mean = log(mean(x)), mean_log = mean(log(x)))
(lambda.ml <- m.ml/mean(x))
ml <- data.frame(list(t=t, pt=dgamma(t, m.ml, lambda.ml)))
p + geom_line(aes(x=t, y=pt), data=ml, color="red")
