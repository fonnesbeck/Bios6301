# deﬁne custom function to create a survival data.frame
createSurvivalFrame <- function(f.survﬁt){
    # initialise frame variable
    f.frame <- NULL
    # check if more then one strata
    if(length(names(f.survﬁt$strata)) == 0){
    	# create data.frame with data from survﬁt
        f.frame <- data.frame(time=f.survﬁt$time, n.risk=f.survﬁt$n.risk, n.event=f.survﬁt$n.event, n.censor = f.survﬁt
        $n.censor, surv=f.survﬁt$surv, upper=f.survﬁt$upper, lower=f.survﬁt$lower)
        	 	 # create ﬁrst two rows (start at 1)
        f.start <- data.frame(time=c(0, f.frame$time[1]), n.risk=c(f.survﬁt$n, f.survﬁt$n), n.event=c(0,0), n.censor=c
        (0,0), surv=c(1,1), upper=c(1,1), lower=c(1,1))
        	 	 # add ﬁrst row to dataset
        f.frame <- rbind(f.start, f.frame)
        # remove temporary data
        rm(f.start)
    } 
    else {
        # create vector for strata identiﬁcation
        f.strata <- NULL
        for(f.i in 1:length(f.survﬁt$strata)){
        	 	 	 # add vector for one strata according to number of rows of strata
                     f.strata <- c(f.strata, rep(names(f.survﬁt$strata)[f.i], f.survﬁt$strata[f.i]))
        }
    	 	 # create data.frame with data from survﬁt (create column for strata)
        f.frame <- data.frame(time=f.survﬁt$time, n.risk=f.survﬁt$n.risk, n.event=f.survﬁt$n.event, n.censor = f.survﬁt
        $n.censor, surv=f.survﬁt$surv, upper=f.survﬁt$upper, lower=f.survﬁt$lower, strata=factor(f.strata))
        # remove temporary data
        rm(f.strata)
        # create ﬁrst two rows (start at 1) for each strata
        for(f.i in 1:length(f.survﬁt$strata)){
        # take only subset for this strata from data
        f.subset <- subset(f.frame, strata==names(f.survﬁt$strata)[f.i])
        # create ﬁrst two rows (time: 0, time of ﬁrst event)
        f.start <- data.frame(time=c(0, f.subset$time[1]), n.risk=rep(f.survﬁt[f.i]$n, 2), n.event=c(0,0), 
        n.censor=c(0,0), surv=c(1,1), upper=c(1,1), lower=c(1,1), strata=rep(names(f.survﬁt$strata)[f.i],
        2))
        	 	 	 # add ﬁrst two rows to dataset
        f.frame <- rbind(f.start, f.frame)
        # remove temporary data
        rm(f.start, f.subset)
    }
    # reorder data
    f.frame <- f.frame[order(f.frame$strata, f.frame$time), ]
    # rename row.names
    rownames(f.frame) <- NULL
    }
    # return frame
    return(f.frame)
}

# deﬁne custom function to draw kaplan-meier curve with ggplot
qplot_survival <- function(f.frame, f.CI="default", f.shape=3){
    # use different plotting commands dependig whether or not strata's are given
    if("strata" %in% names(t.survframe) == FALSE){
    	 	 # conﬁdence intervals are drawn if not speciﬁed otherwise
        if(f.CI=="default" | f.CI==TRUE ){
            # create plot with 4 layers (ﬁrst 3 layers only events, last layer only censored)
            # hint: censoring data for multiple censoring events at timepoint are overplotted

 
            # (unlike in plot.survﬁt in survival package)
            ggplot(data=f.frame) + geom_step(aes(x=time, y=surv), direction="hv") + geom_step(aes(x=time, 
            y=upper), directions="hv", linetype=2) + geom_step(aes(x=time,y=lower), direction="hv", linetype=2) + 
            geom_point(data=subset(f.frame, n.censor==1), aes(x=time, y=surv), shape=f.shape)
        
        } else {
        	# create plot without conﬁdence intervalls
            ggplot(data=f.frame) + geom_step(aes(x=time, y=surv), direction="hv") +  geom_point(data=subset
            (f.frame, n.censor==1), aes(x=time, y=surv), shape=f.shape)
        }
    }
    else {
        if(f.CI=="default" | f.CI==FALSE){
        	 	 	 # without CI 
            ggplot(data=f.frame, aes(group=strata, colour=strata)) + geom_step(aes(x=time, y=surv), 
            direction="hv") + geom_point(data=subset(f.frame, n.censor==1), aes(x=time, y=surv), shape=f.shape)
        
        } else {
        	 ggplot(data=f.frame, aes(colour=strata, group=strata)) + geom_step(aes(x=time, y=surv), 
             direction="hv") + geom_step(aes(x=time, y=upper), directions="hv", linetype=2, alpha=0.5) + 
             geom_step(aes(x=time,y=lower), direction="hv", linetype=2, alpha=0.5) + geom_point(data=subset
             (f.frame, n.censor==1), aes(x=time, y=surv), shape=f.shape)
         }
    }
}
