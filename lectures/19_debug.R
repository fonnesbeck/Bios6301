# warning
seq(4)*seq(3)
log(-1)
# error
if(NA)1
if(NULL)1

as.numeric(c(pi, "3.14", "pi", 4*(4*atan(1/5)-atan(1/239))))
suppressWarnings(as.numeric(c(pi, "3.14", "pi", 4*(4*atan(1/5)-atan(1/239)))))
options(warn = -1)
as.numeric(c(pi, "3.14", "pi", 4*(4*atan(1/5)-atan(1/239))))
options(warn = 0)

library(MASS)
set.seed(10)
ans <- matrix(NA, nrow=10, ncol=6)
for(i in seq(nrow(ans))) {
    x <- matrix(sample(2, 36, replace=TRUE), ncol=6)
    y <- tryCatch(solve(x), error=function(e) {
    # return NULL if singular
    if(grepl("singular", e$message)) return(NULL)
    # otherwise, fail as normal
    stop(e)
    })
    if(is.null(y)) {
    warning("The Moore-Penrose pseudoinverse was used for singular matrix.")
    y <- ginv(x)
    }
    ans[i,] <- diag(y)
}
round(ans, 4)

# finding bugs
code you write
code others write
# https://github.com/cran/mice/blob/master/R/as.r

* print statements verify value of variables
* tedious, need to be removed
* traceback
* debug
* browser

lm(y ~ x)
traceback()

debug(sample)
sample(1:3)
# n, c, Q... R statements
undebug(sample)
debugonce(sample)
sample(1:3)

total <- 0
cnt <- 0
while(total < 10) {
    total <- total + rnorm(1)
    cnt <- cnt + 1
#    print(cnt)
#    browser(expr=cnt > 20)
}

options(error = recover)
options(error = NULL)

# Use one or more of the debugging tools described in this section to locate the bug in the `logistic_debug.r` script located in the `exercises` folder.

library(testthat)

# code.R
# library(testthat)
# test_dir('tests')

matmult <- function(x, y) {
#     do.call(rbind, lapply(seq(nrow(x)), function(i) {
#         colSums(x[i,] * y)
#     }))
    t(sapply(seq(nrow(x)), function(i) {
        colSums(x[i,] * y)
    }))
}
###

# tests/test_mat.R
context("matrix multiplication")

test_that("produces valid dimensions", {
    x <- matrix(1:10, nrow=5)
    y <- matrix(1:16, nrow=ncol(x))
    expect_equal(dim(matmult(x,y)), c(nrow(x),ncol(y)))
})

test_that("calculates correct values", {
    x <- matrix(1:10, nrow=5)
    y <- matrix(1:16, nrow=ncol(x))
    expect_equal(matmult(x,y), x %*% y)
    set.seed(25)
    x <- matrix(sample(25), nrow=5)
    y <- solve(x)
    expect_equal(matmult(x,y), diag(ncol(x)))
})
###
