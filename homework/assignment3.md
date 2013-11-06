# Bios 301: Assignment 3 #

*Due Thursday, 21 November, 12:00 PM*

50 points total.

Submit a single knitr (either `.rnw` or `.rmd`) file, along with a valid PDF output file. Inside the file, clearly indicate which parts of your responses go with which problems (you may use the original homework document as a template). Raw R code/output or word processor files are not acceptable.

### Question 1 ###

**20 points**

Code a function that does golden section search, and use this function to find all of the local maxima on the following function:

$$f(x) = \left\\{\begin{array}{l}0 & \text{if } x=0 \cr
|x| \log\left(\frac{|x|}{2}\right)e^{-|x|} & \text{otherwise}
\end{array}\right.$$

on the interval [-10, 10].

To get an idea of what the function looks like, it might be helpful to plot it.

### Question 2 ###

**10 points**

Obtain the code for using Newton's Method to estimate logistic regression parameters (`logtistic.r`) and modify it to predict `death` from `weight`, `hemoglobin` and `cd4baseline` in the HAART dataset. Use complete cases only. Report the estimates for each parameter, including the intercept.

### Question 3 ###

**20 points**

Consider the following very simple genetic model (*very* simple -- don't worry if you're not a geneticist!). A population consists of equal numbers of two sexes: male and female. At each generation men and women are paired at random, and each pair produces exactly two offspring, one male and one female. We are interested in the distribution of height from one generation to the next. Suppose that the height of both children is just the average of the height of their parents, how will the distribution of height change across generations?

Represent the heights of the current generation as a dataframe with two variables, m and f, for the two sexes. The command rnorm(100, 160, 20) will generate a vector of length 100, according to the normal distribution with mean 160 and standard deviation 20 (see Section 16.5.1). We use it to randomly generate the population at generation 1:

    pop <- data.frame(m = rnorm(100, 160, 20), f = rnorm(100, 160, 20))

The command `sample(x, size = length(x))` will return a random sample of size `size` taken from the vector `x`. The following function takes the data frame `pop` and randomly permutes the ordering of the men. Men and women are then paired according to rows, and heights for the next generation are calculated by taking the mean of each row. The function returns a data frame with the same structure, giving the heights of the next generation.

    next_gen <- function(pop) {
        pop$m <- sample(pop$m)
        pop$m <- apply(pop, 1, mean)
        pop$f <- pop$m
        return(pop)
   }

Use the function `next_gen` to generate nine generations, then use the function `histogram` from the `lattice` to plot the distribution of male heights in each generation. The phenomenon you see is called regression to the mean.

Hint: construct a data frame with variables height and generation, where each row represents a single man.

<!-- Mathjax -->
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      processEscapes: true
    }
  });
</script>
<script type="text/javascript"
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>