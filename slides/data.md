Data
====


---

Counting
========


---

    0   0
    1   1
    2   10
    3   11
    4   100
    5   101
    6   110
    7   111
    8   1000
    ...
  

---

Computer Representation of Data
===============================

All data represented in binary format:

- 1, 0
- True, False
- Yes, No

---

Boolean
=======

Direct binary values are represented by Booleans in R

    !r
    > TRUE
    [1] TRUE
    > FALSE
    [1] FALSE

---

Integers
========

Whole numbers, represented by a fixed-length block of bits

---

Characters
==========

Fixed-length blocks of bits, with special coding

"strings" are sequences of characters

---

Floating-point Numbers
======================

A fraction multiplied by an exponent

e.g. $3.45 \times 10^5$

The more bits allocated to fraction, the more precision.

- R uses double-precision floating-point numbers

---

Precision in Floating-point Numbers
===================================

Finite precision means arithmetic on doubles does not match that on real numbers

    !r
    > 0.45 == 3*0.15
    [1] FALSE
    > 0.45-3*0.15
    [1] 5.551115e-17

Rounding errors are usually ignorable, but can accumulate in long calculations.

.notes: problematic when values are close to zero, as errors can flip signs

---

Operators
=========

Content

---
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