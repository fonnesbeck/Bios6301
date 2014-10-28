
## ----, echo=FALSE--------------------------------------------------------
# packages to install
packCheck <- function(x) {
  hasPackage <- tryCatch(find.package(x), error=function(e) e)
  if(inherits(hasPackage, "error")) install.packages(x)
}
packCheck('ggplot2')
packCheck('RCurl')
packCheck('hexbin')
packCheck('maps')
packCheck('mapproj')
packCheck('RColorBrewer')


## ----, echo=FALSE--------------------------------------------------------
library(knitr)
opts_chunk$set(warning = FALSE)


## ------------------------------------------------------------------------
library(ggplot2)


## ------------------------------------------------------------------------
library(RCurl)
url <- getURL("https://raw.githubusercontent.com/fonnesbeck/Bios366/master/data/vlbw.csv")
vlbw <- read.csv(text=url, row.names=1)
head(vlbw, 3)


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw)


## ------------------------------------------------------------------------
qplot(bwt, data=vlbw, geom='histogram', binwidth=25)


## ------------------------------------------------------------------------
qplot(bwt, data=vlbw, geom='density')


## ------------------------------------------------------------------------
qplot(sex, bwt, data=vlbw, geom=c('jitter','boxplot'))


## ------------------------------------------------------------------------
qplot(gest, bwt, color=ivh, data=vlbw)


## ------------------------------------------------------------------------
qplot(gest, bwt, size=lol, data=vlbw)


## ------------------------------------------------------------------------
qplot(gest, bwt, color=pltct, data=vlbw)


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw, facets=race ~ .)


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw, facets=. ~ race)


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw, facets=~ apg1)


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw[!is.na(vlbw$sex) & !is.na(vlbw$race),], facets=race~sex)


## ----, eval=FALSE--------------------------------------------------------
## qplot(gest, bwt, data=vlbw) + facet_grid(race ~ .)
## p <- qplot(gest, bwt, data=vlbw)
## p <- p + facet_wrap(~ apg1, scales='free')


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw)


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw, geom="jitter")


## ------------------------------------------------------------------------
qplot(gest, bwt, data=vlbw, alpha = I(1/5))


## ------------------------------------------------------------------------
qplot(sex, bwt, data=vlbw, geom=c('violin'))


## ------------------------------------------------------------------------
library('hexbin')
qplot(bwt, gest, data=vlbw, geom='hex')


## ------------------------------------------------------------------------
p <- ggplot(vlbw, aes(x=gest, y=bwt))


## ------------------------------------------------------------------------
(p <- p + geom_point())


## ------------------------------------------------------------------------
summary(p)


## ----, eval=FALSE--------------------------------------------------------
## save(p, file = "plot.rdata")
## load("plot.rdata")
## ggsave("plot.png", width = 5, height = 5)


## ------------------------------------------------------------------------
p + geom_smooth(method = "lm")


## ------------------------------------------------------------------------
p + geom_smooth(method = "loess", color="steelblue", alpha=0.5)


## ------------------------------------------------------------------------
p + geom_point(aes(color=sex))


## ------------------------------------------------------------------------
p + geom_point(color="darkblue") + aes(y=pltct) + ylab("Platelet count") + xlab("Gestational age")


## ----, eval=FALSE--------------------------------------------------------
## p <- ggplot(vlbw, aes(x=gest, y=bwt))
## p <- p + geom_point()
## p + geom_point(aes(color=sex))


## ----, eval=FALSE--------------------------------------------------------
## p + geom_point(color="darkblue")


## ----, eval=FALSE--------------------------------------------------------
## p + geom_point(aes(color="darkblue"))


## ------------------------------------------------------------------------
g <- ggplot(vlbw, aes(bwt))
g + stat_bin(aes(ymax=..count..), binwidth=50, geom='area')


## ------------------------------------------------------------------------
g + stat_bin(aes(size=..density..), binwidth=50, geom='point')

g <- ggplot(vlbw, aes(x=bwt, y=pltct))
g + stat_density2d(aes(fill=..density..), binwidth=50, geom='tile',
        contour=F) + scale_fill_gradient(low = "blue", high = "red")


## ------------------------------------------------------------------------
ggplot(vlbw, aes(apg1, bwt)) + geom_point() + 
  stat_summary(fun.data = "mean_sdl", geom=c("errorbar"), color="red")


## ------------------------------------------------------------------------
iqr <- function(x, ...) {
  qs <- quantile(as.numeric(x), c(0.25, 0.75), na.rm = T)
  names(qs) <- c("ymin", "ymax")
  qs
}

ggplot(vlbw, aes(apg1, bwt)) + geom_point() + 
  stat_summary(fun.data = "mean_sdl", geom=c("smooth"))

ggplot(vlbw, aes(apg1, bwt)) + geom_point() + 
  stat_summary(fun.data = "iqr", geom=c("ribbon"), alpha=0.4)

ggplot(vlbw, aes(factor(apg1), bwt)) + geom_jitter(alpha=0.5) + 
  stat_summary(fun.data = "median_hilow", geom="crossbar")


## ------------------------------------------------------------------------
qplot(bwt, pltct, data=vlbw) + theme_bw()


## ----, eval=FALSE--------------------------------------------------------
## theme_set(theme_bw())


## ------------------------------------------------------------------------
theme_grey()


## ------------------------------------------------------------------------
qplot(bwt, pltct, data=vlbw) + labs(title="Platelet count as function of birth weight") +
      theme(axis.title.x = element_text(face = "bold", colour="red"),
            axis.title.y = element_text(size = 20, angle = 0))


## ------------------------------------------------------------------------
qplot(bwt, pltct, data=vlbw) +
      theme(axis.title.x = element_blank(), axis.text.x = element_blank(),
            axis.title.y = element_blank(), axis.text.y = element_blank())


## ------------------------------------------------------------------------
library(maps)
data(us.cities)

tn_cities <- subset(us.cities, country.etc=="TN")
tn_map <- ggplot(tn_cities, aes(long, lat))
tn_map <- tn_map + borders("county", "tennessee", colour="grey70")
tn_map

tn_map + geom_point(aes(size=pop), colour="black", alpha=0.5) + theme_bw() +
    coord_map("orthographic") + scale_x_continuous("") + scale_y_continuous("")


## ------------------------------------------------------------------------
g <- ggplot(vlbw, aes(x=bwt, y=pltct))
g + stat_density2d(aes(fill=..density..), binwidth=50, geom='tile', contour=F) +
    scale_fill_gradientn(colours=topo.colors(7))


## ------------------------------------------------------------------------
library(RColorBrewer)
display.brewer.all(type="seq")


## ------------------------------------------------------------------------
g + stat_density2d(aes(fill=..density..), binwidth=50, geom='tile', contour=F) +
    scale_fill_gradientn(colours=brewer.pal(7,"Greens"))


