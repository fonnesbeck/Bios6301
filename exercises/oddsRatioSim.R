calcPower <- function(d1, d2, size, nsim=1000, sig=0.05) {
  n1 <- nrow(d1)
  n2 <- nrow(d2)
  tmp <- replicate(nsim, {
    ds <- rbind(d1[sample(n1, size),], d2[sample(n2, size),])
    fit <- glm(y ~ x, data=ds, family=binomial)
    summary(fit)$coef[2,4] < sig
  })
  mean(tmp)
}

# beta0, arbitrary constant to adjust proportion of y=1 or y=0
simData <- function(or, N=10^6, beta0=0) {
  beta <- log(or)  # coefficient in the logisitc model
  x <- rnorm(N)   # continuous independent variable
  y <- rbinom(N, size=1, prob=plogis(beta0 + x*beta))    # binary outcome
  data <- data.frame(cbind(x,y))
  data1 <- data[data[,'y'] == 0,]
  data2 <- data[data[,'y'] == 1,]
  list(data1, data2)
}

##############################
# In an earlier study, with an alpha level of 0.01 (0.05/5 to correct for
# 5 metabolites), 300 cases, 300 controls, others found 80% power to
# detect an OR of 1.35 per SD-unit increase
##############################

set.seed(123)
d <- simData(1.35)
calcPower(d[[1]], d[[2]], size=300, nsim=2000, sig=1e-2)
# returns 84.9% power

lb <- 1
ub <- 2
repeat {
  set.seed(123)
  i <- mean(c(lb,ub))
  print(sprintf("trying odds ratio %s", i))
  d <- simData(i)
  p <- calcPower(d[[1]], d[[2]], size=300, nsim=2000, sig=1.25e-06)
  # break when power is (0.79, 0.81)
  if(abs(p - 0.8) < 0.01) break
  if(p < 0.8) {
    lb <- i
  } else {
    ub <- i
  }
}
round(i, 2)

# OR of 1.64
set.seed(123)
d <- simData(1.64)
calcPower(d[[1]], d[[2]], size=300, nsim=2000, sig=1.25e-06)

# may have been lucky, check a few more times
replicate(10, { d=simData(1.64); calcPower(d[[1]], d[[2]], size=300, nsim=2000, sig=1.25e-06)})
