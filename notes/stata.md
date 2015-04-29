# Introduction to Stata (In 2 hours or less)

## Organization

Stata uses the current working directory as the project folder. All files will be opened/saved to/from here.

Projects are portable, so they work on different operating systems without a problem.

We can move to a directory using the menu item, or via the `cd` command:

    cd "/Users/fonnescj/Bios6301/STATA"

The working directory is shown in the status bar at the bottom of the application.

## Log File

Log files can be created to record everything that appears in the results window:

```bash
. log using "startup"

      name:  <unnamed>
       log:  /Users/fonnescj/Bios6301/STATA/startup.smcl
  log type:  smcl
 opened on:  28 Nov 2012, 10:08:24
```   
    
* quotes optional when no spaces in filename

Log files written in Stata Markup and Control Language (SMCL).

Stata shows if you have a log file open in status bar.

If you try to use a log file that already exists, Stata will complain. Need to specify whether to overwrite or append to the existing file:

```bash
. log using "startup", replace
. log using "startup", append
```

### Comments

Comments can be added to the log file using the asterisk:

```bash
. * everything after an asterisk is ignored by Stata
```

## Looking at Your Data

To become familiar with the interface, load an example database:

```bash
. sysuse auto.dta
(1978 Automobile Data)
```
   
Stata loads the data into memory.

Calling `browse` opens the data browser; `edit` browses in edit mode.

* variables colored red are text-formatted
* missing values are represented

You can jump to a specific variable and observation by typing them into the location box. For example:

```bash
foreign 45
```
 
jumps to the 45th observation of the variable `foreign`.

The `codebook` command gives the details about the structure and contents of the current dataset.

* hit `enter` to show the next line of output
* hit `q` to stop showing output
* hit any other key to show the next screen of output

Some variables show frequency tables, while some show summary statistics.

* summary stats are shown if there are at least 9 distinct values

You can display subsets of the dataset by specifying variables and using the `if` clause:

```bash
. codebook headroom length if foreign
```


Stata allows notes to be attached to variables and entire datasets. Calling `notes` displays these.

```bash    
. notes

_dta:
  1.  from Consumer Reports with permission
```
 

Summary statistics can be displayed with `summarize`:

```bash
. summarize

    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
        make |         0
       price |        74    6165.257    2949.496       3291      15906
         mpg |        74     21.2973    5.785503         12         41
       rep78 |        69    3.405797    .9899323          1          5
    headroom |        74    2.993243    .8459948        1.5          5
-------------+--------------------------------------------------------
       trunk |        74    13.75676    4.277404          5         23
      weight |        74    3019.459    777.1936       1760       4840
      length |        74    187.9324    22.26634        142        233
        turn |        74    39.64865    4.399354         31         51
displacement |        74    197.2973    91.83722         79        425
-------------+--------------------------------------------------------
  gear_ratio |        74    3.014865    .4562871       2.19       3.89
     foreign |        74    .2972973    .4601885          0          1

```

## Manipulating data

Let's make a new variable, by converting miles per gallon to gallons burned per 100 miles driven:

```bash
. generate gp100m = 100/mpg
```

If we want to save this dataset with the new variable, we can do so at any time:

```bash
. save autoxtra
file autoextra.dta saved
```

You can load this dataset at any time using `load`:

```bash
. use autoextra
(1978 Automobile Data)

```

If there is an unsaved dataset already loaded, Stata will complain. You either have to save the current dataset, or give the `clear` command.

There are a handful of rules to naming variables:

1. Must start with letter or underscore (avoid underscores!)
2. Must include either letters, numbers or underscores
3. Case-sensitive
4. No spaces
5. Maximum 32 characters long

Use `describe` to look at the structure of a dataset. Displays:

* names
* data types
* display formatting
* labels
* dataset statistics

Details of various display formats can be found by entering `help format`.

![help format](http://d.pr/i/CFFG+)

Stata can only load one dataset at a time into memory (!). However unfortunate, this is one of the things that makes Stata fast. Stata recommends starting another instance of Stata to look at a second dataset (!).

## Syntax

Stata's syntax is consistent and uniform, either within type or across models.

Typical form of Stata commands:

```bash
command [varlist] [if] [in] [weight] [, options]
```

The command is followed by clauses (standard part) and options (option part).

* clauses in standard part are typical across many commands
* options tend to be command-specific

To see the help file for any command, type `help` followed by the command in question:

```bash
. help codebook
```

![help codebook](http://d.pr/i/B6kc+)

Commands and options can be abbreviated; Underlined portion of a command or option is the minimum abbreviation to avoid collisions.

For example, for `describe`, any shortening beginning with `d` is allowable. To display the `weight` variable in the auto parts database, we may simply type:

```bash
. d w
```

Note that this shorthand comes at the expense of readability (*e.g.* `summary` to `sum` can be confusing). 

Stata recognizes *wildcard* characters; most commonly, the asterisk represents 0 or more characters anywhere in the name. Less commonly, the question mark represents exactly one character.

For example:

```bash
. describe m* *t

              storage  display     value
variable name   type   format      label      variable label
-----------------------------------------------------------------------------------------
make            str18  %-18s                  Make and Model
mpg             int    %8.0g                  Mileage (mpg)
weight          int    %8.0gc                 Weight (lbs.)
displacement    int    %8.0g                  Displacement (cu. in.)

```

Ranges of variables can be represented using a dash between the inclusive endpoint variables. The range follows the order of variables as represented in the dataset:

```bash

. sum headroom - displacement

    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
    headroom |        74    2.993243    .8459948        1.5          5
       trunk |        74    13.75676    4.277404          5         23
      weight |        74    3019.459    777.1936       1760       4840
      length |        74    187.9324    22.26634        142        233
        turn |        74    39.64865    4.399354         31         51
-------------+--------------------------------------------------------
displacement |        74    197.2973    91.83722         79        425

```

## Clauses

We can specify a particular subset of our dataset using the `if` and `in` qualifiers.

* `in` extracts a subset based on observation number
* `if` extracts a subset based on the values of an expression

For example, to list the first 5 values of `make` and `mpg` in our sample dataset:

```bash

. list make mpg in 1/5

     +---------------------+
     | make            mpg |
     |---------------------|
  1. | AMC Concord      22 |
  2. | AMC Pacer        17 |
  3. | AMC Spirit       22 |
  4. | Buick Century    20 |
  5. | Buick Electra    15 |
     +---------------------+

```

If we want to see which foreign cars have poor gas mileage:

```bash
. list make mpg if mpg<20 & foreign

     +---------------------+
     | make            mpg |
     |---------------------|
 53. | Audi 5000        17 |
 64. | Peugeot 604      14 |
 67. | Toyota Celica    18 |
 69. | Toyota Corona    18 |
 74. | Volvo 260        17 |
     +---------------------+

```

What if we only want to see the Oldsmobile make?

```bash
. list make mpg if strpos(make, "Olds")>=1

     +----------------------+
     | make             mpg |
     |----------------------|
 35. | Olds 98           21 |
 36. | Olds Cutl Supr    19 |
 37. | Olds Cutlass      19 |
 38. | Olds Delta 88     18 |
 39. | Olds Omega        19 |
     |----------------------|
 40. | Olds Starfire     24 |
 41. | Olds Toronado     16 |
     +----------------------+

```

Here, the `strpos` function returns the character position of a substring within a larger string.

However, the following produces unexpected results:

```bash
. browse make price rep78 if rep78>=4
```

![browse missint](http://d.pr/i/sofl+)

We see here that missing values are counted as being greater than or equal to 4! In Stata, missing numbers are regarded as the largest number.

To ignore missing data, we need to add an additional clause to the `if` statement:

```bash
. browse make price rep78 if rep78>=4 & !missing(rep78)
```

**How else could we have excluded missing data from this statement?**

## Operators

The exclamation mark (!) and ampersand (&) are examples of logical operators, meaning "not" and "and", respectively.

* `!` = not
* `&` = and
* `|` = or

There are also **relational** operators:

* `>=` : at least
* `>` : greater than
* `==` : equal to
* `<` : less than
* `<=` : at most
* `!=` : not equal to

Stata also implements the standard arithmetic operators.

There are no "true" and "false" (boolean) data types. Zero is considered false and all non-zero values (including missing values) are considered true.

```bash

. summarize mpg if foreign

    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
         mpg |        22    24.77273    6.611187         14         41

```

## Dataset Clean-up

To illustrate how to use Stata to clean up a dataset, load the `haart_stata.csv` dataset in the `datasets` directory on GitHub. Some of the variable names have been changed from `haart.csv` to make them compatible with Stata's rules.

We can import spreadsheet-type data using `insheet`, passing the separator type (comma) and an indicator for a names header as options:

```bash
. insheet using "/Users/fonnescj/Bios6301/datasets/haart.csv", comma names
(12 vars, 1000 obs)

```

There are a few issues with the dataset:

* the missing value `NA` is not compatible with Stata
* the dates are imported as strings; they need to be converted to numeric dates
* the `initreg` variable need to be converted to a more usable representation

If we want to add notes to the variable or the dataset, we can use the `notes` command:

```bash

. notes: "HAART patient database"

. notes male: "Patient is male: 0=False, 1=True"

. notes

_dta:
  1.  "HAART patient database"

male:
  1.  "Patient is male: 0=False, 1=True"

```

The `male` variable is *categorical* in type. It is useful to encode this (similar to a "factor" in R). We can do this by attaching a label that associates zero with female and one with male.

First, create a label:

```bash

. label define ismale 0 "Female" 1 "Male"

```

This label, though it seems obviously related to the `male` variable, has not been associated with anything. We use `label values` syntax to do so:

```bash
. label values male ismale

. browse

```

![labels](http://d.pr/i/UulP+)

Notice that the labels have been substituted for integers, and the color of the variable has turned blue, indicating a categorical variable.

To list the labels that have been created (but not necessarily associated with variables), use the `labelbook` function.

An alternative way to treat this variable is to convert it to a string and use automatic encoding. `encode` turns a string variable into a categorical variable.

```bash
. tostring(male), generate(gender)
gender generated as str1

. replace gender="female" if gender=="0"
gender was str1 now str6
(373 real changes made)

. replace gender="male" if gender=="1"
(627 real changes made)

. encode gender, generate(_gender)

. drop gender

. rename _gender gender

```


Notice that several numeric variables are red, indicating string format. This is because they contain `NA` values, which Stata does not recognize as missing values.

For example, to convert `cd4baseline` to a proper numeric variable, we need to first remove the `NA`'s then cast the variable to the `REAL` type:

```bash
. replace cd4baseline="" if cd4baseline=="NA"
(150 real changes made)

. gen _cd4 = real(cd4baseline)
(150 missing values generated)

. drop cd4baseline

. rename _cd4 cd4baseline

```

The last 3 steps can be automated using the `destring` function. Let's use this function to clean up the `aids` variable:

```bash
. replace aids="" if aids=="NA"
(14 real changes made)

. destring aids, replace
aids has all characters numeric; replaced as byte
(14 missing values generated)

```

Notice that the new `cd4baseline` variable was moved to the end of the table. We may want to move it back where it was.

```bash
. order cd4baseline, after(aids)
```

### Dates

When dates are imported to Stata, they are automatically stored as strings. In order to perform operations on dates, they must be turned into a numeric date type.

There are two steps:

1. Convert to numeric date using `date`
2. Apply formatting for readability

The date function takes a string date and a format pattern as arguments. Let's take the `initdate` variable, which is stored in *month/day/year* format. One issue is that the year is encoded with just two digits.

Here is the conversion:

```bash
. generate initdate_numeric = date(initdate, "MDY", 2020)

. list initdate* in 1/5

     +---------------------+
     | initdate   initda~c |
     |---------------------|
  1. |   7/1/03      15887 |
  2. | 11/23/04      16398 |
  3. |  4/30/03      15825 |
  4. |  3/25/06      16885 |
  5. |   9/1/04      16315 |
     +---------------------+


```

The third argument for `date` is the latest date in the set. So, any dates with years like 98 or 99 will correctly be interpreted as 1998 and 1999, respectively

The new variable is numeric, but as we can see, not human-readable. To properly format the date:

```bash
. format %td initdate_numeric

. list initdate* in 1/5

     +----------------------+
     | initdate   initdat~c |
     |----------------------|
  1. |   7/1/03   01jul2003 |
  2. | 11/23/04   23nov2004 |
  3. |  4/30/03   30apr2003 |
  4. |  3/25/06   25mar2006 |
  5. |   9/1/04   01sep2004 |
     +----------------------+


```

Alternatively, we can use a more standard format:

```bash
. format %tdMon_dd,_CCYY initdate_numeric

. list initdate* in 1/5

     +-------------------------+
     | initdate   initdate_n~c |
     |-------------------------|
  1. |   7/1/03    Jul 1, 2003 |
  2. | 11/23/04   Nov 23, 2004 |
  3. |  4/30/03   Apr 30, 2003 |
  4. |  3/25/06   Mar 25, 2006 |
  5. |   9/1/04    Sep 1, 2004 |
     +-------------------------+

```

There are a large number of time and date formats, are listed in `help format`.

Now, we simply replace the raw, string date with the new numeric date:

```bash
. drop initdate

. rename initdate* intitdate

```

 
### Example: Parsing drug lists in HAART data

Finally, let's convert the drug regimen (`initreg`) variable by turning each drug into an indicator variable, as we did in R.

First, we need a unique identifier for each patient. Since most patients have several associated drugs, we will need to be able to associate an occurrence of each drug with a patient.

```bash
gen id = _n
```

Now, turning our attention to `initreg`, we split each entry on commas, and generate variables for them:

```bash
split initreg, p(",") gen(drug)
variables created as string: 
drug1  drug2  drug3  drug4  drug5
```
So, each drug has the prefix `drug` followed by the numeric order of the drug in a patient's particular regimen. Apparently, there are at most 5 drugs per patient.

Notice that our table now has a partial wide format; we need to convert it to a long table with a column for drug:

```bash
reshape long drug, i(id)
(note: j = 1 2 3 4 5)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                     1000   ->    5000
Number of variables                  21   ->      18
j variable (5 values)                     ->   _j
xij variables:
                  drug1 drug2 ... drug5   ->   drug
-----------------------------------------------------------------------------

```

The option in this case is not actually "optional", as it specifies the unique identifier that is required to associate drugs with patients.

The basic syntax for going from wide to long:

```bash
reshape long <prefixes>, i(<keyvarlist>) [j(<seqvarname>)]
```

The "prefixes" refer to the prefixes of the repeated variables of the wide dataset, the "keyvarlist" is the key(s) in the wide dataset, and the optional "seqvarname" represents the numeric suffixes in the wide dataset.

Note that after reshaping, Stata retains the information it needs to switch back and forth between formats, so:

```bash
. reshape wide

. reshape long
```

do not require prefixes or other options.

We now need a unique list of drugs to use to create columns. Stata allows for the creation of arbitrary "floating" variables that are not associated with the dataset, called "macros":

```bash
levelsof drug, local(druglevels)
```

We use this macro list in a loop to create indicator variables:

```bash
foreach d of local druglevels {
  egen drug_`d' = max(drug=="`d'"), by(id)
}
```

The command `egen` creates new variables according to the passed function.

Finally, we reshape back to the wide format, and delete the extraneous `drug` variables:

```bash
. reshape wide
(note: j = 1 2 3 4 5)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                     5000   ->    1000
Number of variables                  36   ->      39
j variable (5 values)                _j   ->   (dropped)
xij variables:
                                   drug   ->   drug1 drug2 ... drug5
-----------------------------------------------------------------------------

. drop drug1-drug5

. drop initreg*

. browse
```

![drugs](http://d.pr/i/fZuh+)

## Data Manipulation

We have seen how to clean up a dataset, which involves some manipulation of the original data, but we often want to make entirely new variables that are functions of existing variables.

For this exercise, we will use the example census dataset, which is state-wise data from the 50 US states in 1980. It includes information on population size, age, and events such as death, marriage and divorce:

```bash

. sysuse census
(1980 Census data by state)

```

The main command for creating new variables, as we have seen, is `generate`, often abbreviated to `gen`. Let's create a variable that is simply the proportion of residents who live in urban areas:

```bash
. gen prop_urban = popurban/pop

. sum prop_urban, detail

                         prop_urban
-------------------------------------------------------------
      Percentiles      Smallest
 1%     .3377319       .3377319
 5%     .4643773       .3617681
10%     .4774035       .4643773       Obs                  50
25%     .5411116       .4732155       Sum of Wgt.          50

50%      .670646                      Mean           .6694913
                        Largest       Std. Dev.      .1440956
75%     .8030769       .8651392
90%     .8496912       .8699789       Variance       .0207635
95%     .8699789       .8903645       Skewness      -.2422186
99%     .9129498       .9129498       Kurtosis       2.285554

```

Notice the mean proportion of 0.67. IS this a reasonable estimate of the proportion living in cities? No, because it is an average of averages; we need a *weighted* average (by population). The `aweight` (analytic weights) argument can be used to weight the mean:

```bash
. sum prop_urban [aw=pop], detail

                         prop_urban
-------------------------------------------------------------
      Percentiles      Smallest
 1%     .3617681       .3377319
 5%     .4799327       .3617681
10%     .5411116       .4643773       Obs                  50
25%     .6600978       .4732155       Sum of Wgt.   225907472

50%     .7333331                      Mean           .7366408
                        Largest       Std. Dev.       .130021
75%     .8426136       .8651392
90%     .9129498       .8699789       Variance       .0169055
95%     .9129498       .8903645       Skewness      -.5696812
99%     .9129498       .9129498       Kurtosis       2.678608

```

Perhaps we are now interested in discovering the most urbanized states. We can simply sort them on our new variable, and look at the largest values:

```bash
. sort prop_urban

. list state prop_urban in -5/-1

     +-------------------------+
     | state          prop_u~n |
     |-------------------------|
 46. | Nevada          .853158 |
 47. | Hawaii         .8651392 |
 48. | Rhode Island   .8699789 |
 49. | New Jersey     .8903645 |
 50. | California     .9129498 |
     +-------------------------+

```

We probably want to sort in descending order, which we can do using `gsort`:

```bash
. gsort - prop_urban

. list state prop_urban in 1/5

     +-------------------------+
     | state          prop_u~n |
     |-------------------------|
  1. | California     .9129498 |
  2. | New Jersey     .8903645 |
  3. | Rhode Island   .8699789 |
  4. | Hawaii         .8651392 |
  5. | Nevada          .853158 |
     +-------------------------+


```

Suppose now that we consider a state "rural" if fewer than 60% of residents live in urban areas. We can use an appropriate logical operator to do this:

```bash
. gen rural = prop_urban < 0.6 if !missing(prop_urban)

```

Note that if any state had a missing proportion, then it would evaluate as false, resulting in a rural designation of zero.

If we decide on a different cutoff, we can simply replace the calculation:

```bash
. replace rural = prop_urban < 0.5 if !missing(prop_urban)
(7 real changes made)

```

Suppose we want a categorical variable for urbanization comprised of ordinal bins of values: 0 to 50 (exclusive), 50 to 60, 60 to 70, 70 to 80, and 80+. We can use the `recode` function to do this.

`recode` requires an integer variable, so we need to convert our variable to avoid roundoff:

```bash
. gen pct_urban = 100*prop_urban

```

Now we can use `recode` to full effect:

```bash
. recode pct_urban (80/100=5 "80 to 100") (70/80=4 "70 to 80") 
(60/70=3 "60 to 70") (50/60=2 "50 to 60") (0/50=1 "0 to 50"), gen(class_urban)
(50 differences between pct_urban and class_urban)
```

In order to verify that our classes have been created correctly, we can generate a summary table of statistics for this variable:

```bash
. tabstat pct_urban, by(class_urban) stat(min max)

Summary for variables: pct_urban
     by categories of: class_urban (RECODE of pct_urban)

class_urban |       min       max
------------+--------------------
    0 to 50 |  33.77319  48.76692
   50 to 60 |  50.86852  58.62541
   60 to 70 |  60.03544  69.29301
   70 to 80 |  70.63641  79.64625
  80 to 100 |  80.30769  91.29498
------------+--------------------
      Total |  33.77319  91.29498
---------------------------------

```

## Combining Datasets

There are two general scenarios in which we need to be able to combine data from multiple datasets:

* adding rows of new observations to an existing dataset
* adding columns of variables from multiple sources

For this section, we have some trivial clinic information, including old visit information in one file and new visit information in another, which we want to add to the first. Also, there is an additional table of patient information that we would like to combine with the visit info.

The columns in the two visit datasets are identical, so we can combine them in a single command:

```bash
. append using "old_visit_info" "new_visit_info", gen(whichfile)
patid was byte now int
(label instype already defined)

```

The `gen(whichfile)` clause generates a variable called `whichfile` that will include the number of the file from which each observation came (in this case, 1 or 2). We can `list` the combined dataset according to the originating file:

```bash
. list, sepby(whichfile)

     +-----------------------------------------------------------------+
     | whichf~e   patid     visitdt       illness   insurance   doctor |
     |-----------------------------------------------------------------|
  1. |        1       9   05oct2009          Cold   Major Med          |
  2. |        1       4   19oct2009   Sore Throat         HMO          |
  3. |        1       1   20oct2009          Pneu           .          |
  4. |        1      25   12nov2009          Cold         PPO          |
  5. |        1       4   15nov2009   Sore Throat           .          |
  6. |        1      25   30nov2009          Cold         PPO          |
  7. |        1       9   29dec2009           Flu           .          |
     |-----------------------------------------------------------------|
  8. |        2     616   18jan2010          Pneu         HMO    Jones |
  9. |        2       9   23feb2010   Sore Throat         HMO    Smith |
     +-----------------------------------------------------------------+


```

Having appended new rows, let's turn our attention to adding variables to the dataset, which tends to be trickier.

In the `patient_info.dta` file, there is patient information which includes some redundant information. As with the `JOIN` query in SQL, we will use the unique `patid` field to match rows in the two tables. In fact, this is a many-to-one merge.

The appropriate Stata command is `merge`, which requires:

* the type of merge
* the variables used to merge rows
* the file containing the data to be merged

```bash
. merge m:1 patid using "patient_info"
(label instype already defined)

    Result                           # of obs.
    -----------------------------------------
    not matched                             4
        from master                         3  (_merge==1)
        from using                          1  (_merge==2)

    matched                                 6  (_merge==3)
    -----------------------------------------

```

So, `m:1` specifies the many-to-one merge type, with "many" in memory and "one" in the external file. The possible merge types include:

* `m:1`: many-to-one
* `1:many`: one-to-many
* `1:1`: one-to-one

The output consists of a report of mismatches, and a variable `_merge` is added to the merged database.

![merged](http://d.pr/i/53JF+)

Notice that the merged database includes rows that were only in one table. Values of `_merge` less than 3 are observations that could not be joined.

Note that, in this case, we should be worried about "master only" rows, but not about "using only".

After verifying the merge, we can drop the `_merge` variable:

```bash
. drop _merge
```

Now, what about the overlapping variable, `insurance`? By default, if there is a conflict between tables, Stata retains the data in the master table. Specify the `update` option during the merge to select the "using" data values instead.


## Summarization of Data   

To demonstrate tabulation and summarization of data, we will use an example dataset that does not reside locally on your system, but is available on the Stata website. To obtain such datasets, we use the `webuse` command:

```bash
. webuse lbw
(Hosmer & Lemeshow data)

```

This is a database of low birthweight infants related to several risk factors related to the mothers.

We can use `tabulate` to summarize counts or other variables across the values (levels) of a variable (factor):

```bash
. tabulate race

       race |      Freq.     Percent        Cum.
------------+-----------------------------------
      white |         96       50.79       50.79
      black |         26       13.76       64.55
      other |         67       35.45      100.00
------------+-----------------------------------
      Total |        189      100.00


```

This is a one-way table; we can summarize according to two variables by adding a second variable to the command:

```bash
. tabulate race low

           |   birthweight<2500g
      race |         0          1 |     Total
-----------+----------------------+----------
     white |        73         23 |        96 
     black |        15         11 |        26 
     other |        42         25 |        67 
-----------+----------------------+----------
     Total |       130         59 |       189 

```

In order to compare the proportion of low-birthweight children by race, we need to specify the `row` option:

```bash
. tabulate race low, row

+----------------+
| Key            |
|----------------|
|   frequency    |
| row percentage |
+----------------+

           |   birthweight<2500g
      race |         0          1 |     Total
-----------+----------------------+----------
     white |        73         23 |        96 
           |     76.04      23.96 |    100.00 
-----------+----------------------+----------
     black |        15         11 |        26 
           |     57.69      42.31 |    100.00 
-----------+----------------------+----------
     other |        42         25 |        67 
           |     62.69      37.31 |    100.00 
-----------+----------------------+----------
     Total |       130         59 |       189 
           |     68.78      31.22 |    100.00 


```

If we are interested, we can run hypothesis tests to compare proportions, such as Fisher's exact test (`exact`) and Pearson's test (`chi2`):

```bash
. tabulate race low, row chi2 exact

+----------------+
| Key            |
|----------------|
|   frequency    |
| row percentage |
+----------------+

Enumerating sample-space combinations:
stage 3:  enumerations = 1
stage 2:  enumerations = 10
stage 1:  enumerations = 0

           |   birthweight<2500g
      race |         0          1 |     Total
-----------+----------------------+----------
     white |        73         23 |        96 
           |     76.04      23.96 |    100.00 
-----------+----------------------+----------
     black |        15         11 |        26 
           |     57.69      42.31 |    100.00 
-----------+----------------------+----------
     other |        42         25 |        67 
           |     62.69      37.31 |    100.00 
-----------+----------------------+----------
     Total |       130         59 |       189 
           |     68.78      31.22 |    100.00 

          Pearson chi2(2) =   5.0048   Pr = 0.082
           Fisher's exact =                 0.079
               
```

We can also obtain summary statistics **within** both kinds of tables, via the `summarize` option, which generates means, standard deviations and frequencies:

```bash
. tabulate race smoke, sum(bwt)

     Means, Standard Deviations and Frequencies of birthweight (grams)

           |    smoked during
           |      pregnancy
      race |         0          1 |     Total
-----------+----------------------+----------
     white |   3428.75  2827.3846 | 3103.0104
           | 710.09892  626.68443 | 727.87244
           |        44         52 |        96
-----------+----------------------+----------
     black |    2854.5       2504 | 2719.6923
           | 621.25432  637.05677 | 638.68388
           |        16         10 |        26
-----------+----------------------+----------
     other | 2814.2364  2757.1667 | 2804.0149
           |  708.2607  810.04465 | 721.30115
           |        55         12 |        67
-----------+----------------------+----------
     Total | 3054.9565  2772.2973 | 2944.2857
           | 752.40901  659.80748 | 729.01602
           |       115         74 |       189


```

There are convenience functions `tab1` and `tab2` that create a series of one- and two-way tables, respectively, according to a series of variables. For example:

```bash
. tab2 race smoke ui, sum(bwt)
```

For finer control over table formatting, use the `table` command instead.

```bash
. table race smoke, contents(mean bwt sd bwt freq) format(%6.1f)

--------------------------
          | smoked during 
          |   pregnancy   
     race |      0       1
----------+---------------
    white | 3428.8  2827.4
          |  710.1   626.7
          |   44.0    52.0
          | 
    black | 2854.5  2504.0
          |  621.3   637.1
          |   16.0    10.0
          | 
    other | 2814.2  2757.2
          |  708.3   810.0
          |   55.0    12.0
--------------------------
```

Notice that, unlike the `tabulate` output, the numbers are decimal-aligned, making them easier to read.

Finally, for non-standard summary statistics, we can use `tabstat`. For example, we may be interested in the quartiles of the distributions of some variables:

```bash
. tabstat bwt age lwt, s(p25, median, p75) columns(statistics)

    variable |       p25       p50       p75
-------------+------------------------------
         bwt |      2414      2977      3475
         age |        19        23        26
         lwt |       110       121       140
--------------------------------------------

```

Stata will temporarily cache the results of the most recently executed command, which allows them to be used for subsequent operations. For example,

```bash
. summarize bwt, detail

                     birthweight (grams)
-------------------------------------------------------------
      Percentiles      Smallest
 1%         1021            709
 5%         1790           1021
10%         1970           1135       Obs                 189
25%         2414           1330       Sum of Wgt.         189

50%         2977                      Mean           2944.286
                        Largest       Std. Dev.       729.016
75%         3475           4174
90%         3884           4238       Variance       531464.4
95%         3997           4593       Skewness      -.2069782
99%         4593           4990       Kurtosis       2.888821

. return list

scalars:
                  r(N) =  189
              r(sum_w) =  189
               r(mean) =  2944.285714285714
                r(Var) =  531464.3541033434
                 r(sd) =  729.0160177275554
           r(skewness) =  -.2069781935638592
           r(kurtosis) =  2.888821334996583
                r(sum) =  556470
                r(min) =  709
                r(max) =  4990
                 r(p1) =  1021
                 r(p5) =  1790
                r(p10) =  1970
                r(p25) =  2414
                r(p50) =  2977
                r(p75) =  3475
                r(p90) =  3884
                r(p95) =  3997
                r(p99) =  4593

```

These are called **r-class results**, and are only available until the next command that yields r-class results. Prior to that, they can be used for arbitrary calculations:

```bash
. display r(max) - r(min)
4281

. display r(mean)/453.6
6.4909297
        
```

To save particular values for later use, create a **scalar**:

```bash
. scalar bwt_mean = r(mean)

. display "The mean birthweight was " bwt_mean " grams."
The mean birthweight was 2944.2857 grams.

```

As the name implies, scalars are single (non-vector) numbers. Scalars are global values, meaning they can be used anywhere.

## Do-files 

As with most statistical analysis packages, Stata allows for batch processing via scripts. There are two kinds of task automation tools:

* **do-files** for batch processing
* **ado-files** for writing new Stata commands

The advantage of using do-files is that you can easily reproduce tasks, or change the commands as needed.

Stata has a do-file editor, but they can be built in any plain-text editor. Here is a do-file for cleaning the `initreg` variable in the HAART dataset:

![do-file](http://d.pr/i/rS3n+)

This can be executed via:

```bash
. do initreg_clean
```

You can organize and document your do-file using some markup:

* `/* */` encloses comments
* `//` places comments at the end of lines
* `///` allows long commands to be continued to the next line


## Looping and Macros

The do-file for cleaning up the HAART data includes a `foreach` loop that is used to generate an indicator for each drug in the list of unique drugs in the dataset. This type of loop is identical to the `for` loop in R: it repeats the expressions in the brackets for a pre-determined number of iterations.

Let's take a closer look at looping, again using the automobile database:

```bash
. sysuse auto, clear
```

For example, in an exploratory analysis, we may want to run a series of regressions of `mpg` against the other numerical variables. 

In order to incorporate this into a loop expression, we need to make a list of the variables of interest, and iterate over them, performing a regression and extracting the relevant output from each.

Here is a start:

```bash
foreach xvar in price headroom weight {
    regress mpg `xvar'
}
```

This will result in standard regression summaries being printed to the results pane, in order of execution. At each iteration of the loop, each variable in turn is put into the `xvar` **local macro**, where it is used in the regression.

Here is a slightly improved version:

```bash
foreach xvar of varlist price rep78-foreign {
    display "Regressing mpg on `xvar':"
    regress mpg `xvar'
    display
}
```

Here, we have added annotation and spacing, as well as including the entire set of numeric variables.

Sometimes we will want to loop over a set of indices, and use the indices in a series of operations. Here, the `forvalues` command does the trick:

```bash
forvalues cat=1/5 {
    local mod "`mod' (lfit price mpg if rep78==`cat')"
}
twoway `mod', legend(off) ytitle(price)
```

This plots a linear regression of price vs mpg for each repair record class, then plots the regression lines.

![twoway plot](http://d.pr/i/CMrQ+)

Finally, the `while` loop allows us to loop under a condition, which executes expressions until its condition evaluates to false. Here is a simple example:

```bash
local fact 1
local cnt 1
local toomuch 1000000
while `fact' <= `toomuch' {
    local fact = `fact' * `cnt'
    display as text "`cnt' factorial is " as result "`fact'"
    local cnt = `cnt' + 1
}
```

In the last two examples, we used the command `local`. This creates a **local macro** that is essentially a "floating" variable that is used to hold a quantity for later use (similar to scalars). 

Local macros have a local context, which means they are only known within the scope in which they were created. Global macros can be created using the `global` command.

There are two ways of defining local macros:

```bash
local <macroname> "value"
    
local <macroname> = <expression>
```

The value of a local macro is obtained by the following syntax:

```bash
`<macroname>'
```

while a global macro uses:

```bash
$<macroname>
```

We can access a list of the available macros:

```bash
. macro list
T_gm_fix_span:  0
S_E_depv:       mpg
S_E_cmd:        regress
S_FNDATE:       13 Apr 2011 17:45
S_FN:           /Applications/Stata/ado/base/a/auto.dta
ReS_jv2:        1 2 3 4 5
ReS_Call:       version 12:
S_4:            __000004 %6.1f
S_3:            1
S_level:        95
F1:             help advice;
F2:             describe;
F7:             save
F8:             use
S_ADO:          UPDATES;BASE;SITE;.;PERSONAL;PLUS;OLDPLACE
S_StataSE:      SE
S_FLAVOR:       Intercooled
S_OS:           MacOSX
S_OSDTL:        10.8.2
S_MACH:         Macintosh (Intel 64-bit)
_cnt:           11
_fact:          3628800
_toomuch:       1000000
_mod:            (lfit price mpg if rep78==1) (lfit price mpg if rep78==2) (lfit price
                mpg if rep78==3) (lfit price mpg if rep78==4) (lfit price mpg if
                rep78==5)
_druglevels:    `"3TC"' `"ABC"' `"ATV"' `"AZT"' `"D4T"' `"DDC"' `"DDI"' `"EFV"' `"FPV"'
                `"FTC"' `"IDV"' `"LPV"' `"NFV"' `"NVP"' `"RTV"' `"SQV"' `"T20"' `"TDF"'

```

A local macro can be cleared by assigning it an empty value:

```bash
. local sum "2+2"

. macro list _sum
_sum:           2+2

. local sum

. macro list _sum
local macro `sum' not found
r(111);

```
