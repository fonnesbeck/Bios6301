import numpy as np
from c10q9 import quadratic_approx

def test_quadratic():

    f = lambda x: np.log(x) - np.exp(-x)
    f1 = lambda x: 1./x + np.exp(-x)
    f2 = lambda x: -1/(x**2) - np.exp(-x)
    
    estimate = quadratic_approx(f, f1, f2)
    
    assert 1.309 < estimate < 1.310
    
if __name__ == '__main__':
    test_unity()  