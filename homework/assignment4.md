# Bios 301: Assignment 4 #

*Due Friday, 16 November, 12:00 PM*

50 points total.

Submit a single knitr (either `.rnw` or `.rmd`) file, along with a valid PDF (or html) output file. Inside the file, clearly indicate which parts of your responses go with which problems (you may use the original homework document as a template). Raw R code/output or word processor files are not acceptable. 

### Question 1 ###

10 points

Use the simulated results from question 3 in assignment 3 to *exactly* reproduce the following plot in ggplot2. Please show your code.:

![generations plot](http://d.pr/i/Xh0d+)

### Question 2 ###

6 points

Approximate the probability that the proportion of heads obtained will be between 0.50 and 0.52 when a fair coin is tossed

1. 50 times.
2. 500 times.

### Question 3 ###

10 points

We know that the *U(−1,1)* random variable has mean 0. Use a sample of size 100 to estimate the mean and give a 95% confidence interval. Does the confidence interval contain 0? Repeat the above a large number of times (say, 1000). What percentage of time does the confidence interval contain 0? Write your code so that it produces output similar to the following:

    Number of trials: 10

    Sample mean  lower bound  upper bound  contains mean
        -0.0733      -0.1888       0.0422             1
        -0.0267      -0.1335       0.0801             1
        -0.0063      -0.1143       0.1017             1
        -0.0820      -0.1869       0.0230             1
        -0.0354      -0.1478       0.0771             1
        -0.0751      -0.1863       0.0362             1
        -0.0742      -0.1923       0.0440             1
         0.0071      -0.1011       0.1153             1
         0.0772      -0.0322       0.1867             1
        -0.0243      -0.1370       0.0885             1

    100 percent of CI's contained the mean

### Question 4 ###

24 points

Programming with classes:

1. Create an S3 class `medicalRecord` for objects that are a list with the named elements `name`, `gender`, `date_of_birth`, `date_of_admission`, `pulse`, `temperature`, `fluid_intake`. Note that an individual patient may have multiple measurements for some measurements (Hint: you may need to use a vector or data frame somewhere).

2. Write a `medicalRecord` method for the generic function `mean`, which returns averages for pulse, temperature and fluids. Also write a `medicalRecord` method either for `print`, which employs some nice formatting, perhaps arranging measurements by date, or `plot` that generates a composite plot of measurements over time.

3. Create a further class for a cohort (group) of patients, and write methods for `mean` and `print` which, when applied to a cohort, apply mean or print to each patient contained in the cohort. Hint: think of this as a "container" for patients.