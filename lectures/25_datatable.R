# what is it doing behind the scenes?
# how does it speed things up?
# keys + copying

library(data.table)
library(Lahman)

(x <- data.table(Master))
# modify
x[, debut := as.Date(debut, format='%Y-%m-%d')]
# add
x[, debutAge := floor(as.numeric(debut - birthDate, units='days')/365.25)]

# change column name
setnames(x, "playerID", "id")

# delete
x[, nameGiven := NULL]

# select
x[, c(1, 20, 26)]
x[, c("id", "debut", "debutAge")]
x[, list(id, debut, debutAge)]
debut <- x[, .(id, debut, debutAge)]
# we'll come back to this
debut[, year := as.numeric(format(debut, "%Y"))]

# filter
x[973:999]
x[nameLast == "Beck"]

# sort
x[nameLast == "Beck"][order(debut)]
debut[order(debutAge)]

pit <- data.table(Pitching)
setnames(pit, c('playerID', 'yearID'), c('id', 'year'))
# merge
# inner join
merge(debut, pit, by=c('id', 'year'), all=FALSE)
# left join
merge(debut, pit, by=c('id', 'year'), all.x=TRUE)
# right join
merge(debut, pit, by=c('id', 'year'), all.y=TRUE)
# outer join
merge(debut, pit, by=c('id', 'year'), all=TRUE)

# setkey reorders too
setkey(debut, id, year)
setkey(pit, id, year)
tables()

debut[pit]
pitDebuts <- debut[pit, nomatch=0]

# setkey did something else
pitDebuts["beckch01"]
pit["beckch01"]
pit[.("beckch01", 2011)]
pit["beckch01", mult='first']

# group summary
pitDebuts[, .N, by=year]
pitDebuts[, .N, by=year][N > 125]
pitDebuts[, .N, by=.(year,debutAge)][order(year, debutAge)]
pitDebuts[, .(meanouts = mean(IPouts)), by=debutAge][order(debutAge)]
## ask
# return pitching debuts after year 2000
# calculate mean IPouts, grouped by year
# order by year

## ask
# return pitching debuts with age between 21 and 25
# calculate quantile for SO and BB, groups by debut age
# order by debut age

#https://s3.amazonaws.com/assets.datacamp.com/img/blog/data+table+cheat+sheet.pdf
#https://rstudio-pubs-static.s3.amazonaws.com/52230_5ae0d25125b544caab32f75f0360e775.html

# question 1 from hw 5

url <- "https://github.com/fonnesbeck/Bios6301/raw/master/datasets/haart.csv"
haart <- read.csv(url)

#x <- data.table(haart)
x <- data.table(haart[rep(seq(nrow(haart)), 1000),])

# 1. Convert date columns into a usable (for analysis) format.  Use the `table` command to display the counts of the year from `init.date`.
# 2. Create an indicator variable (one which takes the values 0 or 1 only) to represent death within 1 year of the initial visit.  How many observations died in year 1?
# 3. Use the `init.date`, `last.visit` and `death.date` columns to calculate a followup time (in days), which is the difference between the first and either the last visit or a death event (whichever comes first). If these times are longer than 1 year, censor them (this means if the value is above 365, set followup to 365).  Print the quantile for this new variable.
# 4. Create another indicator variable representing loss to followup; this means the observation is not known to be dead but does not have any followup visits after the first year.  How many records are lost-to-followup?
