numeric(10)
rep(1, 10)
rep(1:4, times=1:4)
rep(seq(4), each=4)

(x <- seq(10, 100, by=10))
x[15] <- 150
x

x <- seq(16)
y <- rep(1:4, each=4)

x * y
x %*% y
matrix(x) %*% y
x %*% matrix(y)
matrix(x) %*% matrix(y)

mx <- matrix(x, nrow=4)
my <- matrix(y, nrow=4)
mx * my
mx %*% my
my %*% mx

mx1 <- matrix(x, ncol=2)
my1 <- matrix(y, nrow=2)
mx1 %*% my1
my1 %*% mx1

mx2 <- matrix(x, ncol=8, byrow=TRUE)
my2 <- matrix(y, nrow=8)
mx2 %*% my2
my2 %*% mx2
t(mx2) %*% t(my2)
mx2 %*% t(my1)

mx2 %*% diag(8)

mx * upper.tri(mx)
mx * lower.tri(mx, diag=TRUE)

(x <- matrix(seq(25), 5, 5))
x[x %% 2 == 0] <- NA
x[upper.tri(x, diag=TRUE)] <- NA
x[,1] <- x[5,] <- NA
x
which(!is.na(x), arr.ind=TRUE)

which(!(x %% 2 == 0 | upper.tri(x, diag=TRUE) | (x-1) %/% 5 == 0 | x %% 5 == 0), arr.ind=TRUE)
