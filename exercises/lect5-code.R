# newton-raphson x^3+x^2-3x-3
guess <- 1
while(abs(guess^3+guess^2-3*guess-3) > 10^-7) {
  f <- guess^3+guess^2-3*guess-3
  fp <- 3*guess^2+2*guess-3
  guess <- guess - f/fp
}
guess
guess^3+guess^2-3*guess-3

# or
p <- c(1,1,-3,-3)
guess <- 1
while(abs(sum(p*guess^seq(3,0))) > 10^-7) {
  guess <- guess - sum(p*guess^seq(3,0))/sum(p[-4]*seq(3,1)*guess^seq(2,0))
}
guess


#first 25 primes
res <- numeric(25)
cnt <- 1
x <- 2
while(cnt <= 25) {
  good <- TRUE
  for(i in seq(2,sqrt(x))) {
    if(x != i && x %% i == 0) {
      good <- FALSE
      break
    }
  }
  if(good) {
    res[cnt] <- x
    cnt <- cnt + 1
  }
  x <- x + 1
}
res



absval0 <- function(v) {
  for(i in seq_along(v)) {
    if(v[i] < 0) v[i] <- -v[i]
  }
  v
}

absval1 <- function(v) {
  v[v < 0] <- -v[v < 0]
  v
}

absval2 <- function(v) {
  ix <- which(v < 0)
  v[ix] <- -v[ix]
  v
}

absval3 <- function(v) {
  ifelse(v < 0, -v, v)
}

absval4 <- function(v) {
  sqrt(v^2)
}

absval5 <- function(v) {
  v*sign(v)
}

z <- rnorm(1000000)
system.time(absval0(z))
system.time(absval1(z))
system.time(absval2(z))
system.time(absval3(z))
system.time(absval4(z))
system.time(absval5(z))
