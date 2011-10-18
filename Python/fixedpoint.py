def fixedpoint(f, x0, tol=1e-9, max_iter=100):
    """
    Applies the fixed point algorithm to find x such that f(x)==x.
    
    f: a function of a single variable
    x0: the initial guess at the fixed point
    tol: minimum distance of consecutive guesses before algorithm stops
    max_iter: maximum number of iterations to converge to tolerance before
        algorithm stops
    
    
    """
    
    # First iteration
    x_old = x0
    x_new = f(x_old)
    i = 1
    print "At iteration 1 the value of x is %f" % x_new
    
    # Loop until conditions met
    while (abs(x_new - x_old) > tol) and (i < max_iter):
        
        x_old, x_new = x_new, f(x_old)
        i += 1
        print "At iteration %i the value of x is %f" % (i, x_new)
        
    if abs(x_new - x_old) > tol:
        print "Algorithm failed to converge"
        return None
    print "Algorithm converged!"
    return x_new