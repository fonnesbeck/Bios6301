golden_section <- function(f, xa, xb, xc, tol=1e-9) {
    
    stopifnot(xc < xb)
    stopifnot(xc > xa)
    
    # Caclulate golden ratio (plus 1)
    ratio <- 1 + (1 + sqrt(5))/2
    
    # Initial values of function at xa, xb, xc
    fa <- f(xa)
    fb <- f(xb)
    fc <- f(xc)
    
    # Loop until stopping rule
    while(abs(xb - xa) > tol) {
        
        # xb to xc larger than xc to xa
        if ((xb - xc) > (xc -xa)) {
            
            # Calculate new value of y
            y <- xc + (xb - xc)/ratio
            fy <- f(y)
            
            if (fy >= fc) {
                
                # Assign xc to xa
                xa <- xc
                fa <- fc
                # Assign y to xc
                xc <- y
                fc <- fy
                
            } else {
                
                # Assign y to xb, xa and xc stay the same
                xb <- y
                fb <- fy
            }
            
        # xc to xa larger than xb to xc
        } else {
            
            # Calculate new value of y
            y <- xc - (xc - xa)/ratio
            fy <- f(y)
            
            if (fy >= fc) {
                
                # Assign xc to xb
                xb <- xc
                fb <- fc
                # Assign y to xc
                xc <- y
                fc <- fy
                
            } else {
                
                # Assign y to xa, others stay the same
                xa <- y
                fa <- fy
            }
                
                
        }
        
    }
    
    return(xc)
}