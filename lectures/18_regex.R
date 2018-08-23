toupper
tolower

grep
grep+value
grep+fixed
grep+perl
grepl

# generate hexadecimal numbers
hex <- c(0:9, LETTERS[1:6])
set.seed(16)
x <- replicate(100, paste(sample(hex, 5, replace=TRUE), collapse=''))
grep("00", x, value=TRUE)
grep("0.0", x, value=TRUE)
grep("0.+0", x, value=TRUE)
grep("0.?0", x, value=TRUE)
grep("0.*0", x, value=TRUE)
grep("^0", x, value=TRUE)
grep("0$", x, value=TRUE)
grep("[A-H]", x, value=TRUE)
grep("[A-H]{4}", x, value=TRUE)
grep("^B|C$", x, value=TRUE)
grep("[A-H].*[A-H]", x, value=TRUE)
grep("^[^A-H]", x, value=TRUE)
# ask
grep("^[^A-H]*$", x, value=TRUE)

?regex
metacharacters
* [
* \
* (
* )
* .
* |
# anchors
* ^
* $
# quantifiers
* ?
* *
* +
* {

# select columns starting w/ init from data set
# find files ending with extension

# valid dates (YYYY-MM-DD)
electionDay <- c('2020-11-03', '2016-11-08', '12-11-06', '2008-11-4', '04-11-02')

# character classes
grep("[[:alpha:]]", c('-hey-','-----','12345'))

g?regexpr
# extract the matching characters with...
mo <- regexpr(pattern, string)
substr(string, mo, mo+attr(mo, 'match.length')-1)

g?sub
# placeholders

change electionDay format to MM/DD/YYYY
