prettyprint <- function(x, labels) {
  x <- data.frame(x)
  sz <- ncol(x)
  if(!missing(labels)) names(x)[seq_along(labels)] <- labels
  size <- sapply(seq(sz), FUN=function(i) max(nchar(c(names(x)[i], as.character(x[[i]]))))) + 2
  newrow <- sprintf("+%s+", paste(sapply(size, FUN=function(i) paste(rep('-',i), collapse='')), collapse='+'))
  rowPr <- sapply(size, FUN=function(i) sprintf("%%%ss ", i-1))
  header <- sprintf("|%s|", paste(sapply(seq(sz), FUN=function(j) sprintf(rowPr[j], names(x)[j])), collapse='|'))
  content <- sprintf("|%s|", apply(x, MARGIN=1, FUN=function(i) paste(sapply(seq(sz), FUN=function(j) sprintf(rowPr[j], i[j])), collapse='|')))
  cat(paste(c(newrow, header, newrow, content, newrow), collapse='\n'), "\n")
}

rp <- function(x, n=4) sprintf(sub("n", n, "%0.nf"), x)

se <- function(x) sd(x)/sqrt(length(x))

twobytwo <- function(x) x[1,1]*x[2,2]/(x[1,2]*x[2,1])

or <- function(x, ci=0.95) {
  stopifnot(ncol(x)==2)
  z <- qnorm((1+ci)/2)
  o <- vector('list', nrow(x)-1)
  for(i in seq_along(o)) {
    x1 <- x[c(1,i+1),]
    or <- twobytwo(x1)
    ci <- exp(log(or) + z*c(-1,1)*sqrt(sum(1/x1)))
    o[[i]] <- list(mat=x1, oddsratio=c(OR=or, LB=ci[1], UB=ci[2]))
  }
  o
}

x <- matrix(c(7,23,41,43,27,9), nrow=3)
dimnames(x) <- list(c('compact','suv','sport'), c('hand','pro'))
prettyprint(x)
or(x)
(z <- sapply(lapply((10^(1:3))^2, rnorm), se))
rp(z)
