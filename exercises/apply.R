makePatient <- function() {
  vowel <- grep("[aeiou]", letters)
  cons <- grep("[^aeiou]", letters)
  name <- paste(sample(LETTERS[cons], 1), sample(letters[vowel], 1), sample(letters[cons], 1), sep='')
  gender <- factor(sample(0:1, 1), levels=0:1, labels=c('female','male'))
  dob <- as.Date(sample(7500, 1), origin="1970-01-01")
  n <- sample(6, 1)
  doa <- as.Date(sample(1500, n), origin="2010-01-01")
  pulse <- round(rnorm(n, 80, 10))
  temp <- round(rnorm(n, 98.4, 0.3), 2)
  fluid <- round(runif(n), 2)
  list(name, gender, dob, doa, pulse, temp, fluid)
}

# how do we create data.frame of patients?
as.data.frame(makePatient())

# re-write as lapply

# how many patients?

# how do we run quantile for each numeric field?

# how do we convert date fields to character strings (m/d/Y)?

# how do we calculate average pulse/temp/fluid for each patient?

set.seed(1)
x <- matrix(sample(100, replace=TRUE, 20), nrow=10)
# generate sequence from col1 to col2 by 5
