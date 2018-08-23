# LaTeX Presentations in Beamer

---

Document Structure
==================

    !latex
    \documentclass{beamer}
    % preamble
    \title{nbpMatching R Package}
    \subtitle{Optimal non-bipartite matching}
    \author{Cole Beck}
    \institute{Vanderbilt University}
    \date{\today}
    \begin{document}
    % content
    \end{document}

---

Slides are Frames
=================

    !latex
    \begin{frame}
    \titlepage
    \end{frame}

---

Presentation Outline
====================

    !latex
    \begin{frame}
    \frametitle{Outline}
    \tableofcontents
    \end{frame}

---

Structure with Sections
===================================

    !latex
    \section{Distance}
    \subsection{Scalar Distance}
    \begin{frame}[fragile=singleslide]
    \frametitle{scalar.dist function}
    Absolute distance between points
    \begin{verbatim}
    > scalar.dist(1:6)
        [,1] [,2] [,3] [,4] [,5] [,6]
    [1,]    0    1    2    3    4    5
    [2,]    1    0    1    2    3    4
    [3,]    2    1    0    1    2    3
    [4,]    3    2    1    0    1    2
    [5,]    4    3    2    1    0    1
    [6,]    5    4    3    2    1    0
    \end{verbatim}
    \end{frame}

---

    !latex
    \subsection{Mahalnobis Distance}
    \begin{frame}[fragile=singleslide]
    \frametitle{gendistance function}
    Distance accounts for covariance matrix
    \begin{verbatim}
    > gendistance(data.frame(age=c(90,84,91,88,73,82), strokes=c(2,1,1,3,1,1)))$dist
            1         2        3        4        5         6
    1      Inf 1.2688722 1.402429 1.495769 2.546227 1.4149526
    2 1.268872       Inf 1.159632 2.436866 1.822279 0.3313234
    3 1.402429 1.1596320      Inf 2.894964 2.981911 1.4909555
    4 1.495769 2.4368662 2.894964      Inf 2.744809 2.3946709
    5 2.546227 1.8222789 2.981911 2.744809      Inf 1.4909555
    6 1.414953 0.3313234 1.490955 2.394671 1.490955       Inf
    \end{verbatim}
    \end{frame}

---

Blocks
======

    !latex
    \begin{frame}
    \begin{block}{Matching}
    yay matching
    \end{block}

    \begin{alertblock}{Warning}
    duck!
    \end{alertblock}

    \begin{definition}
    the dictionary defines this as defined
    \end{definition}

    \begin{example}
    this was supposed to be an example
    \end{example}

    \begin{theorem}{Distance}
    $a^2 + b^2 = c^2$
    \[
    \sqrt{(y_0-y_1)^2 + (x_0-x_1)^2}
    \]
    \end{theorem}
    \end{frame}

---

Let's Pause a Moment
====================

    !latex
    \begin{frame}
    \frametitle{gendistance function}
    gendistance returns a bunch of stuff, in a list

    \begin{itemize}
    \pause
    \item Covariates data set
    \pause
    \item Distance matrix
    \pause
    \item things...
    \end{itemize}
    \end{frame}

---

Link or It Didn't Happen
========================

    !latex
    \begin{frame}
    \label{huge}
    This page is \huge{huge}!
    \end{frame}

    \begin{frame}
    \hyperlink{huge}{\beamergotobutton{huge page}}
    \end{frame}

---

Making the Invisible Visible
============================

    !latex
    \section{Matches}

    \setbeamercovered{invisible}
    \begin{frame}
    \frametitle{Matched Records}

    \begin{table}
    \begin{tabular}{r|r|r|r|c}
    Group1.ID & Group1.Row & Group2.ID & Group2.Row & Distance \\
    \hline
    \onslide<1,4>{1 & 1 & 4 & 4 & 1.495769} \\
    \onslide<2,4>{2 & 2 & 3 & 3 & 1.159632} \\
    \onslide<3,4>{5 & 5 & 6 & 6 & 1.490955} \\
    \end{tabular}
    \caption{Matching Results}
    \end{table}

    \end{frame}

---

School Spirit
=============

    !latex
    \usetheme{Boadilla}
    \definecolor{VandyGold}{RGB}{212,179,125}
    \usecolortheme[named=VandyGold]{structure}
    \setbeamercolor*{palette primary}{bg=VandyGold,fg=black}
    \setbeamercolor*{palette secondary}{fg=VandyGold,bg=black}
    \setbeamercolor*{palette tertiary}{bg=VandyGold,fg=black}
