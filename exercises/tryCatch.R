not.a.good.guess <- -10
f <- function(x) cos(x)-x
fp <- function(x) -sin(x)-1

newton <- function(guess, f, fp, tol=10^-7, maxiter=100) {
  i <- 1
  while(abs(f(guess)) > tol && i < maxiter) {
    guess <- guess - f(guess)/fp(guess)
    i <- i + 1
  }
  if(i == maxiter) stop('failed to converge')
  guess
}

ans <- newton(not.a.good.guess, f, fp)

while(TRUE) {
  ans <- tryCatch(newton(not.a.good.guess, f, fp), error=function(e) NULL)
  if(!is.null(ans)) break
  not.a.good.guess <- not.a.good.guess+1
}

ans
