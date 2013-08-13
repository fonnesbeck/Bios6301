library(maps)
library(ggplot2)
data(us.cities)

tn_cities <- subset(us.cities, country.etc=="TN")
tn_map <- ggplot(tn_cities, aes(long, lat))
tn_map <- tn_map + borders("county", "tennessee", colour="grey70")
tn_map <- tn_map + geom_point(aes(size=pop), colour="black", alpha=0.5) + theme_bw() + coord_map("orthographic")