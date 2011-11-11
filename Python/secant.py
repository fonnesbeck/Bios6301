def secant(f, x0, x1, tol=1e-9, max_iter=100):
    """Secant algorithm for solving f(x) == 0
    
    f: a function of a single variable, x
    x0: the initial guess at the fixed point
    tol: minimum distance of consecutive guesses before algorithm stops
    max_iter: maximum number of iterations to converge to tolerance before
        algorithm stops
    """
    # Initialize
    x = x0, x1
    fx = f(x0), f(x1)
    i = 0

    # Loop until conditions met
    while (abs(fx[1]) > tol) and (i < max_iter):
        
        x_i = x[1] - fx[1]*((x[1] - x[0])/(fx[1] - fx[0]))
        x = x[1],x_i
        fx = fx[1], f(x_i)
        i += 1
        
        print "At iteration %i the value of x is %f" % (i, x[1])
        
    if abs(fx[1]) > tol:
        print "Algorithm failed to converge"
        return None
    print "Algorithm converged!"
    return x[1]
    
if __name__ == '__main__':
    import numpy as np
    f = lambda x: np.log(x) - np.exp(-x)
    secant(f, 2., 3.)