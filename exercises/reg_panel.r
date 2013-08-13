haart <- read.csv("~/Bios301/datasets/haart.csv")

library(lattice)
haart$male_factor <- factor(haart$male)
levels(haart$male_factor) <- c("Female", "Male")
age_cut <- equal.count(haart$age, 4)
xyplot(hemoglobin ~ weight | age_cut * male_factor, data=haart,
    panel=function(x, y, ...) {
        panel.xyplot(x, y, ...)
        fit <- lm(y ~ x)
        panel.abline(fit)
    })