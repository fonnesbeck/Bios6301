library(ggplot2)
library(plotly)

vlbw <- read.csv('https://raw.githubusercontent.com/fonnesbeck/Bios366/master/data/vlbw.csv', row.names=1)
vlbw <- vlbw[complete.cases(vlbw[,c('sex','dead','gest','bwt')]),]

grps <- split(vlbw[,c('gest','bwt')], vlbw[,c('sex','dead')])

p <- ggplot(data=vlbw) + aes(x=gest, y=bwt, color=sex, shape=as.factor(dead)) + geom_point()
p
ggplotly(p)

plot_ly(type="box") %>%
  add_boxplot(y = grps[['female.0']][,'bwt'], name='F:0') %>%
  add_boxplot(y = grps[['female.1']][,'bwt'], name='F:1') %>%
  add_boxplot(y = grps[['male.0']][,'bwt'], name='M:0') %>%
  add_boxplot(y = grps[['male.1']][,'bwt'], name='M:1')

plot(c(22,40), c(400,1600), type='n', xlab='Gestational Age', ylab='Birth Weight (grams)', axes=FALSE)
axis(1, at=c(22,28,34,40), labels=c(22,28,34,40))
axis(2, at=seq(400,1600,by=400), labels=seq(400,1600,by=400))
points(grps[['female.0']], col='black', pch=1)
points(grps[['female.1']][,'gest'], grps[['female.1']][,'bwt'], col='black', pch=0)
points(jitter(grps[['male.0']][,'gest'], 2), grps[['male.0']][,'bwt'], col='gray', pch=4)
points(grps[['male.0']][,'bwt'] ~ jitter(grps[['male.0']][,'gest'], 2), col='gray', pch=3)
legend("bottomright", legend=c('F:0','F:1','M:0','M:1'), col=c('black','black','gray','gray'), pch=c(1,0,4,3))
