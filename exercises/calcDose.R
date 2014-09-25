# dose.info=di; id='id'; real='infuse.time.real'; dose='infuse.dose'; given=NULL; doseAtStart=TRUE
calcDose <- function(dose.info, id, real, dose, given=NULL, doseAtStart=TRUE) {
    real.time <- as.POSIXct(dose.info[,real], tz='America/Chicago')
    init.time <- min(real.time, na.rm=TRUE)

    # find hourly time difference between real.time and init.time
    dose.info[,'time'] <- round(as.numeric(difftime(real.time, init.time), units='hours'), 2)

    # re-order by time
    dose.info <- dose.info[order(dose.info[,'time']),]

    # indicator for change in dosage
    changeIndexStart <- c(1, which(diff(dose.info[,dose]) != 0)+1)
    changeIndexEnd <- c(which(diff(dose.info[,dose]) != 0), nrow(dose.info))
    if(doseAtStart) {
        changeIndex <- changeIndexStart
    } else {
        changeIndex <- changeIndexEnd
    }
    dose.info[changeIndex, 'change'] <- 1  

    infuse.data <- cbind(dose.info[changeIndex, c(id, real, 'time', dose)], dose=NA)

    if(!is.null(given)) {
        for(i in seq(nrow(infuse.data))) {
          infuse.data[i, 'dose'] <- sum(dose.info[seq(changeIndexStart[i], changeIndexEnd[i]), given])
        }
    } else {
        # calculate dose based on rate times length on dose
        if(doseAtStart) {
            infuse.data[,'dose'] <- infuse.data[,dose] * diff(c(infuse.data[,'time'], dose.info[nrow(dose.info), 'time']+1))
        } else {
            infuse.data[,'dose'] <- infuse.data[,dose] * diff(c(dose.info[1,'time']-1, infuse.data[,'time']))
        }
    }
    d <- infuse.data[infuse.data[,'dose'] != 0,]
    rownames(d) <- NULL
    d
}

di <- read.csv("../datasets/dose-info.csv", stringsAsFactors=FALSE)
di
calcDose(di, 'id', 'infuse.time.real', 'infuse.dose')
calcDose(di, 'id', 'infuse.time.real', 'infuse.dose', doseAtStart=FALSE)
calcDose(di, 'id', 'infuse.time.real', 'infuse.dose', given='given.dose', doseAtStart=FALSE)
