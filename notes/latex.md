# Using LaTeX for Scientific Document Creation

LaTeX is a software package for laying out publication-quality documents. It is based on a package called [TeX by Donald Knuth](http://amzn.to/MAgr0r), which was created to allow end-users to typeset documents, just as publishers were able to do. TeX is particularly adept at handling technical documents laden with mathematical equations, complex tables, and document structure. LaTeX is a variant of TeX that leaves out much of the technical detail (and power) of TeX, focusing instead on important document structure, making it easier for end-users. Most scientists use LaTeX rather than TeX, and we will focus exclusively on LaTeX in Bios301. 

Most of you are probably familiar with one or more word processors, such as Microsoft Word, Apple's Pages, or OpenOffice. These programs are integrated applications that handle text entry, document formatting, the display of the typeset document, and facilities for printing the final output. LaTeX, by contrast, is concerned only with document formatting, leaving the others to programs better suited to fulfill those tasks. 

Why would we want to give up the apparent convenience of an integrated tool for something more highly specialized and limited? First, LaTeX documents are more portable than word processing documents. As you will see, a LaTeX document is just a simple text file, and as such, can be viewed and edited on virtually any system, running any operating system. Word processors, by contrast, are often not compatible from version to version, or from operating system to operating system (if they even exist for your operating system). I have even seen documents displayed differently on different machines running the same version of the word processor on the same operating system. For many, this is unacceptable. Second, the typesetting of mathematical equations is much more flexible and robust in LaTeX than in any word processor available today (though the current version of Word now accepts LaTeX input!). Using the equation editors of most modern word processors is awkward, particularly for complex equations, and again, can be somewhat inconsistent across systems. Third, LaTeX is much more adept at handling very long documents with significant structure (*i.e.* sections, subsections, subsubsections, etc.); most who have had to edit a significant document (e.g. a thesis) in a word processor can relate a horror story related to managing, editing or outputting it satisfactorily. There are other reasons one might choose to create documents with LaTeX, but these are three of the most important and commonly-cited ones.

LaTeX is not an application *per se*, but rather, is a *markup language* that describes the structure of a document in a source file. This file contains both the document's text as well as commands (markup) that tell LaTeX how to format particular sections of text. Though LaTeX is complicated relative to most word processors, it is relatively easy to learn its core functionality well enough to produce high-quality documents; most users learn the details along the way, usually by consulting the multitude of available resources online.

## Installing LaTeX

## The Basics

As with any reputable course or book on programming, the best way to get started with LaTeX is to produce a "Hello world!" document. Remember, LaTeX is used only for the document formatting stage of production; there is no "LaTeX editor" as such, so you should open your favorite text editor and create an empty document, called `hello.tex` (`.tex` is the conventional extension for (La)TeX documents). Now populate this document with the following text:

    % My first LaTeX document
    
    \documentclass{article}
    
    \begin{document}
    
    Hello world!
    
    \end{document}

Now, save this document, and open a terminal console in the directory to which you have saved this document, and call `pdflatex hello.tex`. You should see some verbose output not unlike the following:

    $ cd ~/Bios301
    $ pdflatex hello.tex
    
    This is pdfTeX, Version 3.1415926-2.3-1.40.12 (TeX Live 2011)
     restricted \write18 enabled.
    entering extended mode
    (./hello.tex
    LaTeX2e <2009/09/24>
    Babel <v3.8l> and hyphenation patterns for english, dumylang, nohyphenation, ge
    rman-x-2009-06-19, ngerman-x-2009-06-19, afrikaans, ancientgreek, ibycus, arabi
    c, armenian, basque, bulgarian, catalan, pinyin, coptic, croatian, czech, danis
    h, dutch, ukenglish, usenglishmax, esperanto, estonian, ethiopic, farsi, finnis
    h, french, galician, german, ngerman, swissgerman, monogreek, greek, hungarian,
     icelandic, assamese, bengali, gujarati, hindi, kannada, malayalam, marathi, or
    iya, panjabi, tamil, telugu, indonesian, interlingua, irish, italian, kurmanji,
     lao, latin, latvian, lithuanian, mongolian, mongolianlmc, bokmal, nynorsk, pol
    ish, portuguese, romanian, russian, sanskrit, serbian, serbianc, slovak, sloven
    ian, spanish, swedish, turkish, turkmen, ukrainian, uppersorbian, welsh, loaded
    .
    (/usr/local/texlive/2011/texmf-dist/tex/latex/base/article.cls
    Document Class: article 2007/10/19 v1.4h Standard LaTeX document class
    (/usr/local/texlive/2011/texmf-dist/tex/latex/base/size10.clo)) (./hello.aux)
    [1{/usr/local/texlive/2011/texmf-var/fonts/map/pdftex/updmap/pdftex.map}]
    (./hello.aux) )</usr/local/texlive/2011/texmf-dist/fonts/type1/public/amsfonts/
    cm/cmr10.pfb>
    Output written on hello.pdf (1 page, 11917 bytes).
    Transcript written on hello.log.

Now, if you look at the contents of your folder (try calling `ls` from the command line), you will see a handful of documents called `hello`, with a variety of extensions. The one we are interested in is `hello.pdf`, which should look like this:

![hello.pdf](http://f.cl.ly/items/0q2X0W1y160D393O361K/Screen%20Shot%202012-07-23%20at%202.11.51%20PM.png)

So, congratulations -- you have created your first LaTeX document! Now, let's see what everything in the document source means.

The first line, beginning with a `%` is just a comment. The percent symbol tells the LaTeX processor to ignore everything on that line *after* the symbol; text before it will be processed. Just as with other computing languages, it is useful to document your LaTeX code with comments, as necessary. It can also be useful for adding notes to working documents, for example, as TODO reminders or as editing comments to collaborators.

`\documentclass{article}` is the first LaTeX function of the document. LaTeX functions are denoted by the backslash (`\`) symbol, and typically have one or more *arguments* following the function name, contained within curly braces (`{}`). So here, a function `documentclass` is being called with the argument `article`. Knowing this, the purpose of the function call is evident: we are setting the class of the document to an *article*. There is a set of pre-specified LaTeX classes available to users, which includes `article`, `report`, `letter`, `book`, `proc` (proceedings) and `slides`. The document class designates the overall formatting of the document, including things like page size, layout and available document sections. So here, we specified that we want a generic `article` format, pursuant to the generation of an academic article.

`\begin{document}` denotes the start of actual document content. The lines preceding this are commonly referred to as the *preamble*, and in more complex documents contain additional function calls, the importation of specialized add-on packages, and even the definition of custom functions to be used in the document. `\begin` is a generic command that is used to denote a number of document components, including equations and blocks of verbatim text. Each `\begin` call must be accompanied by a subsequent `\end` call with the same argument. In this case, `\end{document}` is always the last command in any LaTeX document.

So, as we saw in the output file, `Hello world!` is the only actual content in this trivial document. Since we gave no other commands to specify formatting, LaTeX assumed that this was just standard document body text. Notice that `hello.tex` has more commands than actual document content! This will not usually be the case, but there will usually be an increase in annotation and function usage along with increased content volume, as additional formatting and functionality is required.

LaTeX has its roots in UNIX operating systems, and as such, functions in a similar manner. In UNIX, one typically accomplishes tasks by using a handful of highly-specialized applications in unison, each taking on a component of the workflow. Here too, we see that LaTeX was used only to typeset the document. Our favorite text editor was used for content input, and some sort of pdf viewer was used to view (and print, if we decided to do so) the output.

## A Closer Look at a LaTeX Document

To become proficient at generating useful documents with LaTeX, it is important to learn more about LaTeX document structure. LaTeX forces you to declare elements of your document's structure in great detail, which can be a hassle, but in return, it takes care of all the layout and formatting busywork for free. In all but the very simplest, shortest documents, this will be a worthwhile tradeoff. Thus, it is valuable to consider the major components of a LaTeX document in some detail.

<!-- talk about style files -->