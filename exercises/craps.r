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