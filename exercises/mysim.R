# Generate estimated treatment effects and standard errors 
# Robert Greevy and Cole Beck

### Loops
## CV
# Loop to run with the coefficient of variation for measurement error at
# 0% (no error)
# 5% (known error reported in the literature)
# 10%
cv <- c(0.0, 0.05, 0.1)
## Baseline values
# Create a set of baseline values.
# Each of these loops adds a lot of computational time during the matching.
# Many independent sets of outcomes are generated for each set of baseline values.
# "ol" is for outer loops.
ol <- 5
## Outcome values
# These are the loops for the creation of the outcome conditional on the baseline values.
# These loops are less computationally expensive.
# "il" is for inner loops.
il <- 100

# This script generates one aggregate file.
finalFile <- sprintf("AggregatedResults-SL%s-SB%s-Seed%s.csv", ol, il, 12)

simData <- function(CV, loops=100, innerloop=100) {
  save.seed <- 12
  # set common values for all loops
  NMet <- 2200
  NCombo <- 200
    
  # set desired means and standard deviations
  # 0 month values
  MeanMet0 <- 7.30
  # no measurement error
  SdMet0XerrF <- 1.30
  SdCombo0XerrF <- 1.60
  # with measurement error
  # this calibrates well to yield Sd(Met0) with error = Sd(Met0) without error
  SdMet0XerrT <- sqrt( SdMet0XerrF^2 - (7*CV)^2 )  
  # and likewise with combo
  SdCombo0XerrT <- sqrt( SdCombo0XerrF^2 - (7*CV)^2 )
  
  # 12 month values
  MeanMet12 = 6.59  # becomes b0 in polynomial
  # no measurement error
  SdNoiseMet12XerrF <- sqrt( 0.93^2 - 0.15 )  # calibrated to yield SdMet12 = 0.93
  SdNoiseCombo12XerrF <- sqrt( 1.08^2 - 0.15 )  # calibrated to yield SdCombo12 = 1.08
  # with measurement error
  # this calibrates well to yield Sd(Met12) with error = Sd(Met12) without error
  SdNoiseMet12XerrT <- sqrt( 0.93^2 - 0.15 - (7*CV)^2 )
  # and likewise with combo
  SdNoiseCombo12XerrT <- sqrt( 1.08^2 - 0.15 - (7*CV)^2 )
  
  # set the parameter values for a beta distribution to create a skewness similar to the observed HbA1c
  alpha <- 2
  beta <- 10
  MeanBeta <- alpha / (alpha + beta)
  SdBeta <- sqrt( alpha * beta / ( (alpha + beta)^2 * (alpha + beta + 1) ) )
  
  # parameters for creating the non-linear 12 month true mean values 
  # based on the actual data, 90-day gaps, persistors at 1 year with complete covariates
  hgMean <- 7      # mean(A1c0) = 7.5483531 in the data, but polynomial is centered on 7 so we use 7 here
  b0 <- MeanMet12  # b0 = 6.398758588 in the fully adjusted model; set here to match actual MeanMet12
  b1 <- 0.391267289
  b2 <- (-0.097445326)
  b3 <- 0.007091899
  
  # create variables for the regression models
  ComboFlag <- c( rep(0,NMet), rep(1,NCombo) )
  TypeILevel <- 0.05
  nloops <- loops*innerloop  # used to initiate res, results matrix
  
  # define column names
  MethodNames <- c("Unadj_Unmatch", "Nonlinear_Unmatch")
  NMethods <- length(MethodNames)
  resColNames <- character(3+3*3*NMethods)
  resColNames[1:3] <- c('NCombo', 'NMet', 'MeanDiffCombo')
  
  index <- 4
  for(i.te in c("neg100", "000", "100")) {
    for(i.method in MethodNames) {
      resColNames[seq(index, length.out=3)] <- sprintf("%s_%s_TE%s", i.method, c("Beta", "SE", "Pval"), i.te)
      index <- index + 3
    }
  }
  
  set.seed( save.seed ) # set the random number seed so the results can be replicated
  
  for( MDloop in seq(5) ){
    # start at 0, go to -1
    MeanDiff <- 0.25*(1-MDloop)     # MeanCombo0 <- MeanMet0 + MeanDiff
    MeanCombo0 <- MeanMet0 + MeanDiff
    
    # initiate the results matrix for each MDloop
    res <- matrix(NA, ncol=length(resColNames), nrow=nloops)
    colnames( res ) <- resColNames
    res[,1] <- NCombo
    res[,2] <- NMet
    res[,3] <- MeanDiff
    
    ###########################
    # start simuluation loops #
    ###########################
    for(i in seq(loops)) {
      # create the true mean values for Met0
      TrueMeanMet0 <- rbeta(NMet, alpha, beta)
      TrueMeanMet0 <- ( TrueMeanMet0 - MeanBeta ) / SdBeta  # standardize to mean 0 and sd 1
      TrueMeanMet0 <- TrueMeanMet0 * SdMet0XerrT + MeanMet0
      Met0 <- TrueMeanMet0 + rnorm( NMet, mean=0, sd=c(CV*TrueMeanMet0) )
      # comment: < 1% of Met0 values will be < 4 or > 14.
      # hist( Met0 );  mean( Met0 );  sd( Met0 );  min( Met0 );  max( Met0 );  sum( (Met0 < MeanMet0) ) / length( Met0 );  ( sum( (Met0 < 4) ) + sum( (Met0 > 14) ) );  ( sum( (Met0 < 4) ) + sum( (Met0 > 14) ) ) / length( Met0 );
      
      # create the true mean values for Combo0
      TrueMeanCombo0 <- rbeta(NCombo, alpha, beta)
      TrueMeanCombo0 <- ( TrueMeanCombo0 - MeanBeta ) / SdBeta  # standardize to mean 0 and sd 1
      TrueMeanCombo0 <- TrueMeanCombo0 * SdCombo0XerrT + MeanCombo0
      Combo0 <- TrueMeanCombo0 + rnorm( NCombo, mean=0, sd=c(CV*TrueMeanCombo0) )
      # comment: < 1% of Combo0 values will be < 4 or > 14.
      # hist( Combo0 );  mean( Combo0 );  sd( Combo0 );  min( Combo0 );  max( Combo0 );  sum( (Combo0 < MeanCombo0) ) / length( Combo0 );  ( sum( (Combo0 < 4) ) + sum( (Combo0 > 14) ) );  ( sum( (Combo0 < 4) ) + sum( (Combo0 > 14) ) ) / length( Combo0 );
      
      # variables for regression models
      Y0 <- c( Met0, Combo0 )
      Y0c1 <- Y0 - mean(Y0)
      Y0c2 <- Y0c1*Y0c1
      Y0c3 <- Y0c2*Y0c1
      
      TE.Effect <- c(-1,0,1)
      for( TEloops in seq_along(TE.Effect) ) {
        
        # calculate "true" outcomes (no noise added)
        TrueAdditiveComboEffect <- TE.Effect[TEloops]
        TrueMeanMet12 <- b0 + b1*(TrueMeanMet0-hgMean) + b2*(TrueMeanMet0-hgMean)^2 + b3*(TrueMeanMet0-hgMean)^3
        TrueMeanCombo12 <- b0 + b1*(TrueMeanCombo0-hgMean) + b2*(TrueMeanCombo0-hgMean)^2 + b3*(TrueMeanCombo0-hgMean)^3 + TrueAdditiveComboEffect
        
        for( j in seq(innerloop) ) {
          # add noise to the true mean 12 month values
          Met12 <- TrueMeanMet12 + rnorm( NMet, mean=0, sd=SdNoiseMet12XerrT ) + rnorm( NMet, mean=0, sd=c(CV*TrueMeanMet12) )
          Combo12 <- TrueMeanCombo12 + rnorm( NCombo, mean=0, sd=SdNoiseCombo12XerrT ) + rnorm( NCombo, mean=0, sd=c(CV*TrueMeanCombo12) )
          # comment: this data looks a lot like the actual data. 
          # check out the plots when running a very large sample & MeanDiff=0.3
          # plot( Met0, Met12 ); plot( Combo0, Combo12 );
          
          # outcome variables used in the analyses
          Y12 <- c( Met12, Combo12 )
          
          resOffset <- 3*NMethods
          ##### unmatched analyses
          
          # model the raw unadjusted outcomes, Y
          TheModel <- lm( Y12 ~ ComboFlag )
          res[(i-1)*innerloop+j, (resOffset*(TEloops-1)+(4:6))] <- summary(TheModel)$coefficients[2, c(1,2,4)]
                    
          # model the Y NON-LINEARLY adjusting for baseline as a covariate
          TheModel <- lm( Y12 ~ ComboFlag + Y0c1 +Y0c2 + Y0c3)
          res[(i-1)*innerloop+j, (resOffset*(TEloops-1)+(7:9))] <- summary(TheModel)$coefficients[2, c(1,2,4)]
        }
      } # end for(i in 1:loops)
    } # end TEloops
    # save results
    # FILENAME LEGEND:
    # MD: mean difference at baseline (combo - metformin).
    # Seed: seed number for random number generation.
    # CV: coefficient of variation
    filename <- sprintf("Sim-MD%s-Seed%s-CV%s.csv", MeanDiff*100, save.seed, CV*100)
    write.csv(res, filename, row.names=FALSE)
  } # end for MDloop
  cat('done\n')
} #end of simData function

######################
# Analysis of Simulations  #
######################

# function to calculate power and bias estimates
# rd = decimals to round to
powerCalc = function(filename, rd=3, onlyCoverage=FALSE) {
  d <- read.csv(filename)
  
  NCombo = d$NCombo[1]
  NMet = d$NMet[1]
  NTot = NCombo + NMet
  MeanDiffCombo = d$MeanDiffCombo[1]
  NMethods <- 2
  
  TreatmentEffects = rep( c(-1,0,1), each=NMethods)
  
  pval_cols <- grep("_Pval_", names(d), value=TRUE)
  beta_cols <- grep("_Beta_", names(d), value=TRUE)
  se_cols <- grep("_SE_", names(d), value=TRUE)
  
  Power = round( colMeans(d[,pval_cols] < 0.05)*100, rd)
  
  BiasInTreatmentEffect = round( (colMeans(d[,beta_cols])-TreatmentEffects), rd)
  
  EmpiracleSE = round( apply( d[,beta_cols], 2, sd ), rd)
  
  MeanModelSE = round( colMeans(d[,se_cols]), rd)
  
  BiasInModelSE = MeanModelSE - EmpiracleSE
  
  CritVals = c(
    qt(0.975, (NTot-2)),
    qt(0.975, (NTot-5))
  )
  
  TE.Effect <- c(-1,0,1)
  te.l <- length(TE.Effect)
  res1 <- matrix( NA, ncol=(te.l*NMethods), nrow=nrow(d) )
  res2 <- matrix( NA, ncol=(te.l*NMethods), nrow=nrow(d) )
  for( TEloops in seq(te.l) ) {
    TrueAdditiveComboEffect <- TE.Effect[TEloops]
    label <- sprintf("%03.f", round(as.numeric(sub('-', '', TrueAdditiveComboEffect*100))))
    if(grepl('-', TrueAdditiveComboEffect)) label <- sprintf("neg%s", label)
    label <- paste("TE", label, sep='')
    bcols <- grep(label, beta_cols, value=TRUE)
    scols <- grep(label, se_cols, value=TRUE)
    
    err <- t(CritVals*t(d[,scols]))
    LB <- d[,bcols] - err
    UB <- d[,bcols] + err
    Covered = (LB <= TrueAdditiveComboEffect) * (TrueAdditiveComboEffect <= UB)
    CIwidth = UB - LB
    cx <- seq(NMethods*(TEloops-1)+1, length.out=NMethods)
    res1[,cx] <- Covered
    res2[,cx] <- as.matrix(CIwidth)
  }
  
  # coverage prob
  CoverageProb = round( colMeans(res1)*100, rd )
  
  # interval width
  MeanCIwidth = round( colMeans(res2), rd )
  
  Method = rep( c(
    "Unadj_Unmatch",
    "Nonlinear_Unmatch"
  ), 3)
  if(onlyCoverage) {
    colnames(res1) <- paste(Method, TreatmentEffects, sep='TE')
    return(res1)
  }
  
  results = cbind( Method,
                   TreatmentEffects,
                   CoverageProb,
                   MeanCIwidth,
                   BiasInTreatmentEffect,
                   Power,
                   EmpiracleSE,
                   MeanModelSE,
                   BiasInModelSE,
                   MeanDiffCombo,
                   NMet,
                   NCombo
  )
  
  results = results[ order(results[,1], as.numeric(results[,2])) , ]
  results
}

# function to aggregate rows over treatment effects
RowAgg = function( filename ){
  d = read.csv( filename )
  StartRows = seq(1, nrow(d), by=3)
  EndRows = seq(3, nrow(d), by=3)
  
  Method = as.character( d$Method[ StartRows ] )
  NMethods <- length(Method)
  MeanBaselineDiffCombo = d$MeanDiffCombo[seq(NMethods)]
  CoverageProb = numeric(NMethods)
  MeanCIwidth = numeric(NMethods)
  BiasInTreatmentEffect = numeric(NMethods)
  MeanModelSE = numeric(NMethods)
  EmpiracleSE = numeric(NMethods)
  BiasInModelSE = numeric(NMethods)
  
  for(i in seq(NMethods)) {
    myrange <- seq(StartRows[i], EndRows[i])
    CoverageProb[i] = mean( d$CoverageProb[ myrange ] )
    MeanCIwidth[i] = mean( d$MeanCIwidth[ myrange ] )
    BiasInTreatmentEffect[i] = mean( d$BiasInTreatmentEffect[ myrange ] )
    MeanModelSE[i] = mean( d$MeanModelSE[ myrange ] )
    EmpiracleSE[i] = mean( d$EmpiracleSE[ myrange ] )
    BiasInModelSE[i] = mean( d$BiasInModelSE[ myrange ] )
  }
  
  result = cbind( Method,
                  MeanBaselineDiffCombo,
                  CoverageProb,
                  MeanCIwidth,
                  BiasInTreatmentEffect,
                  MeanModelSE,
                  EmpiracleSE,
                  BiasInModelSE
  )
  
  result
}

# function to compare coverage for two given methods
method.coverage <- function(umethod, mmethod, RoundingDigits, cv, ol, il) {
  mc <- vector('list', length(cv)*5)
  for(x in seq_along(cv)) {
    for(i in seq(5)) {
      MeanDiff <- 0.25*(1-i)
      uniqName <- sprintf("MD%s-Seed%s-CV%s.csv", MeanDiff*100, 12, cv[x]*100)
      r <- powerCalc(paste('Sim', uniqName, sep='-'), RoundingDigits, onlyCoverage=TRUE)
      mcu <- c(r[,grep(sprintf("^%s", umethod), colnames(r))])
      mcm <- c(r[,grep(sprintf("^%s", mmethod), colnames(r))])
      ii <- sum(mcm == 1 & mcu == 1)
      ie <- sum(mcm == 1 & mcu == 0)
      ei <- sum(mcm == 0 & mcu == 1)
      ee <- sum(mcm == 0 & mcu == 0)
      ix <- (x-1)*5+i
      mc[[ix]]$CV <- cv[x]
      mc[[ix]]$MeanDiff <- MeanDiff
      mc[[ix]]$table <- matrix(c(ii, ei, ie, ee), nrow=2)
      mc[[ix]]$prop <- prop.table(mc[[ix]]$table)
    }
  }
  mc
}

# start simulation
for(i in cv) simData(i, ol, il)

RoundingDigits = 16
index <- 1
d <- list()

# aggregate simulation results
for(x in cv) {
  for(i in seq(5)) {
    MeanDiff <- 0.25*(1-i)
    uniqName <- sprintf("MD%s-Seed%s-CV%s.csv", MeanDiff*100, 12, x*100)
    res <- powerCalc(paste('Sim', uniqName, sep='-'), RoundingDigits)
    resFile <- paste('Results', uniqName, sep='-')
    write.csv(res, resFile, row.names=FALSE)
    d[[index]] <- cbind(RowAgg(resFile), CV=x)
    index <- index + 1
  }
}
d <- do.call(rbind, d)
d <- d[ order( d[,1], as.numeric( d[,'CV'] ) ) , ]
write.csv( d, finalFile, row.names=FALSE )

mc <- method.coverage('Nonlinear_Unmatch', 'Unadj_Unmatch', RoundingDigits, cv, ol, il)
