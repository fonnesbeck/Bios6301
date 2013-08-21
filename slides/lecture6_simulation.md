Simulation
==========

---

Stochastic Simulation
=====================

We often want to obtain a simulated result using a model system of interest.

Using artificially-generated *random numbers*, we can generate realizations of data that would be expected under a particular model.

Input: $\mathbf{X}\_i = (X_{1i}, \ldots, X\_{ki})$

Output: $\mathbf{Y}\_i = h(\mathbf{X}\_i)$

Analysis: 

$$Pr(h(\mathbf{X}) \le b) \approx \frac{1}{N} \sum_{i=1}^N I(h(\mathbf{X}\_i) \le b)$$
$$E(h(\mathbf{X})) \approx \frac{1}{N} \sum_{i=1}^N h(\mathbf{X}_i)$$

---

Random Numbers
==============

What is a ***random*** number?

How do we get random numbers?

Computers are intrinsically deterministic, so how are random numbers generated deterministically?

Presenter Notes
===============

No pattern?
Unpredictable?
True random numbers require actual unpredictability arising from genuinely physical processes such as radioactive decay, photon emissions or atmospheric noise

---

Pseudo-random Numbers
=====================

Computers cannot generate random numbers, only *pseudo*-random numbers.

* can be seeded at an arbitrary starting state and produce the same sequence each time.

We need a pseudo-random number generator (PRNG)

---

Middle Square Method
====================

An early algorithm by Von Neumann

1. specify a 10-digit number: 
    
        > x <- 5492364201
    
2. square the number (usually becomes a 20-digit number)

        > (y <- as.character(x**2))
        [1] "30166064516426366976"
    
3. take middle 10 digits as a random number

        > as.numeric(substring(y,5,15))
        [1] 60645164263

4. repeat as necessary

Presenter Notes
===============

The generated numbers are not random, but hard to predict.
not a good PRNG, due to short cycles.

---

Mersenne Twister Algorithm
==========================

Relatively new algorithm (1997)

* linear congruential generator
* period = $2^{19937}-1$

Algorithm:

* initialize $X\_0 \in \{0,1,\ldots,m-1\}$ 
* choose "big" numbers $A,B$  
* generate sequence of numbers via:

$$X\_{i+1} = (AX_i) + B \mod m$$

* divide numbers by *m* to get $X_i \in [0,1)$

For well-chosen A,B the sequence is indistinguishable from $U(0,1)$

---

Example: Mersenne-Twister
=========================

    !r
    > m <- 10; A <- 103; B <- 17; x <- 2
    > (x <- (A*x + B) %% m)
    [1] 3
    > (x <- (A*x + B) %% m)
    [1] 6
    > (x <- (A*x + B) %% m)
    [1] 5
    
`m=10` so maximum period is 10.

Better:

    !r
    > m <- 2^32; A <- 1644525; B <- 1013904223
    > x <- (A*x + B) %% m; x/m
    [1] 0.2361584
    > x <- (A*x + B) %% m; x/m
    [1] 0.6237401
    > x <- (A*x + B) %% m; x/m
    [1] 0.3757933

---

Random Number Seed
==================

The sequence of pseudo-random numbers depends on the initial condition,
or seed. 

In R, it is stored in `.Random.seed`, a global variable. To reproduce
results exactly, set the seed:

    !r
    > old.seed <- .Random.seed # Store the seed
    > set.seed(20090425)  # Set it to son's bday
    > runif(2)
    [1] 0.54952918 0.08113291
    > set.seed(20090425)  # Reset it
    > runif(2)
    [1] 0.54952918 0.08113291
    > .Random.seed <- old.seed  # Restore old seed
    
`runif()` generates uniform random variables according to the selected PRNG:

    !r
    > RNGkind()
    [1] "Mersenne-Twister" "Inversion" 
    > RNGkind('Wich')
    > RNGkind()
    [1] "Wichmann-Hill" "Inversion" 

---

Generating True Random Numbers
==============================

![ranodm.org](http://d.pr/i/42tP+)

Presenter Notes
===============

Gathers atmospheric noise via a radio-receiver card tuned to an unused frequency and connected to a computer where it is sampled and digitized.

---

Package `random`
================

Accesses the true random number service at http://random.org.

* `randomNumber` retrieves random integers with duplicates
* `randomSequence` retrieves random sequences without duplicates
* `randomStrings` retrieves strings

Requires an internet connection!

    !r
    > library(random)
    > randomNumbers(10, 1, 100)
         V1 V2 V3 V4 V5
    [1,] 65 47 58 19 39
    [2,] 67 50 14 55 62
    > randomStrings(5, 10)
         V1          
    [1,] "45uvtdAEjp"
    [2,] "MNsAXi0UYD"
    [3,] "bBF8oin409"
    [4,] "QSJJCnp2Uo"
    [5,] "ltWlBUFTKQ"



---

Generating Discrete Random Variables
====================================

If we know the cumulative mass function (CMF), we can generate pseudorandom draws using $U(0,1)$ realizations.

Given CMF *F*:

1. Initialize $x\_0 = 0$
2. Generate $u \sim U(0,1)$
3. While $F(x\_i) < u$, increment $x\_{i+1} = x\_i + 1$

Stop for first value of $x\_i$ that has cumulative probability greater than sampled uniform.

---

Example: Binomial
=================

The binomial distribution:

$$f(x|p) = {n \choose x} p^x (1-p)^{n-x}$$

We calculate the CMF of the binomial distribution by summing over the PMF:

    !r
    binom_cdf <- function(x, n, p) {
        Fx <- 0
        for (i in 0:x) {
            Fx <- Fx + choose(n, i) * p^i * (1-p)^{n-i}
        }
        return(Fx)
    }
    
Now, we can use this code to generate binomial variates from a uniform draw:

    !r
    gen_variate <- function(F, ...) {
        x <- 0
        u <- runif(1)
        while (F(x, ...) < u) x <- x + 1
        return(x)
    }


---

Example: Binomial
=================

    !r
    > x <- numeric(100)
    > for (i in 1:100) x[i] <- gen_variate(binom_cdf, 10, 0.25)
    > hist(x, prob=T)
    > lines(0:10, dbinom(0:10,10,0.25))

![binomial histogram](http://d.pr/i/nqWU+)

---

Exercise
========

Can you come up with a simple, vectorized function for generating samples from a binomial distribution?

*Hint*: take advantage of the fact that a binomial variable is the sum of *n* Bernoulli random variables.

Presenter Notes
===============

    sum(runif(n) < p)

---

Example: Geometric random variables
===================================

The geometric distribution models the number of "failure" events expected before a "success" event occurs.

* e.g. the number of heads expected from a fair coin before tails appears.

        !r
        geom_sample <- function(p) {
            x <- 0
            success <- FALSE
            while (!success) {
                u <- runif(1)
                if (u < p) {
                    success <- TRUE
                } else {
                    x <- x + 1
                }
            }
            return(x)
        }

---

Simulating Continuous Variables
===============================

### Cumulative Distribution Function (CDF)

$$F\_X(x) = Pr(X \le x)$$

so, $U = F(x) \in (0,1)$. 

![cdf](http://upload.wikimedia.org/wikipedia/commons/b/ba/Exponential_cdf.svg)

---

Inverse Transform Method
========================

We claim that $X = F^{−1}(U)$ is a random variable with CDF *F*.

$$ P(X \le x) = P(F^{-1}(U) \le x) = P(U \le F(x)) = F(x) $$

So if we can generate uniforms and we can calculate quantiles, we can generate non-uniforms!

This is the ***quantile transform method***, or ***inverse transformation method***.

---

Example: exponential distribution
=================================

$$X \sim \text{Exp}(\lambda)$$
$$f\_X(x) = \lambda \exp(-\lambda x)$$
$$F\_X(x) = 1 - e^{-\lambda x}, \, x \ge 0$$

Solve $F$ for $x$:

$$y = 1 - e^{-\lambda x}$$
$$x = -\frac{1}{\lambda} \log(1-y) = F^{-1}(y)$$

---

Example: exponential distribution
=================================

    !r
    > f <- function(x,lam) -1/lam * log(1-x)
    > hist(f(runif(1000), 3), prob=T, xlab="x", main="")
    > lines((1:300)/100, dexp((1:300)/100, 3))
    
![exponential example](http://d.pr/i/s0vm+)

---

Rejection Method
================

We can only use the inverse CDF method if we can calculate $F\_X^{-1}$. 

$F\_X$ can be inverted numerically, using root-finding methods, but this is inefficient.

One alternative approach is the *rejection method*.

Imagine a function with support on some interval $[a,b]$, and for which we can calculate a maximum value, $m = \max(f(x))$.

* simulate points uniformly on $(x, f(x))$:

$$ x \sim U(a,b) $$
$$ f(x) \sim U(0, m) $$

* reject points that fall above the function; remaining points are a sample from $f(x)$.

---

Rejection Method
================

![rejection](http://d.pr/i/nmuj+)

---

Rejection Method
================

How do we know this simple approach works?

$$ \begin{aligned} Pr(a \lt X \lt b) &= Pr(\text{Point sampled under curve}) \\\
&= \frac{\text{Area under curve}}{\text{Area of sampling frame}} \\\
&= \frac{\int\_a^b f(x)\,dx}{1} \\\
&= \int\_a^b f(x)\,dx
\end{aligned}$$

The *efficiency* of the method depends on the ratio of the function's area to the area of the sampling frame.

---

Example: Triangular distribution
================================

Consider the triangular pdf:

$$f(x) = \left\\{ \begin{array}{ll}
x & \text{if } \, 0 \lt x \lt 1 \cr
2-x & \text{if } \, 1 \le x \lt 2 \cr
0 & \text{otherwise}\end{array}\right.$$

![triangular distribution](http://d.pr/i/3b6g+)

---

Example: Triangular distribution
================================

The triangular pdf:

    !r
    triangular <- function(x){
        if ((0<x) && (x<1)) {
            return(x)
        } else if ((1<x) && (x<2)) {
            return(2-x)
        } else {
            return(0)
        }
    }
   
A function to sample a single realization from `fx` using rejection sampling:

    !r
    rejectionK <- function(fx, a, b, K) {
        while (TRUE) {
            x <- runif(1, a, b)
            y <- runif(1, 0, K)
            if (y < fx(x)) return(x)
        }
    }

---

Example: Triangular distribution
================================

![triangular sample](http://d.pr/i/imB7+)

---

Simulating Normal Variates
==========================

With a standard normal random variable, we can transform to an arbitrary normal:

$$N(\mu, \sigma^2) = \mu + \sigma z$$

where $z \sim N(0,1)$.

A simple approach for generating standard normals is to use the central limit theorem to average uniform draws.

For $U \sim \text{Unif}(0,1)$, $E(U) = 1/2$, $\text{Var}(U)=1/12$. Then:

$$Z = \left(\sum\_{i=1}^{12} U\_i \right) - 6$$

is approximately $N(0,1)$.

Presenter Notes
===============

Inefficient:: 12 draws to generate one realization

---

Box-Muller Algorithm
====================

Consider a *bivariate* standard normal variable:

$$ (X,Y) \stackrel{iid}{\sim} N(0,1)$$

Box-Muller simulates $(X,Y)$ in polar coordinates, then transforms them to Cartesian coordinates:

$$X = R \cos(\theta)$$
$$Y = R \sin(\theta)$$

It can be shown that:

$$R^2 \sim \text{Exp}(1/2)$$
$$\theta \sim \text{Unif}(0,2\pi)$$

---

Box-Muller Algorithm
====================

Algorithm:

1. Generate $U_1, U_2 \sim \text{Unif}(0,1)$
2. Calculate $\theta = 2\pi U_1$, $R = \sqrt{-4\log(U_2)}$
3. Transform $X = R \cos(\theta)$, $Y = R \sin(\theta)$

### Exercise ###

Write a function to generate $n$ variables distributed $N(\mu,\sigma^2)$, using the Box-Muller algorithm.

---

Built-in Random Number Generators
=================================

R includes random number generators for the most common distributions: `runif`, `rnorm`, `rbinom`, `rpois`, `rexp`, etc.

First argument is always `n`, number of variates to generate.

Subsequent arguments are parameters corresponding to the distribution:

    !r
    > rnorm(n=5, mean=3, sd=4)
    [1] 0.7746440 5.4040651 5.6239049 1.0021728 0.5369644
    > rbinom(n=5, 10, 0.3)
    [1] 0 4 5 5 3

---

Bootstrapping
=============

Bootstrapping (Efron 1977) is a prominent simulation method in modern statistics. It is a *resampling* method for deriving a sampling distribution for a statistic. It can be used to obtain:

* standard errors
* percentile points
* proportions
* odds ratios
* correlation coefficients

Bootstrapping uses sample data as a population from which new samples are drawn.

![bootstrap](images/bootstrap.png)

---

Classical Inference
===================

The sample $S$ is a simple or independent sample from $P$:

$$ P = \{x\_1, x\_2, \ldots, x\_N\}$$
$$\text{(population)}$$

$$ S = \{x\_1, x\_2, \ldots, x\_n\}$$
$$\text{(sample)}$$

We wish to make some inference regarding a population parameter, based on a statistical estimate:

$$ \theta = h(P)$$
$$\text{(population parameter)}$$

$$ T = h(S)$$
$$\text{(estimate)}$$

Presenter Notes
===============

make assumptions about pop. structure
use assumptions to derive sampling distribution for T

---

Problems
========

Classical inference can be **non-robust**:

* inaccurate if parametric assumptions are violated
* if we rely on asymptotic results, we may not achieve an acceptable level of accuracy

Classical inference can be **difficult**:

* derivation of sampling distribution may not be possible

An alternative is to estimate the sampling distribution of a statistic *empirically* without making assumptions about the form of the population.

---

Non-parametric Bootstrap
========================

Bootstrap sample:

$$S\_1^\* = \{x\_{11}^\*, x\_{12}^\*, \ldots, x\_{1n}^\*\}$$

$S\_i^*$ is a sample of size $n$, with replacement.

In R, the function `sample` draws draw random sample of size points from x, optionally with replacement and/or weights:

    !r
    sample(x, size, replace=FALSE, prob=NULL)

`x` can be anything with a `length`; sample(x) does a random permutation.

    !r
    > sample(c(-1,14,3,6,-3))
    [1] -1  6 -3  3 14
    > sample(5)
    [1] 5 1 4 2 3
    > sample(5, replace=T)
    [1] 4 4 3 1 2
    

---

Bootstrap sample
================

In R:

    !r
    > x <- rnorm(10)

    > x
     [1] -0.92808680  0.09901648  0.23525382  0.62914907  0.08515775 -0.42132747
     [7] -1.05194033 -0.71576518  0.21399354  0.82478246

    > sample(x, 10, replace=TRUE)
     [1] -0.71576518  0.62914907 -1.05194033 -1.05194033  0.09901648 -0.92808680
     [7] -0.42132747 -0.92808680 -0.92808680 -1.05194033

Presenter Notes
===============

We regard S as an "estimate" of population P
population : sample :: sample : bootstrap sample

---

Non-parametric Bootstrap
========================

Generate replicate bootstrap samples:

$$S^\* = \{S\_1^\*, S\_2^\*, \ldots, S\_R^\*\}$$

Compute statistic (estimate) for each bootstrap sample:

$$T\_i^\* = t(S^*)$$

---

Example
=======

    !r
    > x <- rnorm(10)
    > s <- numeric(1000)
    > for (i in 1:1000) s[i] <- mean(sample(x, 10, replace=TRUE))
    > hist(s, xlab="Bootstrap means", main="")
    
![bootstrap means](http://d.pr/i/LAVF+)

---

Exercise
========

Re-formulate the previous example using an `apply` function, rather than a `for` loop.

---

Bootstrap Estimates
===================

From our bootstrapped samples, we can extract *estimates* of the expectation and variance:

$$\bar{T}^\* = \hat{E}(T^\*) = \frac{\sum\_i T\_i^\*}{R}$$

$$\hat{\text{Var}}(T^\*) = \frac{\sum\_i (T\_i^\* - \bar{T}^\*)^2}{R-1}$$

Since we have estimated the expectation of the bootstrapped statistics, we can estimate the **bias** of T:

$$\hat{B}^\* = \bar{T}^\* - T$$

Presenter Notes
===============

estimate of T - theta

---

Error
=====

There are two sources of error in bootstrap estimates:

1. **Sampling error** from the selection of $S$.
2. **Bootstrap error** from failing to enumerate all possible bootstrap samples.

---

Bootstrap Confidence Intervals
==============================

We can use the bootstrap estimates of sampling variance and bias, and by applying normal theory, estimate confidence intervals for statistic $T$:

$$ (T-\hat{B}^\*) \pm z_{1-\alpha/2} \sqrt{\widehat{\text{Var}}(T^\*)}$$

---

Bootstrap Percentile Intervals
==============================

An alternative approach is to use the empirical quantiles of the bootstrapped statistics. This employs the *ordered* bootstrap replicates:

$$T\_{(1)}^\*, T\_{(2)}^\*, \ldots, T\_{(R)}^\*$$

Simply extract the $100(\alpha/2)$ and $100(1-\alpha/2)$ percentiles:

$$T\_{[(R+1)\alpha/2]}^\* \lt \theta \lt T\_{[(R+1)(1-\alpha/2)]}^\*$$

Presenter Notes
===============

Square brackets indicate rounding to nearest integer.

---

Bias-corrected Interval
=======================

Though they do not assume normality, percentile intervals do not generally perform well.

### Bias-corrected, Accelerated Percentile Intervals

**Step 1**:

Calculate standard normal quantile at the adjusted proportion of bootstrap replicates below the original sample estimate:

$$z = \Phi^{-1}\left[\frac{\sum\_{i=1}^R I(T\_i^\* \le T)}{R+1}\right]$$

* if sampling distribution is symmetric, and $T$ is unbiased, this proportion will be close to 0.5 (z close to zero).

---

Bias-corrected Interval
=======================

**Step 2**:

Let $T\_{(-j)^\*}$ be the value of $T$ with the *j*th observation held out, and $\bar{T}$ be the average of these holdout estimates. Then,

$$a = \frac{\sum\_{j=1}^n(T\_{(-j)}^\* - \bar{T})^3}{6[\sum\_{j=1}^n(T\_{(-j)}^\* - \bar{T}^2)]^{3/2}}$$

We now have two correction factors, $z$ and $a$.

---

Bias-corrected Interval
=======================

**Step 3**:

Now, calculate adjusted indices to extract endpoints of the interval:

$$a\_1 = \Phi\left[z + \frac{z - z\_{1-\alpha/2}}{1-a(z - z\_{1-\alpha/2})}\right]$$
$$a\_2 = \Phi\left[z + \frac{z + z\_{1-\alpha/2}}{1-a(z + z\_{1-\alpha/2})}\right]$$

The corrected interval is:

$$T\_{[R \cdot a\_1]}^\* \lt \theta \lt T\_{[R \cdot a\_2]}^\*$$

Presenter Notes
===============

- when z and a are both zero, corresponds to uncorrected percentile interval
- R should be on the order of 1000 or more for accuracy

---

Package `boot`
==============

`boot` provides functions for bootstrapping and related resampling methods.


    !r
    > x <- rnorm(10)
    > med <- function(x,i) median(x[i])
    > (bmed <- boot(x, med, R=999))

    ORDINARY NONPARAMETRIC BOOTSTRAP


    Call:
    boot(data = x, statistic = med, R = 999)


    Bootstrap Statistics :
         original     bias    std. error
    t1* 0.1315997 0.08225485   0.4112328
    > boot.ci(bmed)
    BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
    Based on 999 bootstrap replicates

    CALL : 
    boot.ci(boot.out = bmed)

    Intervals : 
    Level      Normal              Basic         
    95%   (-0.7567,  0.8553 )   (-0.8329,  0.7465 )  

    Level     Percentile            BCa          
    95%   (-0.4833,  1.0961 )   (-0.4833,  1.0961 )  
    

---

Example: Anorexia data
======================

![Anorexia data](http://d.pr/i/oCsq+)

---

Normal?
=======

![qqplot](http://d.pr/i/yMkp+)

---

Example: Anorexia data
======================

Let's calculate a bootstrapped confidence interval for pre-treatment weights:

    !r
    > data(anorexia, package='MASS')
    > weight <- anorexia$Prewt
    > bmeans <- numeric(999)
    > for (i in 1:999) {
    + s <- sample(weight, replace=T)
    + bmeans[i] <- mean(s)
    + }
    > quantile(bmeans, c(0.025, 0.975))
        2.5%    97.5% 
    81.16104 83.53951  
    
Compare to parametric CI, and `boot`:

    !r
    > mean(weight, na.rm=T) - 1.96*sd(weight, na.rm=T)/sqrt(length(weight))
    [1] 81.21124
    > mean(weight, na.rm=T) + 1.96*sd(weight, na.rm=T)/sqrt(length(weight))
    [1] 83.60542
    > weight_boot <- boot(weight, function(x,i) mean(x[i]), R=999)
    > quantile(weight_boot$t, c(0.025, 0.975))
        2.5%    97.5% 
    81.26222 83.49688 

---

Estimating Coverage Probability
===============================

*Coverage probability* is the proportion of time that a calculated confidence interval contains the true parameter value.

* we hope it is the same as the nominal probability!

Several ways of calculating confidence intervals:

* Bootstrap Intervals 
* Theoretical Intervals 
* Asymptotic Intervals

All confidence intervals are interpreted in light of assumptions:

* data are generated via a model
* $n \rightarrow \infty$

What happens when assumptions are violated? Robust?

---

Estimating Coverage Probability
===============================

We can use simulation to assess an interval's coverage probability.

* Repeat:
    1. Sample data from a statistical model, with known parameters
    2. Calculate CI for simulated data
    3. Test whether calculated interval includes parameter
* Calculate proportion of times interval contained parameter

---

R code
======

Calculating the coverage probability for normal bootstrap interval:

    !r
    true_mu <- 0
    x <- rnorm(100, true_mu)
    R <- 999
    
    lower <- numeric(R)
    upper <- numeric(R)
    
    for (i in 1:R) {
    
        s <- x[sample(length(x), replace=TRUE)]
        xbar <- mean(s)
        s <- sd(s)
        
        lower[i] = xbar + qnorm(0.025) * (s / sqrt(length(x)))
        upper[i] = xbar + qnorm(0.975) * (s / sqrt(length(x)))
    }
    
    > mean(lower < true_mu & upper > true_mu)
    [1] 0.9459459
    
---

Exercise
========

Find the coverage probability for bootstrap percentile intervals of the following model:

$$y \sim \text{Gamma}(7,5)$$

<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    extensions: ["tex2jax.js"],
    jax: ["input/TeX", "output/HTML-CSS"],
    tex2jax: {
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
      processEscapes: true
    },
    "HTML-CSS": { availableFonts: ["TeX"] }
  });
</script>
<!--<script type="text/javascript"
    src="../MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>-->
<script type="text/javascript"
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>