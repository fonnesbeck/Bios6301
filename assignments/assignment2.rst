=====================
Bios301: Assignment 2
=====================
September 26, 2011
------------------

Instructions
************

This assignment is due in electronic format on Monday, October 10, 2011 at Noon. Your completed work should be pushed to your private Bios301 repository on GitHub. I am interested in receiving code that I can run myself, in addition to your particular output (so, be sure your code runs as you expect!). There are 3 questions for a total of 30 points.

1. Import the HAART dataset (``haart1.csv``) [1]_ from the `GitHub repository`_ into R, and perform the following manipulations (10 points):

 a) Convert date columns into a usable (for analysis) format.
 b) Create an indicator variable (one which takes the values 0 or 1 only) to represent death within 1 year of the initial vist.
 c) Use the ``init.date``, ``last visit`` and ``death.date`` to calculate a followup time, which is the difference between the first and either the last visit or a death event (whichever comes first). If these times are longer than 1 year, censor them.
 d) Create another indicator variable representing loss to followup; that is, if their status 1 year after the first visit was unknown.
 e) Recall our work in class, which separated the ``init.reg`` field into a set of indicator variables, one for each unique drug. Create these fields and append them to the database as new columns.
 f) The dataset ``haart2.csv`` contains a few additional observations for the same study. Import these and append them to your master dataset (if you were smart about how you coded the previous steps, cleaning the additional observations should be easy!).

2. Repeat Question 1 using Stata (10 points).

3. Logistic regression in Stata: Load the Hosmer and Lemeshow coronary heart disease dataset (``chdage.dta``). You are presented with 2 variables (plus an ID code), age (``age``) and evidence of coronary heart disease (``chd``). Do the following, reporting all code and output (10 points):

 a) Create an age group variable, with the following categories: <30, 20-34, 35-39, 40-44, 45-49, 50-54, 55-59, 60+
 b) Generate a scatterplot of the data.
 c) Create a table that shows the data summarized by age group, along with a variable for the proportion of individuals with evidence of coronary heart disease. Plot this proportion as a function of age group.
 d) Run a logistic regression of chd as a function of age. In addition to output, report the covariance matrix of the coefficients. What is your interpretation of the influence of age on the response variable?

	
.. _GitHub repository: https://github.com/fonnesbeck/Bios301

.. [1] For reference, the variables in ``haart.csv`` are defined as follows:

- male: 1 if male, 0 otherwise
- age: Age at HAART initiation
- aids: 1 if AIDS prior to HAART initiation, 0 otherwise
- cd4baseline: CD4 measurement closest to HAART initiation; not more than 6 months prior to or 7 days after the date of starting HAART
- logvl: Log10-transformed HIV-1 plasma viral load measurement closest to HAART initiation; no more than 6 months prior to or 0 days after date of starting HAART
- weight: Weight in kg closest to HAART initiation within +/- 30 days
- hemoglobin: Hemoglobin (g/dL) closest to HAART initiation within +/- 30 days
- init.reg: Initial regimen
- init.date: Date of HAART initiation
- last.visit: Date of last visit
- death: 1 if died, 0 otherwise
- date.death: Date of death (NA if not applicable)