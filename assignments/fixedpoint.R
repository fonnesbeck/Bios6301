fixedpoint <- function(ftn, x0, tol = 1e-9, max.iter = 100) {
# Updated function from text to allow for vector-valued functions
  # do first iteration
  xold <- x0
  xnew <- ftn(xold)
  iter <- 1
  cat("At iteration 1 value of x is:", xnew, "\n")
  # Just use euclidean distance here
  while ((dist(rbind(xnew,xold)) > tol) && (iter < max.iter)) {
    xold <- xnew
    xnew <- ftn(xold)
    iter <- iter + 1
    cat("At iteration", iter, "value of x is:", xnew, "\n")
  }
  # output depends on success of algorithm 
  if (dist(rbind(xnew,xold)) > tol) {
    cat("Algorithm failed to converge\n")
    return(NULL)
  } else {
    cat("Algorithm converged\n")
    return(xnew)
  }
}

f <- function(x) c(log(1+x[1]+x[2]), log(5-x[1]-x[2]))