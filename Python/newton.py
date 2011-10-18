def nr(f, f_prime, x0, tol=1e-9, max_iter=100):
    """
    Newton-Raphson algorithm for solving f(x) == 0
    
    f: a function of a single variable, x
    f_prime: a function that returns the derivative of f at x
    x0: the initial guess at the fixed point
    tol: minimum distance of consecutive guesses before algorithm stops
    max_iter: maximum number of iterations to converge to tolerance before
        algorithm stops
    
    
    """
    
    # Initialize
    x = x0
    fx, fpx = f(x), f_prime(x)
    i = 0
    
    # Loop until conditions met
    while (abs(fx) > tol) and (i < max_iter):
        
        x -= fx/fpx
        fx, fpx = f(x), f_prime(x)
        i += 1
        
        print "At iteration %i the value of x is %f" % (i, x)
        
    if abs(fx) > tol:
        print "Algorithm failed to converge"
        return None
    print "Algorithm converged!"
    return x