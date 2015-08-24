Program Design
==============

---

Programming With Functions
==========================

Most non-trivial statistical programming problems involve multiple steps, objectives or outputs.

* testing
* estimation
* prediction
* comparison
* visualization
* simulation

While it may seem appealing to write a single function that does everything, it is better design to write *multiple* functions, each of which is specialized to a specific, elemental task. 

---

Modular Design
==============

Solve large problems by breaking the up into discrete component sub-problems:

* easier to understand: can get the "big picture" at a glance
* easier to fix: allows for isolation of bugs
* easier to maintain: can change a function without changing the interface
* easier to re-use: small, simple functions often have multiple uses

A function longer than a page is probably too long.

---

Recursion
=========

Rather than an explicit loop, functions may be designed to call itself. This is recursion.

The Fibonacci sequence is a sequence of numbers, starting with $0,1$ that is defined as each element in the sequence being the sum of the previous two. Thus:

$0,1,1,2,3,5,8,13,\ldots$

The most efficient way to code this is via a recursive algorithm:

    !r
    fib <- function(n) {
        if ((n==1)||(n==0)) {
            return(1)
        } else {
            return(fib(n-1) + fib(n-2))
        }
    }

<!-- Scripts -->
<script type="text/javascript"
    src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>
<script type="text/javascript">MathJax.Hub.Config({tex2jax: {processEscapes: true,
    processEnvironments: false, inlineMath: [ ['$','$'] ],
    displayMath: [ ['$$','$$'] ] },
    asciimath2jax: {delimiters: [ ['$','$'] ] },
    "HTML-CSS": {minScaleAdjust: 125 } });
</script>