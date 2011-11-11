import numpy as np

def simpson(a_function, a, b, n=100):
    
    """
    Numerical integration of a_function from a to b, using Simpson's 
    rule with n subdivisions.

    a_function is assumed to be a function of a single variable, n is
    a positive integer and a>b.
    """

    # No fewer than 4 sbdivisions
    n = max(2*(n/2), 4)
    
    # Width of subdivisions
    h = float(b - a)/n
    
    # Create linear space with n intervals
    x = np.linspace(a, b, num=n+1)
    
    # List of weights
    w = [1] + [2+2*(i%2) for i in range(1,n)] + [1]

    # Calculate estimate, using dot product of weights and function evaluations
    S = h/3 * np.dot(w, [a_function(xi) for xi in x])
    
    return S