precip <- read.table("~/Bios6301/datasets/nashville_precip.txt", header=T, row.names=1)
annual_precip <- rowSums(precip)

dev.new(width = 15, height = 5)
plot(annual_precip, type='l', axes=FALSE, ylab='Precipitation',
    xlab='Year', lwd=0.5)
grand_mean <- mean(annual_precip, na.rm=T)

abline(h=grand_mean, lty=2, col='blue')

years <- rownames(precip)
every_5 <- seq(1,length(years), by=5)
axis(1, at=every_5, labels=years[every_5])
axis(2)

text(x = 10, y = 70,
     paste("Long-term average = ",round(grand_mean)," mm"))

arrows(x0 = 0, y0 = 69, x1 = 0, y1 = grand_mean, length = 0.05)