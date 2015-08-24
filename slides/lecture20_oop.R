class(1)
x <- 1:3
y <- x^2
lmout <- lm(y ~ x)
class(lmout)
unclass(lmout)
lmout
methods(print)
getAnywhere(print.lm)
methods(,lm)
plot(lmout)
lmoutsum <- summary(lmout)
coef(lmout)
coef(lmoutsum)
methods(coef)
getAnywhere(coef.default)

j <- list(name="Joe", salary=55000, union=TRUE)
class(j) <- 'employee'
attributes(j)

print.employee <- function(wrkr) {
  cat(sprintf("name: %s\nsalary: %s\nunion member: %s", 
              wrkr$name, wrkr$salary, wrkr$union), "\n")
}
methods(class='employee')

k <- list(name="Kate", salary=NA, union=FALSE, rate=10.50, hrs_this_month=2)
class(k) <- c('hourly_employee', 'employee')
inherits(k, 'employee')


pvalue <- function(x) {
  UseMethod("pvalue")
}

pvalue.default <- function(x) {
  if('p.value' %in% names(x)) return(x$p.value)
  stop('no p.value for this object')
}

pvalue.summary.lm <- function(x) {
  cv <- coef(x)
  cv[,ncol(cv)]
}

pvalue(lmoutsum)
pvalue(t.test(rnorm(100)))
pvalue(1:10)

set.seed(1)
n <- 60
x <- (1:n)/n
y <- sin((3*pi/2)*x) + x^2 + rnorm(n, mean=0, sd=0.5)

polyfit <- function(y, x, maxdeg) {
  pwrs <- outer(x, seq(maxdeg), "^")
  lmout <- vector('list', maxdeg)
  class(lmout) <- 'polyreg'
  for(i in seq(maxdeg)) {
    lmo <- lm(y ~ pwrs[,seq(i)])
    lmo$fitted.cvvalues <- leave_one_out(y, pwrs[,seq(i),drop=FALSE])
    lmout[[i]] <- lmo
  }
  lmout$x <- x
  lmout$y <- y
  lmout
}

leave_one_out <- function(y, xmat) {
  n <- length(y)
  pred_y <- numeric(n)
  for(i in seq(n)) {
    lmo <- lm(y[-i] ~ xmat[-i,])
    beta_hat <- unname(coef(lmo))
    pred_y[i] <- beta_hat %*% c(1, xmat[i,])
  }
  pred_y
}

print.polyreg <- function(fits) {
  maxdeg <- length(fits)-2
  n <- length(fits$y)
  tbl <- matrix(nrow=maxdeg, ncol=1)
  colnames(tbl) <- "MSPE"
  for(i in seq(maxdeg)) {
    fi <- fits[[i]]
    errs <- fits$y - fi$fitted.cvvalues
    spe <- crossprod(errs, errs)
    tbl[i,1] <- spe/n
  }
  print(tbl)
}

dg <- 15
lmo <- polyfit(y, x, dg)

setClass("fun", representation(f="function", x="numeric", y="numeric"))
f <- function(x) sin((3*pi/2)*x) + x^2 + rnorm(length(x), mean=0, sd=0.5)
f1 <- new("fun", f=f, x=seq(0,10,by=0.1))
f1@y <- f1@f(f1@x)
plot(f1@x, f1@y, type='l', xlab='x', ylab='y', 
     main=sprintf("f(x) = %s", capture.output(body(f1@f))))
setMethod("initialize", "fun", 
          function(.Object, f=expression, x=numeric(0), y=numeric(0), seed=1) {
            .Object@f <- f
            if(length(x) == 0) x<-seq(0,10)
            .Object@x <- x
            set.seed(seed)
            .Object@y <- f(x)
            .Object
          })
f2 <- new("fun", f=f)
fun <- function(...) {
  new("fun", ...)
}
f3 <- fun(f=f, x=seq(0,10,by=0.1))
setMethod("plot", signature(x="fun", y="missing"), function(x,...) {
  plot(x@x, x@y, type='l', xlab='x', ylab='y', 
       main=sprintf("f(x) = %s", capture.output(body(f1@f))), ...)  
})

Tired <- setRefClass("Tired",
                     fields = list(speech='character'),
                     methods = list(show=function() {
                       zs <- paste(rep('z', sample(10, 1)), collapse='')
                       print(sprintf("%s... %s", speech, zs))
                     })
)
t <- Tired$new(speech="We're talking about practice")
