import numpy as np

    
def quadratic_approx(f, f1, f2, x0=1, tol=1e-8, maxiter=20):
    """docstring for quadratic_approx"""
    
    # Initialize
    xi = x0
    i = 0
    
    # Iterate
    while (i<maxiter):
        
        # Quadratic coefficients
        a0 = f(xi)
        a1 = f1(xi)
        a2 = f2(xi)/2.0

        # See if root-finding fails
        diff = np.sqrt(a1**2 - 4*a2*a0)
        
        if np.isnan(diff):
            # No root
            x = -0.5*a1/a2
        else:
            # Calculate roots
            roots = (-a1 + diff)/(2*a2) + xi, (-a1 - diff)/(2*a2) + xi
            
            # Pick the one closest to the current value
            index = abs(xi - roots[1]) < abs(xi - roots[0])
            x = roots[index]
            
        print 'New estimate at iteration %i is %f' % (i,x)
        
        # Success!
        if abs(f(x)) < tol:
            return x
            
        # Increment before continuing
        xi = x
        i += 1
            
    # Failure (None returned as default)
    print "Could not find a root after %i iterations" % maxiter
    
f = lambda x: np.log(x) - np.exp(-x)
f1 = lambda x: np.exp(-x) + 1./x
f2 = lambda x: -np.exp(-x) - 1./(x**2)
print quadratic_approx(f, f1, f2, 2.)

f = lambda x: np.cos(x) - x
f1 = lambda x: -np.sin(x) - 1
f2 = lambda x: -np.cos(x)
print quadratic_approx(f, f1, f2, 1.)

f = lambda x: np.log(x) * np.exp(-x)
f1 = lambda x: np.exp(-x) * (1. - x*np.log(x))/ x
f2 = lambda x:np.exp(-x) * ((x**2)*np.log(x)-2*x-1)/ (x**2)
print quadratic_approx(f, f1, f2, 2.)