import numpy as np

def v1(x):
    """
    Less efficient sample variance formula
    
    Requires n subtractions, n squares, 1 mean, 1 sum calculations (2n+2 total)
    """
    x = np.array(x)
    n = len(x)
    xbar = np.mean(x)
    
    return np.sum((xi - xbar)**2 for xi in x)/(n-1)
    
def v2(x):
    """
    More efficient sample variance formula
    
    
    """

    x = np.array(x)
    n = len(x)
    
    return (np.sum(x**2) - n*(np.mean(x)**2))/(n-1)
    
if __name__ == '__main__':
    x = np.random.random(10)
    print "Less efficient:", v1(x)
    print "More efficient:", v2(x)
    
    x = (np.random.random(2) * 1e10).astype(int)
    print "No catastrophic cancellation:", v1(x)
    print "Catastrophic cancellation:", v2(x)