# Simple built-in data types
42			    # Integer
0.002243		# Floating-point
5.0J			# Imaginary
'foo'		
"bar"			# Several string types
"""Multi-line
string"""

import pdb
pdb.set_trace()

# Some data, in a list
my_data = [12,5,17,8,9,11,21]

# Function for calulating the mean of some data
def mean(data):

    # Initialize sum to zero
    sum_x = 0.0

    # Loop over data
    for x in data:

        # Add to sum
        sum_x += x 
    
    # Divide by number of elements in list, and return
    return sum_x/len(data)

# Function for calculating variance of data
def var(data):

    # Get mean of data from function above
    x_bar = mean(data)

    # Initialize sum of squares
    sum_squares = 0.0

    # Loop over data
    for x in data:
    
        # Add squared difference to sum
        sum_sqares += (x - x_bar)**2

    # Divide by n-1 and return
    return sum_squares/(len(data)-1)



def absval(some_list):
    # Calculate absolute value

    # Create empty list
    absolutes = []    

    # Loop over elements in some_list
    for value in some_list:

        # Conditional statement
        if value<0:
            # Negative value
            absolutes.append(-value)

        else:
            # Positive value
            absolutes.append(value)

    return absolutes
    
    
    
# Import random number generator
from random import normalvariate

def positive_normals(how_many):
    
    # Create empty list
    values = []

    # Loop until we have specified number of samples
    while (len(values) < how_many):

        # Sample from standard normal
        x = normalvariate(0,1)

        # Append if positive
        if x>0: values.append(x)

    return values    



# Function argument passing
print "Examples of argument passing ..."

def func(spam, eggs, toast=0, ham=0):   
    print (spam, eggs, toast, ham) 
func(1, 2)                      # (1, 2, 0, 0) 
func(1, ham=1, eggs=0)          # (1, 0, 0, 1) 
func(sam=1, eggs=0)            # (1, 0, 0, 0) 
func(toast=1, eggs=2, spam=3)   # (3, 2, 1, 0) 
func(1, 2, 3, 4)                # (1, 2, 3, 4)



# Get file from internet

import urllib, os
# Small function to print stuff
def printargs(*args): print args

# Get file
def getfile(url):
    fname = os.path.basename(url)
    print url, "->", fname
    urllib.urlretrieve(url, fname, printargs)
     
# Call function with sample file
try:
   print "Running urllib example ..."
   getfile("http://idisk.mac.com/fonnesbeck-Public/sample.txt")
except IOError:
    pass



# Find character in string

def find(str, ch, start=0): 
    # Specify start index
	index = start 
	# Loop over characters
	while index < len(str): 
	    # Check for character of interest
		if str[index] == ch: 
			return index 
		# Increment if not found
		index += 1 
	# Return value for failure
	return -1
	
# Multiple replace within a string

import re

def multiple_replace(rep_dict, some_text):
    
    # Create a regular expression from dictionary keys
    regex = re.compile("|".join(map(re.escape, rep_dict.keys())))
    
    # For each match, look up corresponding value in dict
    return regex.sub(lambda m: rep_dict[m.group(0)], some_text)




# Parse data file into dict

# Open file
myfile = open("cancer.csv")

# Parse keys
raw_keys = myfile.readline().split(',')
keys = [k.strip().replace('\"','') for k in raw_keys]

# Initialize dict
data = {}
for key in keys:
    data[key] = []
    
# Loop over lines
for line in myfile:
    # Parse values
    values = [x.strip().replace('\"','') for x in line.split(',')]
    # Loop over values
    for k,v in zip(keys, values):
        data[k].append(v)
 
print "Example of parsed data file ..."       
print data




# Compute sinc function
from math import sin, pi

def sinc(x):
    """Compute the sinc function:
    sin(pi*x) / (pi*x)"""
    
    # Guard against zero division
    try:
        val = x*pi
        return sin(val)/val
    except ZeroDivisionError:
        return 1.0
        
input = [i/10. for i in range(10)]
output = [sinc(x) for x in input]
print 'Output from list comprehension ...'
print output
from numpy import vectorize
vsinc = vectorize(sinc)
output = vsinc(input)
print 'Output from vectorized function ...'
print output



# Matrix algebra
print 'Matrix algebra example ...'
from numpy import matrix
from numpy import linalg
# Creates a matrix.
A = matrix( [[1,2,3],[11,12,13],[21,22,23]]) 
print 'A:', A
# Creates a matrix (like a column vector).
x = matrix( [[1],[2],[3]] )  
# Creates a matrix (like a row vector).          
y = matrix( [[1,2,3]] )     
# Transpose of A.                
print 'transpose:', A.T        
# Matrix multiplication of A and x.                            
print 'multiply:', A*x            
# Inverse of A.                        
print 'inverse:', A.I          
# Eigenvalues and eigenvectors                         
print 'eigen:', linalg.eig(A)     


# Generate an index for a text file
print 'Indexing example ...'

# Empty dictionary
indx = {}
# Open the file
myfile = open('sample.txt')
# Loop over lines in file
for n, line in enumerate(myfile):
    # Parse words in line
	for word in line.split():
	    # Add word to index
		indx.setdefault(word, []).append(n)

# Loop over index
for word in sorted(indx):
    # Pretty-print word and line numbers
	print '%s:' % word,
	for n in indx[word]: print n,
	print
	
	
# Least squares regression example
from numpy.linalg import inv
from numpy import transpose, array, dot

def solve(x,y):
    'Estimates regession coefficents from data'
    
    'Add intercepts column'
    X = array([[1]*len(x), x])
    
    Xt = transpose(X)
    
    'Estimate betas'
    b_hat = dot(inv(dot(X,Xt)), dot(X,y))
    
    return b_hat
    
# Duplicate remover
def unique(s):
    """Return a list of elements without duplicates"""
    
    # Check for empty list
    if not s: return []
    
    # Try using dict first (easiest)
    u = {}
    try:
        for x in s:
            u[x] = 1
    except TypeError:
        # Try next approach
        del u
    else:
        return u.keys()
        
    # Try sorting, bringing equal items together
    # then weed out duplicates
    try:
        t = list(s)
        t.sort()
    except TypeError:
        # Try yet another approach
        del t
    else:
        assert n > 0
        last = t[0]
        lasti = i = 1
        while i<n:
            if t[i] != last:
                t[lasti] = last = t
                lasti += 1
            i += 1
        return t[:lasti]
        
    # Brute force
    u = []
    for x in s:
        if x not in u:
            u.append(x)
    return u

# An enumerator from scratch    

def enumerate(seq):   
    n = 0 
    for item in seq: 
        yield n, item 
        n += 1 
        
# Generate a Fibonacci sequence

def fibonacci(): 
    i = j = 1 
    while True: 
        r, i, j = i, j, i + j 
        yield r