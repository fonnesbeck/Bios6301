## calculator
10 + 4

## ------------------------------------------------------------------------
2+3; 5*7; 3-7

## ------------------------------------------------------------------------
sessionInfo()

## ------------------------------------------------------------------------
installed.packages()[,c('LibPath','Version')]

install.packages('devtools')
library(devtools)
devtools::install_github('hadley/dplyr')
install_github('couthcommander/coleR')

## ------------------------------------------------------------------------
search()
ls()
ls("package:stats")

## ------------------------------------------------------------------------
getwd()
setwd("~")
getwd()
list.files()
source('idontexist.r')

## ------------------------------------------------------------------------
x <- 5
x < - 5
(x <- 5)

z <- c(1,-5,20)
(z <- c(10, z, 36))
z[2]
z + 1
z - 2
z * 3
z / 4
z ^ 5
# mod, the remainder
z %% 6
# integer division
z %/% 6
# recreate z
(z %/% 6) * 6 + z %% 6
sqrt(z)
abs(z)
sign(z)
round(z / 7, 2)
floor(z / 7)
ceiling(z / 7)
# exponential function
exp(z)
# natural logarithms
log(z)
log(z, 10)
floor(log10(z))+1
# trig functions
sin(z)
sum(z)/length(z)
mean(z)
median(z)
sd(z)
min(z)
max(z)
range(z)
quantile(z)
quantile(z, probs=c(0.1, 0.5, 0.9))
sort(z)
order(z)
z[order(z)]

1e3
5 < 6
5 >= 6
5 != 6
5 == 6

## ------------------------------------------------------------------------
x <- c(1, 2, 3, 4)
y <- c(8, 5, 4, 5)
Multiply x by 5, then add 3, then double this amount, then add y, then subtract 6.  Test if this equals `paste0(x,y)`.
(x*5+3)*2+y-6 == paste0(x,y)

## lecture 3
.Machine$integer.max
# what happened to 64-bit?
2^(32-1)-1 == .Machine$integer.max

0.1 == 0.3/3
unique(c(0.3, 0.4-0.1, 0.5-0.2, 0.6-0.3, 0.7-0.4))

# overflow and underflow also occur
## NHL 2K8

x <- 10
y <- sqrt(x)
x == y**2

tol <- 1e-8
abs(x - y**2) < tol

# Inf/Inf
inv.logit <- function(x) exp(x) / (1+exp(x))
inv.logit(c(10, 1e3, 1e6))
# 1/Inf
inv.logit <- function(x) 1 - 1 / (1+exp(x))
inv.logit(c(10, 1e3, 1e6))
