############################################
## Example of Data Simulation / Replication
## September 10, 2015
## J. Blume
############################################

######
## Oxygen data set
## loxy is logarithm of the dissolved oxygen content in a water sample
## cod is the chemical oxygen demand
## bod is the biochemical oxygen demand

## What are these things? https://en.wikipedia.org/wiki/Biochemical_oxygen_demand

## BOD is similar in function to chemical oxygen demand (COD), 
## in that both measure the amount of organic compounds in water. 

## BOD can be used as a gauge of the effectiveness of wastewater
## treatment plants. It is listed as a conventional pollutant in 
## the U.S. Clean Water Act.

## COD measures everything that can be chemically oxidized, rather 
## than just levels of biologically active organic matter.
######

# install.packages("MASS")
library(MASS)

o2=read.csv("oxygen.csv")
head(o2)

###### Summary Statistics
(rho.o2=cor(o2))
(vcov.o2=var(o2))		# with(o2,cov(loxy,bod)/(sd(loxy)*sd(bod)))
(means.o2=colMeans(o2))

###### Regression Model
mod.o2=lm(loxy~bod+cod,data=o2)
summary(mod.o2)
confint(mod.o2)

modcoef <- coef(summary(mod.o2))
sapply(qt(c(0.025, 0.975), 17), function(i) modcoef[,1] + i * modcoef[,2])

###### Generate data with similar statistical structure

### Method One: Assume the joint distribution of (loxy,bod,cod) is normal 
o2.sim = mvrnorm(20, mu = means.o2, Sigma = vcov.o2)
o2.sim = as.data.frame(o2.sim)

(rho.sim=cor(o2.sim))   ## Simulated correlation matrix
rho.o2                  ## Original empirical correlation matrix

#       How are rho.sim and rho.02 related? 
#       Well, rho.sim is a random drawn from a population 
#       with true correlation matrix of rho.o2. So, on average, rho.sim = rho.o2

keep.1=0
loops=10000

for (i in 1:loops) {
      o2.sim = mvrnorm(20, mu = means.o2, Sigma = vcov.o2)
      keep.1=keep.1+cor(o2.sim)/loops   # Sneaky way to take average as it accumulates
}

rho.o2 ; keep.1         # and the difference can be further reduced by increasing 'loops'

#	Notice that changing the 'means.o2' vector does not impact this behavior.
#	Try it! Replace 'mu=means.o2' with 'mu=c(-pi,4.321,1000)'
#	The means are only important if you are interested in where the data 
#	are centered; not just how they are correlated (See methods #2)


### Method Two: use empirical regression model to generate new responses)

#	To use a model to generate data, we need two things from that model:
#	Predicted values from the model and the error structure of the model

# 	Our model is
#	Mod.o2 is loxy = b0 + b1*bod + b2*cod + error where error ~ N(0,sigma^2)
#	This model was fit above as mod.o2 ; It gave estimated coefficients (betas) 
#	as coef(mod.o2); see summary(mod.o2) above which also reports them.

#	For each row, the model provides an estimated response/prediction of loxy,
#	these are the model's fitted values or yhats

yhat <- fitted(mod.o2)          # Fitted values from original/empirical model
                                # By hand these are: cbind(rep(1,20),o2$bod,o2$cod)%*%coef(mod.o2)
cbind(rep(1,20),o2$bod,o2$cod)%*%coef(mod.o2)
model.matrix(mod.o2) %*% coef(mod.o2)

#       The estimated Stdev of the errors is summary(mod.o2)$sigma (this is the error structure)
root.mse <- summary(mod.o2)$sigma

#       We then combine the predictions with the random error to simulate data from this model
yhat + rnorm(20, 0, sd=root.mse)

#       On average this should give us back the properties of the original data

keep.2=0
loops=10000
keep.b.2=matrix(NA,nrow=loops,ncol=3)

for (i in 1:loops) {
        y.new=yhat+rnorm(20,0,sd=root.mse)
        o2.sim=cbind(y.new,bod=o2$bod,cod=o2$cod)
        keep.2=keep.2 + cor(o2.sim)/loops               # Sneaky way to take average as it accumulates

        mod.sim=lm(y.new~bod+cod,data=as.data.frame(o2.sim))
        keep.b.2[i,]=coef(mod.sim)                                      # Save regression parameters
}

rho.o2 ; keep.2

#       Why bother with Method 2? Because is preserves the mean structure as well as 
#       the variance-covariance structure.

colMeans(keep.b.2) ; coef(mod.o2)


### Method three: use Bootstrap to generate new responses (relax the normality assumption)
#                                       The bootstrap samples with replacement from the vector of empirical errors

keep.3=0
loops=10000
keep.b.3=matrix(NA,nrow=loops,ncol=3)
err=resid(mod.o2)       # vector of empirical errors

for (i in 1:loops) {
        y.new=yhat + sample(err,20,replace=TRUE)
        o2.sim=cbind(y.new,bod=o2$bod,cod=o2$cod)
        keep.3=keep.3 + cor(o2.sim)/loops               # Sneaky way to take average as it accumulates

        mod.sim=lm(y.new~bod+cod,data=as.data.frame(o2.sim))
        keep.b.3[i,]=coef(mod.sim)                                  # Save regression parameters
}

rho.o2 ; keep.3
colMeans(keep.b.3) ; coef(mod.o2)

### The difference in methods 2 and 3 often shows up in the variances, 
#       althought is hard to detect here.

confint(mod.o2)[2,]
quantile(keep.b.2[,2],c(0.025,0.975))
quantile(keep.b.3[,2],c(0.025,0.975))

hist(keep.b.2[,2], breaks=80, col=rgb(1,0,0,0.5))
hist(keep.b.3[,2], breaks=80, col=rgb(0,0,1,0.5),add=TRUE)
abline(v=confint(mod.o2)[2,],lty=2,col="red")

### To illustrate how it can make a difference, change the first line
#       in the for loop to: y.new=yhat + sample(abs(err),20,replace=TRUE)
#       Now, the error distribution is all positive (definitely not normal)
#       See what happens to the bootstrap distribution

### Side note: Sometimes you want to generate data with an exact correlation structure.
#       You can do this useing the 'empirical=TRUE' option in MVN

o2.sim = mvrnorm(20, mu = means.o2, Sigma = vcov.o2, empirical=TRUE)
cor(o2.sim) ; rho.o2

#       This is helpful in some settings, but not helpful if you want to assess 
#       the variability in the variance-covariance structure (because it does not change).

####
###
##
#