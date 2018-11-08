# base graphics are constructed with a series of steps

vlbw <- read.csv('https://raw.githubusercontent.com/fonnesbeck/Bios366/master/data/vlbw.csv', row.names=1)
vlbw <- vlbw[complete.cases(vlbw[,c('gest','bwt','sex','race')]),]

plot(vlbw$gest, vlbw$bwt)
xlab='Gestational Age'
ylab='Birth Weight'
xlim=c(0,40)
ylim=c(0,1600)
col='red'
pch=3 # point char
lty=2 # line type
lwd=2 # line width

?plot
?plot.default
?par

*parameters
mfrow(c(a,b))
mar=c(bottom, left, top, right)
new=TRUE # plot on current device
cex=1 # text/symbol magnification

*empty plot
plot(vlbw$gest, vlbw$bwt, xlab='', ylab='', axes=FALSE, type='n')
points(vlbw$gest, vlbw$bwt, 
    col=ifelse(vlbw[,'sex']=='male', "blue", "red"), 
    pch=as.numeric(vlbw$race)
)
axis(1, lwd=2)
axis(2, lwd=2)
mtext("Gestational Age", side=1, line=3)
mtext("Birth Weight", side=2, line=3)
lab <- c(outer(c('Male','Female'), levels(vlbw$race), paste, sep=', '))
legend("bottomright", lab, pch=rep(seq(4),each=2), col=rep(c('blue','red'),4))
box()

par(mfrow=c(1,2))
plot(vlbw$gest, vlbw$bwt)
plot(vlbw$apg1, vlbw$bwt)

plot(sin, xlim=c(-10,10), ylim=c(-3,3), xaxs='i', yaxs='i')
lines(c(-10,10), c(0,0), lty=2)
segments(pi,-1,pi,1)
arrows(pi, -1, y1=-1.2)
arrows(pi, 1, y1=1.01, angle=90)
text(pi, 0, expression(pi))

?layout
x <- pmin(3, pmax(-3, stats::rnorm(50)))
y <- pmin(3, pmax(-3, stats::rnorm(50)))
xhist <- hist(x, breaks = seq(-3,3,0.5), plot = FALSE)
yhist <- hist(y, breaks = seq(-3,3,0.5), plot = FALSE)
top <- max(c(xhist$counts, yhist$counts))
xrange <- c(-3, 3)
yrange <- c(-3, 3)
nf <- layout(matrix(c(2,0,1,3),2,2,byrow = TRUE), c(3,1), c(1,3), TRUE)
layout.show(nf)

par(mar = c(3,3,1,1))
plot(x, y, xlim = xrange, ylim = yrange, xlab = "", ylab = "")
par(mar = c(0,3,1,1))
barplot(xhist$counts, axes = FALSE, ylim = c(0, top), space = 0)
par(mar = c(3,0,1,1))
barplot(yhist$counts, axes = FALSE, xlim = c(0, top), space = 0, horiz = TRUE)

par(mfrow = c(1,1))
hist(vlbw$gest)
boxplot(bwt ~ race, data=vlbw)
rs <- with(vlbw, table(race,sex))
barplot(rs)

# colour choice
# RColorBrewer

## Load the nashville_precip.txt data from the datasets directory, and create a plot of the total annual precipitation in Nashville. Augment your plot as follows:

# Create an x-axis with labels every 5 years
# Add a horizontal dotted line for the grand mean
# Add a label (and arrow?) for the average line
# Add meaningful labels to the axes
