Machine Representation of Numbers
=================================


---

Positional Numeral Systems
==========================

Several possible bases for a counting system:

**Hexadecimal**

    0123456789ABCDEF

**Decimal**

    0123456789

**Binary**

    01

Computers store information (including numbers) using a binary system.

Presenter Notes
===============

Everybody learned to represent numbers using a base-10 system, meaning that there are 10 digits, zero through nine, which are concatenated together as needed to represent any number. We could just as easily have chosen another number as the basis for a counting system, such as 16 for the hexadecimal numeral system. Computers store information, including numbers, using a binary system that is comprised only of zero and one. Yet, we can represent any number we wish using binary, just as we can using decimal numerals.

---

Counting
========

Think about what happens when we reach nine in the decimal system, and we wish to keep counting.

    ...
    8
    9
    10
    11
    12
    ...

Using the binary system:

    0       0
    1       1
    2       10
    3       11
    4       100
    5       101
    6       110
    7       111
    8       1000
    ...
    


Presenter Notes
===============

Analogous to how an odometer works.

---

Integers as Bits
================

An 8-bit system implies that a unit of data is 8 bits in size. 

$$ 0001\hspace{0.2cm}1011 = 27 $$
    
$$ 1000\hspace{0.2cm}0000 = 128 = 2^7 $$
    
Every time you add a bit, you *double the range of represented values*. Having 8 bits at your disposal allows for the representation of 256 unique numeric values. This 8-bit chunk of data is referred to as a *byte*. In general, the largest decimal value you can store with a give number of bits is $2^n-1$.

$$ 8 \text{ bit} \Rightarrow 2^8 - 1 = 255 $$
$$ 16 \text{ bit} \Rightarrow 2^{16} - 1 = 65535$$
$$ 32 \text{ bit} \Rightarrow 2^{32} - 1 = 4294967295$$

If your computer was purchased in the last few years, and it is running a relatively current version of its operating system, then it is likely a 64-bit system.

Presenter Notes
===============

Computer memory is essentially limited to binary storage, where "bits" (single binary digits) are switched on or off to represent a one and zero, respectively. Every piece of information stored on your computer is made up of bits. You may have heard descriptions of computer systems as *8-bit*, *32-bit*, *64-bit*, and such. This simply refers to the size of the units of data that can be stored. 

---

Largest Integer
===============

In R, you can check the value of the largest integer via

    !r
    > .Machine$integer.max
    [1] 2147483647
    
What is this value on your system?

Presenter Notes
===============

This is just under half of what you would expect!

---

Signed Numbers
==============

So far, we have only considered the binary representation of *positive* integers. 

* for every positive integer, there is a corresponding negative value on the other side of zero. 

The most straightforward way of representing signed numbers is to "steal" a bit to indicate the sign a number. But, one less bit implies half the range!

> 8 bits = 1 sign bit + 7 integer bits

So, rather than representing 0 through 255, a signed 8-bit integer covers -128 through 127. 

Presenter Notes
===============

We must encode negative values in binary somehow
Note that the range is still 256 values, it is just shifted left 128 places.

---

Two's Complement
================

How does this work in practice? Consider the 8-bit representation of the integer 5:

$$ 0000 \hspace{0.2cm} 0101 = 5 $$

How do we change this to -5? The way that computers usually represent negative numbers in binary is via a representation called *two's complement*.

1. Flip all the bits (change zeroes to ones, and vice versa):
$$ 0000 \hspace{0.2cm} 0101 \rightarrow 1111 \hspace{0.2cm} 1010 $$

2. Add one to the binary result:
$$ 1111 \hspace{0.2cm} 1011 = -5 $$ 



Presenter Notes
===============

In the unsigned space, this would have corresponded to 251 (so its important to specify when you are using signed or unsigned numbers!). 
Notice that it is fully reversible. Try a few on your own to convince yourself.

---

Naïve Representation
====================

Why not simply using one of the bits as a "negative sign" and leaving the other bits the same for the positive and negative representations of each integer? 

Counting from -2 up to 2 using two's complement:

    -2  1110
    -1  1111
     0  0000
     1  0001
     2  0010
     
Using leftmost bit as a negative sign:

    -2  1010
    -1  1001
     0  0000
     1  0001
     2  0010
     
It might make it easier if the binary digits were used directly by humans, but the two's complement approach makes things easier for the computer. 

Presenter Notes
===============
     
Under the latter scheme, the computer would have to examine two parts of the number in order to change its value. Notice that under two's complement, one simply needs to increment the current value to count, no matter where on the line you are located. So, using a "negative sign" bit is more expensive for basic calculations.

---

Floating Point Numbers
======================

How can fractional numbers be represented with a binary system? How do we represent a decimal point?

Just as with signed integers, we must sacrifice some bits in order to deal with this additional information. Floating point representation involves a tradeoff: size vs. precision

* How much precision is lost depends entirely on how many bits are set aside to represent them.

In current computer systems we have either 32- or 64-bit floating point numbers.

Presenter Notes
===============

Fractional numbers are referred in computer science as *floating point* numbers, because the decimal point can "float" around the number

---

Floating Point Numbers
======================

Scientific notation:

$$ 4294967295 = 4.294967295 x 10^9 $$

* 4.294967295 == significand (or mantissa)
* 9 == exponent

**Single-precision** floating point number assigns:

* 23 bits to significand
* 8 bits to exponent
* 1 bit to sign

Since number of bits are limited, infinite precision is impossible!

Presenter Notes
===============

multiplying by powers of 10 is simply a matter of moving the decimal an appropriate number of places left or right

---

Double Precision
================

* 52 bits to significand
* 11 bits to exponent
* 1 bit to sign

This is the equivalent of working with 16 significant digits in base-10: 

$-(2^{53}-1) \, \text{to} \, 2^{53}-1$.

Anything outside this range is subject to *roundoff error*.

---

Rounding Error
==============

To see rounding error in action, try entering the following command into R:

    !r
    > 0.1 == 0.3/3
    
If precision were infinite, this would return true, but it is not. 


If this does not disturb you, the following might:

    !r
    > unique(c(0.3, 0.4-0.1, 0.5-0.2, 0.6-0.3, 0.7-0.4))
    
This is all due to numerical error resulting from the finite representation of numbers.

---

Floating Point Performance
==========================

Notice also, since the number has been split up into two pieces, the simple odometer analog cannot be applied to counting with floating point numbers. 

* computation using fractional numbers is considerably more expensive than for integers. 

Some computers have *floating point units*, which are hardware math co-processors that are specifically designed to help speed up floating point calculations.
    

---

Overflow and Underflow
======================

**Overflow** occurs when an arithmetic operation on two *n*-bit binary numbers is larger in absolute value than the largest number that can be represented by *n* bits.

**Underflow**, similarly, occurs when an operation yields a result that is smaller than the smallest number representable by *n* bits

- underflow is only relevant to floating-point numbers

Examples:

    !r
    > 1e-100 * 1e-100
    [1] 1e-200
    > 1e-200 * 1e-200
    [1] 0
    > 1e200 * 1e200
    [1] Inf

---

Don't Test for Equality
=======================

Even for numbers that are not very large or very small, most floating point operations will result in some loss of precision. So, two quantities that are equal in paper may not be in silicon:

    !r
    > x <- 10
    > y <- sqrt(x)
    > x == y**2
    [1] FALSE
    
The preferred approach is to test if the difference between two quantities is smaller than some (very small) tolerance:

    !r
    > tol <- 1e-8
    > abs(x - y**2) < tol
    [1] TRUE

---

Watch Your Subtraction!
=======================

Subtracting values that are equal to *n* bits can result in the loss of *n* bits of precision.

### Example: definition of the derivative ###

$$ \frac{f(x+h) - f(x)}{h} $$

    !r
    > for (h in 10:20) print((sin(1 + 10^-h) - sin(1)) / (10^-h))
    [1] 0.5402981
    [1] 0.5403019
    [1] 0.5403023
    [1] 0.5403023
    [1] 0.5403024
    [1] 0.5403022
    [1] 0.5403011
    [1] 0.5403455
    [1] 0.5395684
    [1] 0.5329071
    [1] 0.5551115
    > cos(1) # True value
    [1] 0.5403023

---

Use Logarithms
==============

We can often avoid overflow or underflow errors by working with log-transformed values. For example, when we calculate the binomial coefficient, which calculates the number of combinations of $x$ items selected from a collection of $n$. 

$${n \choose x}$$

Frequently, this results in having to compute a moderate-sized number as the ratio of enormous numbers:

$${200 \choose 10} = \frac{200!}{10!190!} = 2.2451 \times 10^{16}$$

    !r
    > factorial(200)/(factorial(190)*factorial(10))
    [1] NaN
    Warning messages:
    1: In factorial(200) : value out of range in 'gammafn'
    2: In factorial(190) : value out of range in 'gammafn'
    
---

Use Logarithms
==============

We can use the R function `lfactorial` to take the log-factorial of each number, then adding/subtracting instead of multiplying/dividing, then taking the antilog of the result:

    !r
    > x <- lfactorial(200) - lfactorial(190) - lfactorial(10)
    > exp(x)
    [1] 2.2451e+16

In this particular case, we can also take advantage of the fact that much of the large factorials cancel out, and avoid having to use logarithms:

$$\frac{200!}{190!10!} = \frac{200 \cdot 199 \cdot \ldots \cdot 2 \cdot 1}{(190 \cdot 189 \cdot \ldots \cdot 2 \cdot 1)(10 \cdot 9 \cdot \ldots \cdot 2 \cdot 1)} = \frac{200 \cdot \ldots \cdot 191}{10!}$$
     
    !r
    > prod(191:200)/factorial(10)
    [1] 2.2451e+16

---

Exercise
========

The function $f(x) = e^x/(1 + e^x)$ is called the "inverse logit function". It serves to transform variables whose support is in the real line $(-\infty, \infty)$ to the unit interval $[0,1]$. 

    !r
    exp(x)/(1 + exp(x))

What happens if you set the value of *x* to 10? What about 1000, or 1 million? 

What is a simple way to expand this function to deal with large values of *x*?

Presenter Notes
===============


<script type="text/x-mathjax-config">
  MathJax.Hub.Config({
    tex2jax: {
      displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
      inlineMath: [ ['$','$'], ["\\(","\\)"] ],
      processEscapes: true
    }
  });
</script>
<script type="text/javascript"
    src="../MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>