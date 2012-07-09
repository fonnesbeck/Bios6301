A reST document for knitr
=========================

This is a reStructuredText document. The input filename extension is ``Rrst``
and the output filename will be ``rst``. Here is how we write R code in
**knitr**:



::

    options(width = 75)
    render_rst(strict = TRUE)  # do not use the sourcecode directive
    opts_knit$set(upload.fun = imgur_upload)  # upload images
    opts_chunk$set(cache = TRUE, cache.path = "cache/rst-", 
        fig.path = "figure/rst-", fig.width = 5, fig.height = 5)  # global chunk options




More examples
-------------

Here is an equation:

.. math::
   z = \frac{\bar{\theta}_a - \bar{\theta}_b}{\sqrt{Var(\theta_a) + Var(\theta_b)}}

A code chunk begins with ``.. {r label, options}``, and ends with ``.. ..``
(note the space in between). Optionally you can precede all R code with two
dots, e.g.



::

    1 + 1



::

    ## [1] 2



::

    rnorm(10)



::

    ##  [1] -0.1376 -0.5782  0.8795  0.8740 -1.0633  0.3685  0.4734 -1.4893
    ##  [9] -0.9472 -0.8026



::

    warning("do not forget the space after ..!")



::

    ## Warning message: do not forget the space after ..!




Inline R code is like this: the value of pi is 3.1416.
