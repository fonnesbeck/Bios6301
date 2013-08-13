# Bios 301: Assignment 2 #

*Due Monday, 15 October, 12:00 PM*

50 points total.

Submit a single knitr (either `.rnw` or `.rmd`) file, along with a valid PDF output file. Inside the file, clearly indicate which parts of your responses go with which problems (you may use the original homework document as a template). Raw R code/output or word processor files are not acceptable. 

### Question 1 ###

**20 points**

A problem with the Newton-Raphson algorithm is that it needs the derivative $f′$. If the derivative is hard to compute or does not exist, then we can use the *secant method*, which only requires that the function $f$ is continuous. 
 
Like the Newton-Raphson method, the **secant method** is based on a linear approximation to the function $f$. Suppose that $f$ has a root at $a$. For this method we assume that we have *two* current guesses, $x_0$ and $x_1$, for the value of $a$. We will think of $x_0$ as an older guess and we want to replace the pair $x_0$, $x_1$ by the pair $x_1$, $x_2$, where $x_2$ is a new guess. 
 
To find a good new guess x2 we first draw the straight line from $(x_0,f(x_0))$ to $(x_1,f(x_1))$, which is called a secant of the curve $y = f(x)$. Like the tangent, the secant is a linear approximation of the behavior of $y = f(x)$, in the region of the points $x_0$ and $x_1$. As the new guess we will use the x-coordinate $x_2$ of the point at which the secant crosses the x-axis.  

The general form of the recurrence equation for the secant method is:  

\\[x_{i+1} = x_i - f(x_i)\frac{x_i - x_{i-1}}{f(x_i) - f(x_{i-1})}\\]  

Notice that we no longer need to know $f′$ but in return we have to provide *two* initial points, $x_0$ and $x_1$.

**Write a function that implements the secant algorithm.** Validate your program by finding the root of the function $f(x) = \cos(x) − x$. Compare its performance with that of the either the Newton-Raphson or the Fixed-point method -- which is faster, and by how much?

***Solution:***

Here is a working secant algorithm:

    secant <- function(fun, x0, x1, tol=1e-9, max_iter=100) {
        # Keep track of number of interations
        iter <- 0
        # Evaluate function at initial points
        f1 <- fun(x1)
        f0 <- fun(x0)
        # Loop
        while((abs(x1-x0) > tol) && (iter<max_iter)) {
            # Calculate new value
            x_new <- x1 -  f1*(x1 - x0)/(f1 - f0)
            # Replace old value with current
            x0 <- x1
            x1 <- x_new
            f0 <- f1
            f1 <- fun(x1)
            # Increment counter
            iter <- iter + 1
        }

        if (abs(x1-x0) > tol) {
            cat("Algorithm failed to converge\n")
            return(NA)
        } 
        else {
            cat("Algorithm converged in", iter, "iterations\n")
            return(x1)
        }
    }
    
For the function $\cos(x) - x$, the secant algorithm converged to 0.739 in 7 iterations with starting values 2,3. The fixed point algorithm for the equivalent function ($\cos(x)$) took 53 iterations from a starting value of 3.

### Question 2 ###

**15 points**

Import the HAART dataset (`haart.csv`) from the GitHub repository into R, and perform the following manipulations:

1. Convert date columns into a usable (for analysis) format.
2. Create an indicator variable (one which takes the values 0 or 1 only) to represent death within 1 year of the initial visit.
3. Use the `init.date`, `last visit` and `death.date` to calculate a followup time, which is the difference between the first and either the last visit or a death event (whichever comes first). If these times are longer than 1 year, censor them.
4. Create another indicator variable representing loss to followup; that is, if their status 1 year after the first visit was unknown.
5. Recall our work in class, which separated the `init.reg` field into a set of indicator variables, one for each unique drug. Create these fields and append them to the database as new columns.
6. The dataset `haart2.csv` contains a few additional observations for the same study. Import these and append them to your master dataset (if you were smart about how you coded the previous steps, cleaning the additional observations should be easy!).

***Solution***:

Here is one way of doing this:

    haart <- read.csv("haart.csv")

    clean_data <- function(haart) {
        # Convert dates
        haart$last.visit <- as.Date(haart$last.visit, format="%m/%d/%y")
        haart$init.date <- as.Date(haart$init.date, format="%m/%d/%y")
        haart$date.death <- as.Date(haart$date.death, format="%m/%d/%y")

        # Followup time
        # No deaths
        haart$followup <- as.integer(haart$last.visit - haart$init.date)
        # Deaths
        haart$followup[haart$death==1] <- as.integer(haart$date.death - 
            haart$init.date)[haart$death==1]
        # Truncate at 1 year
        haart$followup[haart$followup>365] <- 365
        # Loss to followup
        haart$ltf <- haart$followup<365 & !haart$death

        # Create variable containing array of drugs
        init.reg <- as.character(haart$init.reg)
        haart$init.reg.list <- strsplit(init.reg, ",")
        # Create unique list of drugs
        all_drugs <- unique(unlist(haart$init.reg.list))
        # Create matrix of drug membership
        reg_drugs <- c()
        for (drug in all_drugs) reg_drugs <- cbind(reg_drugs, 
            sapply(haart$init.reg.list, function(x) drug %in% x))
        # Turn into data frame
        reg_drugs.df <- data.frame(reg_drugs)
        # Use unique names as column headers
        names(reg_drugs.df) <- all_drugs
        # Merge with the rest of the data
        haart_merged <- cbind(haart, reg_drugs.df)

        return(haart_merged)
    }

    # Clean first dataset
    haart_clean <- clean_data(haart)
    # Import second dataset
    haart2 <- read.csv("haart2.csv")
    # Clean second dataset
    haart2_clean <- clean_data(haart2)
    # Merge using `merge` with all=TRUE
    haart_merged <- merge(haart_clean, haart2_clean, all=TRUE)


### Question 3 ###

**15 points**

The game of craps is played as follows. First, you roll two six-sided dice; let x be the sum of the dice on the first roll. If x = 7 or 11 you win, otherwise you keep rolling until either you get x again, in which case you also win, or until you get a 7 or 11, in which case you lose.

Write a program to simulate a game of craps. You can use the following snippet of code to simulate the roll of two (fair) dice:

    x <- sum(ceiling(6*runif(2)))

The instructor should be able to easily import and run your program (function), and obtain output that clearly shows how the game progressed.

***Solution***:

Here is an implementation that works:

    play_craps <- function() {

        roll <- function() sum(ceiling(6*runif(2)))

        cat("First roll ... ")
        point <- roll()
        if (point %in% c(7,11)) {
            cat("you rolled ", point, ", you win!\n", sep="")
        } 
        else {
            cat("point is set to", point,"\n")
        }
        while(TRUE) {
            cat("Another roll ... ")
            result <- roll()
            cat("you rolled ")
            if (result==point) {
                cat(point, ", you win!\n", sep="")
                return(TRUE)
            }
            else if (result %in% c(7,11)) {
                cat(result, ", you lose.\n", sep="")
                return(FALSE)
            }
            else {
                cat(result, ", roll again\n", sep="")
            }
        }

    }
    
Here is a sample game:

    > play_craps()
    First roll ... point is set to 9 
    Another roll ... you rolled 8, roll again
    Another roll ... you rolled 5, roll again
    Another roll ... you rolled 4, roll again
    Another roll ... you rolled 7, you lose.
    [1] FALSE

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