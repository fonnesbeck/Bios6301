# Machine Representation of Numbers

Everybody learned to represent numbers using a base-10 system, meaning that there are 10 digits, zero through nine, which are concatenated together as needed to represent any number. We could just as easily have chosen another number as the basis for a counting system, such as 16 for the hexadecimal numeral system. Computers store information, including numbers, using a binary system that is comprised only of zero and one. Yet, we can represent any number we wish using binary, just as we can using decimal numerals.

Think about what happens when we reach nine in the decimal system, and we wish to keep counting. We simply add a one to the left and cycle the nine back to zero. When we reach 19, we similarly increment the one to a two, and cycle the nine back to zero again. And so on, analogous to how an odometer works. Counting works the same with a binary numeral system, except we have to increment and cycle at one, rather than nine. So, the decimal and binary systems correspond as follows:

	0		0
	1		1
	2		10
	3		11
	4		100
	5		101
	6		110
	7		111
	8		1000
	...
	
Computer memory is essentially limited to binary storage, where "bits" (single binary digits) are switched on or off to represent a one and zero, respectively. Every piece of information stored on your computer is made up of bits. You may have heard descriptions of computer systems as *8-bit*, *32-bit*, *64-bit*, and such. This simply refers to the size of the units of data that can be stored. So as an example, an 8-bit system implies that a unit of data is 8 bits in size. So, for example:

$$ 0001\hspace{0.2cm}1011 = 27 $$
	
$$ 1000\hspace{0.2cm}0000 = 128 = 2^7 $$
	
Every time you add a bit, you double the range of represented values. Having 8 bits at your disposal allows for the representation of 256 unique numeric values. This 8-bit chunk of data is referred to as a *byte*. In general, the largest decimal value you can store with a give number of bits is $2^n-1$.

$$ 8 \text{ bit} \Rightarrow 2^8 - 1 = 255 $$
$$ 16 \text{ bit} \Rightarrow 2^{16} - 1 = 65535$$
$$ 32 \text{ bit} \Rightarrow 2^{32} - 1 = 4294967295$$

If your computer was purchased in the last few years, and it is running a relatively current version of its operating system, then it is likely a 64-bit system.

In R, you can check the value of the largest integer via

	.Machine$integer.max
	
What is this value on your system? On my system, it is 2147483647, which is just under half what you would expect. Let's find out why.


## Signed Numbers

So far, we have only considered the binary representation of positive integers. Of course, for every positive integer, there is a corresponding negative value on the other side of zero. So, if we are interested in representing negative values, we must encode it in binary. In doing so, we switch from unsigned to signed numbers. The most straightforward way of doing this is to "steal" a bit to indicate the sign a number. However, this means that the number of positive values that can be represented by a given system is cut in half relative to the unsigned representation, since we have one less bit at our disposal. So, using the 8-bit system again as an example, if we wish to represent signed integers, we are left with 7 bits to allocate to unsigned values. So, rather than representing 0 through 255, a signed 8-bit integer covers -128 through 127. Note that the range is still 256 values, it is just shifted left 128 places.

How does this work in practice? Let's find out, using a simple example. Take the 8-bit representation of the integer 5:

$$ 0000 \hspace{0.2cm} 0101 = 5 $$

How do we change this to -5? The way that computers usually represent negative numbers in binary is via a representation called *two's complement*. This is a two-step process:

1. First, flip all the bits. That is, change zeroes to ones, and vice versa:
$$ 0000 \hspace{0.2cm} 0101 \rightarrow 1111 \hspace{0.2cm} 1010 $$

2. Second, add one to the binary result:
$$ 1111 \hspace{0.2cm} 1011 = -5 $$ 

In the unsigned space, this would have corresponded to 251 (so its important to specify when you are using signed or unsigned numbers!). Notice that it is fully reversible. Try a few on your own to convince yourself.

So, why employ this seemingly-arcane convention, rather than simply using one of the bits as a "negative sign" and leaving the other bits the same for the positive and negative representations of each integer? It might make it easier if the binary digits were used directly by humans, but the two's complement approach makes things easier for the computer. Consider counting from -2 up to 2 using two's complement:

	-2  1110
	-1  1111
	 0  0000
	 1  0001
	 2  0010
	 
Now, consider counting using the leftmost bit as a negative sign:

	-2  1010
	-1  1001
	 0  0000
	 1  0001
	 2  0010
	 
Under the latter scheme, the computer would have to examine two parts of the number in order to change its value. Notice that under two's complement, one simply needs to increment the current value to count, no matter where on the line you are located. So, using a "negative sign" bit is more expensive for basic calculations.

## Floating Point Numbers

You have probably noticed that to this point we have only considered integers in this binary number system. Representing fractional numbers would appear to be complicated, if not impossible in a binary system, because there appears to be no facility for a decimal point. Fractional numbers are referred in computer science as *floating point* numbers, because the decimal point can "float" around the number, as needed. Happily, it turns out that floating point numbers can be represented as binary values, but unlike integers, suffers from lack of precision. How much precision is lost depends entirely on how many bits are set aside to represent them. Just as with signed integers, we must sacrifice some bits in order to deal with this additional information, but unlike signed integers, we sacrifice more than just a single bit. In current computer systems, we have either 32- or 64-bit floating point numbers.

To see how fractional numbers are stored, it is useful to consider scientific notation, which we are all familiar with from high school. For example, the number 4294967295 can be expressed as $4.294967295 x 10^9$. This breaks the number into two pieces: 4.294967295 is called the *significand* (or mantissa), while 9 is the *exponent*. So, multiplying by powers of 10 is simply a matter of moving the decimal an appropriate number of places left or right. One representation of a floating point number allocates 23 bits to the significand, 8 bits to the exponent, and one to the sign; this representation is called a *single precision* floating point number. So, since a limited number of bits are available to store a floating point number, it is impossible to retain infinite precision. *Double precision* floats similarly allocate 52 bits to the significand, and 11 to the exponent. This is the equivalent of working with 16 significant digits in base-10. or $-(2^{53}-1)$ to $2^{53}-1$. Anything outside this range is subject to roundoff error.

To see rounding error in action, try entering the following command into R:

	0.1 == 0.3/3

which uses the equality logical operator to see if the left-hand expression is equal to the right-hand expression. If precision were infinite, this would return true, but it is not. If this does not disturb you, the following might:

	unique(c(0.3, 0.4-0.1, 0.5-0.2, 0.6-0.3, 0.7-0.4))

the answer is neither one value nor five, but three unique values. This is all due to numerical error resulting from the finite representation of numbers.

Notice also, since the number has been split up into two pieces, the simple odometer analog cannot be applied to counting with floating point numbers. So, computation using fractional numbers is considerably more expensive (in terms of time for computing) than for integers. In fact, some computers have so-called *floating point units*, which are hardware math co-processors that are specifically designed to help speed up floating point calculations.

The most important lesson to be gleaned from knowing how computers store floating point numbers, from a statistical computing perspective, is that one should *never* test for strict equality. A more robust approach is to test whether a result is within some acceptable *distance* from the target value: 

	tolerance <- 0.00001
	if (abs(x - true_value) < tolerance) {
		cat('Equal!')
	} else cat('Not equal!')

### Exercise

Try adding 1 to the largest integer on your machine (using R). What happens? What do you think is going on?

## Overflow and Underflow

The finite precision of floating point numbers may not seem like a big deal, and in most cases it is not, because the roundoff error will usually be a negligible fraction of any calculated value. In some situations, however, it can result in dramatic errors.

For example, suppose we would like to calculate \\(\log(1+x)/x\\). For most values of *x*, naïvely taking the logarithm of *1+x* and dividing by *x* results in an accurate calculations; however, floating point imprecision can result in errors exceeding 100 percent.

	> x <- 1e-16
	> log(1+x)/x
	[1] 0 

So, despite the fact that the true value is exactly one, R returned zero! Even with a double precision floating point value for *x*, *1+x* equals one to 15 decimal places, and so the log of one is zero. In the absence of rounding error, \\(\log(1+x)\\) is approximately *x*, so \\(\log(1+x)/x\\) is approximately one. 

An approach that avoids loss of precision is to use an analytic approximation. You may (or may not) recall that a power series may be used to approximate \\(\log(1+x)\\):

\\[\log(1+x) \approx x + x^2/2! + x^3/3! + \ldots\\]

This way, the calculation will never round below *x*, which will result in the correct value for \\(\log(1+x)/x\\):

	> (x + x^2/factorial(2) + x^3/factorial(3) + x^4/factorial(4))/x
	[1] 1

That's an example of *underflow* error. Now, let's look at the other end of the scale: *overflow*.

The binomial distribution describes a discrete random variable whose value is bounded from above by some maximum value, *n*. It is typically used to describe the number of "successes" in *n* Bernoulli (*i.e.* binary) trials, such as the probability of getting *x* heads in *n* flips of a coin. The binomial distribution includes a combinatorial term that describes the number of ways of selecting *x* objects out of a possible *n*:

\\[{n \choose x} = \frac{n!}{x!(n-x)!}\\]

Notice that for even moderate integer values of *n* and *x*, this can involve taking the ratio of very large numbers (even if the calculated value ends up being small). When a result exceeds the value of the largest integer, overflow errors can result. In this example, the consequences are even more dire, using the naïve method of calculating each of the factorials in R:

	> log(factorial(200.))
	[1] Inf
	Warning message:
	In factorial(200) : value out of range in 'gammafn'

Here, we see that 200 exceed the value that can be handled by the `factorial` function (200! is an extremely large number!). One solution is to recognize that 190! factors out of the numerator and denominator, leaving \\((200 \cdot 199 \cdot \ldots \cdot 191)/10!\\)which can be calculated easily:

	> prod(191:200)/factorial(10)
	[1] 2.2451e+16

However, this solution is not general, since it only occurs reliably with ratios of factorials. A more useful approach is to handle calculations with large numbers on the logarithmic scale, only transforming back to the nominal scale at the very end. In this case, we can use the `lfactorial` function in R to compute log-factorials:

	> x <- lfactorial(200) - lfactorial(190) - lfactorial(10)
	> exp(x)
	[1] 2.2451e+16


### Exercise

The function \\(f(x) = e^x/(1 + e^x)\\) is called the "inverse logit function". It serves to transform variables whose support is in the real line \\((-\infty, \infty)\\) to the unit interval \\([0,1]\\). We will see more of this function later, when we discuss logistic regression. In R, this function can be implemented as follows:

	exp(x)/(1 + exp(x))

What happens if you set the value of *x* to 10? What about 1000, or 1 million? What is a simple way to expand this function to deal with large values of *x*? (Don't worry if you are unable to program the function -- just answer the question conceptually.)


## References

Frank, S. 2011. How to Count: Programming for Mere Mortals, Vol. 1.

Cook, J.D. 2008. [Avoiding Overflow, Underflow, and Loss of Precision](http://bit.ly/T8tSpF).

<!-- Mathjax -->
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
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>