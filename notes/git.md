# Version Control using Git

Version control is used widely by software developers, but can be employed very widely, by anyone who creates and edits documents of any kind, not just source code.

* Create
* Save
* Edit
* Save again
* Edit
* Save again

We would usually like a "paper trail" or a history of the changes that took place in each document, and the ability to roll back changes when necessary. This is particularly important when collaborating on projects with others, when multiple people are editing the same set of documents, data or source code. We need to know who changed what, when they did it, and why. In the absence of a version control system, developers have had to resort to making "backup" copies of entire folders of code each time they made significant changes, or handed it off for collaborators to contribute.

[Git](http://git-scm.com) is a fast and modern system for version control. Git provides a complete history of content changes across all files that compose a project, facilitating the control of both individual and collaborative projects. Unlike many previous implementations of version control, Git is easy to use and relatively easy to learn, making it ideal for the workflow of a scientific programmer. Though there is a large and powerful set of commands, there are just a few core functions, which allow it to be used by non-experts, and learned progressively. One advantage of Git is that it is *distributed*, allowing it to be used both on and offline, rather than having to be constantly connected to a central server. Like UNIX, Git is composed of several discrete functions that work together to a common purpose.

There are three stages to using Git:

1. working
2. staging ("shopping cart")
3. committing to repository ("permanent history")

For example,

    git init my_analysis
    cd my_analysis
    git add .
    git commit -m "Made analysis run faster"

Note that a repository ("repo") can reside anywhere, either on your local machine, on a remote server, or in most cases, both.

Git allows individuals to work separately on a project without hindrance, but then be able to merge their work with either the work of others or their own previous work in a logical, streamlined fashion. This applies even when the same document (or even the same sections of a document) are being edited by multiple people.

    git checkout master
    git commit -a -m "Updated documentation"
    git push
    
    git checkout new_feature
    git commit -a -m "Added a new function"
    git push origin master
    
    git pull
    git merge new_feature 

Git allows you to control and automate how changes are merged, and helps you manage situations when multiple changes are in conflict with one another. While Git can be kept simple, it is also flexible and powerful enough for power users.

     git log --graph --decorate --abbrev-commit --all --pretty=oneline
     
     * 6de3c47 (cython) Deleted old cython code locations; continued tweaking cdistir
     * 4e2e329 Moved cython code to src; began moving from flib to gsl
     * 2e40665 More progress on cythonization
     * bd6010a Began cythonization. Changed Container_values and LazyFunction to Cyth
     | *   8c28e9d (HEAD, origin/master, origin/HEAD, master) Merge pull request #115
     | |\  
     |/ /  
     | * b1b714c HDF5EA: Load meta info from existing file.
     | * 304e667 Rename hdf52 to hdf5ea, basic functionality works now.
     | * 7591091 Initial work on using EArray in HDF5.
     * |   b0daa21 (origin/2.2, 2.2) Merge pull request #114 from memmett/master
     |\ \  
     | |/  
     | * 756d775 SQLITE: Tweak CREATE TABLE statement and don't catch exceptions.
     |/  
     * c903738 (tag: v2.2) Changed version to 2.2
     * e421f64 Fixed issue #111

Notice that the log of changes looks very much like a journal of the development of the project.

## Installation

Now that you have a general idea of what working with Git looks like, let's step back and look at how to get set up with Git, namely, installation and configuration. It is easy to install Git on any of the three major computing platforms. There are installers built for each, or you can build Git from source, if you want to keep up with the latest-and-greatest version.

The simplest way, in some cases, to obtain Git is to [download an installer](git-scm.com/downloads) for either Linux, Mac, Windows. However, on Macintosh, I highly recommend managing your computing tools using [Homebrew](http://mxcl.github.com/homebrew), a package manager that downloads, builds and installs many popular development tools and software. Once Homebrew is installed, it is just a matter of typing:
    
    $ brew install git

from the command line. On most distributions of Linux, there will be a similar package manager through which Git can be installed. For example, on Debian-based systems, `apt-get` is the way to go:

    $ apt-get install git

You can test your installation by typing `git` at the terminal prompt, which will give you some usage instructions if it has been installed correctly.

    $ git
    usage: git [--version] [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
               [-p|--paginate|--no-pager] [--no-replace-objects] [--bare]
               [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
               [-c name=value] [--help]
               <command> [<args>]


### Git Configuration

Every time that you interact with Git, it will associate a name and email address with the transaction. Thus, the first step in using Git for the first time is to configure your user name and email.

    $ git config --global user.name "Moe Szyslak"
    $ git congig --global user.email "moe@moesbar.com"    

This will create a *.gitconfig* file in your home directory with a very simple structure:

    $ cat ~/.gitconfig
      [user]
              name = Moe Szyslak
              email = moe@moesbar.com

If you ever change your email address, for example, you can either run the command again, or simply edit the *.gitconfig* file directly. The *--global* flag indicates that these values are to be applied system-wide; you can override the values for specific projects by running the commands without this flag within the project's directory.

There are a variety of configuration options, but for now, the only other one we will worry about is setting the default text editor. Occasionally you will need to edit files in order to use Git, and this is made easier when your favorite text editor pops up, as needed. You can specify the program you want to associate with Git as follows:

    $ git config core.editor “C:\Program Files\Accessories\wordpad.exe”
    $ git config core.editor mate
    $ git config core.editor vim


### Create a repository

A local repository can be initialized using Git's `init` command to create a project folder:

    $ git init firstrepo
    
    Initialized empty Git repository in /Users/fonnescj/firstrepo/.git/

Or, if there is an existing working directory, it can be turned into a repository:

    $ cd firstrepo
    $ git init

Have a look at the `.git` directory that is created. This is the only thing that Git adds to the file structure.

The `git status` command is used to monitor the state of the repository and of the working directory.

    $ git status
    # On branch master
    nothing to commit (working directory clean)

Here, the `status` command reports that there are no outstanding changes to record. This means that the repository has the same state as that of the working directory.

Committing a new file to our repository (that is, putting the file under the control of Git) is a two-step process. First, we identify a particular file as something we would like to add to our repo:

    $ touch model.r
    $ git status
    
    # On branch master
    #
    # Initial commit
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #   model.r
    nothing added to commit but untracked files present (use "git add" to track)

Creating a file then checking the status of the repo will show that Git is aware of the file, but views it as *untracked*. Notice that at the bottom of the message, Git gives you a hint about what to do next. Let's do it.

    $ git add model.r
    
    # On branch master
    #
    # Initial commit
    #
    # Changes to be committed:
    #   (use "git rm --cached <file>..." to unstage)
    #
    #   new file:   model.r
    #

This does not commit the file straight away, but rather, puts it in a staging area, where it is ready to be committed alongside other (perhaps related) files. An explicit `commit` command is then executed to formally give the file membership in the repository:

    $ git commit -m "Draft of first model"
    
    [master (root-commit) cace59c] Draft of first model
     0 files changed
     create mode 100644 model.r

Notice that a commit message has been added, using the `-m` flag. This message is *mandatory*, and acts as documentation for that commit. The file `new_file.r` is now part of the permanent history of the project. Notice also that Git is an "opt-in" system -- you must explicitly specify which files are included in a given commit, rather than having to opt-out files that are committed by default.

Git, unlike many other version control systems, is a distributed system. There is no central or master repository (though you will see the name "master" used as a default repository branch name) that users' copies of the repository must necessarily sync to; each clone of a repo is a first-class version, identical in status to the original.

There is no network activity here. The repo that was created above is a *local* repository. When we collaborate with others (*e.g.* on GitHub) we will want to have a common remote repository to coordinate the work of all contributors, but Git can operate entirely offline. Later, whenever it is convenient, our local changes may be shared with a remote repo, if one exists:

    $ git push

We will introduce you to pushing, pulling, and other remote repository interactions a little later.

Git manages files in any particular repository based on the *content* of those files, rather than superficial changes such as filename, location or file size. For example, if we try making a directory inside the working directory:

    $ mkdir docs
    $ git status
    # On branch master
    nothing to commit (working directory clean)

We see that Git does not take notice of it. This is because Git tracks content. There is no content in an empty directory. What if we `touch` our file (`touch` is a UNIX command that changes the access and modification times of a file)?

    $ touch model.r
    $ git status
    # On branch master
    nothing to commit (working directory clean)

Again, there is not status change because, again, we have not changed the content of files in the working directory.

    $ echo 'library(ggplot2)' >> model.r
    $ git status
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #   modified:   model.r
    #
    no changes added to commit (use "git add" and/or "git commit -a")

Now we have changed the contents of our file, so it appears as *modified* in Git.

The use of a staging area allows us to be surgical about our commits. In other words, it makes it easier to gather a set of related changes to be committed as a meaningful unit. It also adds a layer of protection from accidentally committing changes that were unintended.

We can add all modified files simultaneously by the syntax:

    $ git add .

Note that this will add only existing files that have been modified. To add new files, or to commit file deletions, we need to add an additional flag:

    $ git add -A .

**Exercise: Try renaming a file under version control**


### Ignoring, removing and renaming files

Simply removing a file by throwing it in the trash does not remove it from the repository; it only registers as a modification of the file. We can remove files from the repository using `git rm`. For example, if we create a new file, and commit it:

    $ touch badfile.txt
    $ git add badfile.txt
    $ git commit -m "Here's a new file"

The file `badfile.txt` is now tracked via the repository. If at any stage we want to remove it, you will see that just deleting the file from the file system results in the following:

    $ rm badfile.txt
    $ git status
    
    # On branch master
    # Changes not staged for commit:
    #   (use "git add/rm <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #   deleted:    badfile.txt
    #
    no changes added to commit (use "git add" and/or "git commit -a")

The file does not exist in our working directory any longer, but Git notices that it is gone (notice the message *Changes not staged for commit*). This message will persist until you tell Git to remove it as well:

    $ git rm badfile.txt
    
    rm 'badfile.txt'
    
    $ git status
    
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #   deleted:    badfile.txt
    #

Now the change is staged to be committed, and the file will no longer be tracked by the repository (though evidence of its previous existence still appears in the git log). Later, we will show you how to retrieve files deleted from the repository, if you decide later that you need them.

Similar to deleting files, you cannot change the name of a file without doing so through Git. Here's what happens if, rather than deleting `badfile.txt`, I change its name to `goodfile.txt` simply by using the UNIX command `mv`:

    $ mv badfile.txt goodfile.txt
    $ git status
    
    # On branch master
    # Changes not staged for commit:
    #   (use "git add/rm <file>..." to update what will be committed)
    #   (use "git checkout -- <file>..." to discard changes in working directory)
    #
    #   deleted:    badfile.txt
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #   goodfile.txt
    no changes added to commit (use "git add" and/or "git commit -a")

So, as far as Git is concerned, you have deleted `badfile.txt` and created `goodfile.txt`, which is currently not tracked. For the change to be propagated as a renaming action, I should have used `git mv`, as follows:

    $ git mv badfile.txt goodfile.txt
    $ git status
    
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #   renamed:    badfile.txt -> goodfile.txt
    #

Of course, just because a file exists in your working directory, it does not necessarily imply that you want to track it with the repository. For example, temporary files created by software, program output files, or private content may not be appropriate for tracking. At the same time, we do not want our status messages to be cluttered with files that Git can see but does not track. To prevent particular files (or entire file types) from being tracked by the repository, we can create a `.gitignore` file (notice the period at the beginning of the filename) that contains a "blacklist" of files that should not be tracked by your repository at any time. As the file name implies, files in this list are simply ignored by Git.

For example, lets create some phony log files in our working directory:

    $ touch foo.log bar.log

If we check the status, these two files will appear in the list of untracked files, but we might be using these to monitor some software development, and so do not want to delete them. Let's create an empty file, and add a single line: `*.log`. The asterisk is known as a *wildcard* character, meaning that any filename ending in `.log` will be ignored by Git. Let's see:

    $ git status
    # On branch master
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #   .gitignore
    nothing added to commit but untracked files present (use "git add" to track)

Notice that the log files now do not appear as untracked files, even though they are still in the working directory, and are not tracked by the repository. 

## How Git Works

Most source control management systems use "deltas" as the unit of storage. That is, rather than storing the entire copies of an original file and its modified version, it simply stores the original file and the *difference* between the modified file and the original. Thus, to retrieve the current version of the file, the SCM would apply the entire set of differences (often called *deltas*), essentially re-creating the edits instantaneously. While this seems sensible and economical, since redundant content is not saved with each commit, delta storage gets slower as the history of the file gets longer.

Instead of storing deltas, Git stores directed acyclic graphs (DAGs). A dag is simply a collection of content (binary large objects, or BLOBs), with pointers to that content. These DAGs resemble computer filesystem structures, with files as the content and a directory to locate the content. The savings come from the fact that Git tracks the content of files, which means that identical files are saved only once. Thus, when we rename a file in Git, for example, since only the name of the file is changed, the repository does not make a copy of the file for the new filename, but rather points the new name to the existing content in the repository. Thus, when changes are committed to the repository, only entire new files are added to the repository; therefore, when the current codebase is retrieved, there is no delta calculations to perform. Instead, the DAG corresponding to the current state of the repository is pulled into the current working directory. This makes Git fast, efficient and scalable.

For example, the Ruby on Rails repository (a framework for developing websites and web applications), when it was moved to Git from Subversion, dropped in total size from about 115MB to approximately 13MB. This included every version of every file ever contributed to the project.

### Hashes

Git identifies the uniqueness of all its content using hashcodes. A hashcode is a mapping of some quantity of data (in our case, the contents of files) to a much smaller dataset that uniquely identifies the original dataset. This is done using one of several *hashing algorithms*. One typically encounters hashcodes and hashing algorithms in the context of security, but Git uses this relationship to identify the content of files, and hence, to reliably track changes in file content. 

In particular, Git uses the [SHA1 hashing function](http://en.wikipedia.org/wiki/SHA-1) to encode the files that it tracks. Using SHA1, a file of arbitrary size is converted into a unique 160-bit string of characters. Even small changes to the corresponding file (e.g. adding a single punctuation mark to an entire book) results in a vastly different hashcode. Everything stored in a Git repository is indexed with its own SHA1 hashcode. To see what I mean, examine the log in any repository:

    $ git log
    commit fa0d6a5c6b03c0224fa87879a6454911a41400c9
    Author: Christopher Fonnesbeck <chris.fonnesbeck@vanderbilt.edu>
    Date:   Mon Jul 2 13:55:01 2012 -0500
    
        renamed badfile to goodfile
        
    commit 0e0cfcad18d7ceb1d9637f1e4184b98a46e9df18
    Author: Christopher Fonnesbeck <chris.fonnesbeck@vanderbilt.edu>
    Date:   Mon Jul 2 13:43:47 2012 -0500
    
        Here's a new file again
        
    commit 98a64155f562d40179ac53c551ee0f2670bdb203
    Author: Christopher Fonnesbeck <chris.fonnesbeck@vanderbilt.edu>
    Date:   Mon Jul 2 13:42:43 2012 -0500
    
        Deleted badfile

You can see that each commit in the history is associated with a hashcode.

### Your commit history

As you have seen above, the `git log` command accesses the record of all the transactions that have been executed under git for the project from which you call it. Along with the unique commit hash, each entry also contains the name and address of the committer, the date of the commit, as well as the mandatory commit message.

For very large projects, or ones for which you want to quickly scan the commit history, the default output is somewhat verbose. We can use the *--pretty* (for "pretty-print") argument to change the way the log is displayed. For example, a more compact output, showing just the commit hash and the message, can be obtained by:

    $ git log --pretty=oneline
    fa0d6a5c6b03c0224fa87879a6454911a41400c9 renamed badfile to goodfile
    0e0cfcad18d7ceb1d9637f1e4184b98a46e9df18 Here's a new file again
    98a64155f562d40179ac53c551ee0f2670bdb203 Deleted badfile
    770fa5e1ed514a8eef10ddb7013a9f47fadfa98f Here's a new file
    cace59c0bc7feead6cebcaed893ead508770cf28 Draft of first model

Conversely, a combination of arguments to `git log` can be used to obtain a highly informative history, as we saw above (using a more realistic repository):

    $ git log --graph --decorate --abbrev-commit --all --pretty=oneline
    * d159a3b (HEAD, origin/master, origin/HEAD, master) Minor fix to buildosx
    * 67e9310 Amended install instructions for Windows according to issue #61
    * 4c12d98 Fixed bug in sample code for Stochastic section of modelbuilding.rst
    * 81ed272 Fixed binning bug in histograms
    * a062567 Changed reference to downloads page
    *   853e6fc Merge pull request #124 from jakebiesinger/patch-1
    |\  
    | * ad890b0 Examples, tutorial links in README to point github
    |/  
    * a33b026 Update master
    * 98a2195 Fixed binning formula bug #120
    * 6be5297 Fixed test directory in test_MCMCSampler.py
    * 16d0b9e Fixed pickle commit bug.
    * 4dbb9d0 Fixed coda_output and bug in Doane's binning formula.
    * 15222e3 Improved binning options for histograms.
    * 3966c74 Fixed issue #118 in utils.coda()
    * f94b148 Restored numpy error settings
    *   8c28e9d Merge pull request #115 from memmett/hdf5-earray
    |\  
    | * b1b714c HDF5EA: Load meta info from existing file.
    | * 304e667 Rename hdf52 to hdf5ea, basic functionality works now.
    | * 7591091 Initial work on using EArray in HDF5.
    | | * 1224865 (origin/gh-pages, gh-pages) Updated windows install instructions

We now see information regarding the various branches, an abbreviated hashcode, and a graph that indicates where code branches were created and merged.

Another powerful use of `git log` is for filtering the commit history, according to desired criteria. For example, if we want to see all commits from one month ago until yesterday, limiting the number returned to a maximum of 30 records, we can type:

    $ git log -n 30 --since='1 month ago' --until=yesterday
    commit d159a3b9adba4116722cbddf7ca2b56506ba159d
    Author: Christopher Fonnesbeck <chris.fonnesbeck@vanderbilt.edu>
    Date:   Tue Jul 10 10:47:25 2012 -0500
    
        Minor fix to buildosx
        
    commit 67e9310b460ad0b07a19acab85da35af059a1980
    Author: Christopher Fonnesbeck <chris.fonnesbeck@vanderbilt.edu>
    Date:   Tue Jul 10 10:20:24 2012 -0500
    
        Amended install instructions for Windows according to issue #61
        
    commit 4c12d983c188b166997616099e10405814463350
    Author: Christopher Fonnesbeck <chris.fonnesbeck@vanderbilt.edu>
    Date:   Thu Jul 5 10:20:42 2012 -0500
    
        Fixed bug in sample code for Stochastic section of modelbuilding.rst



## Hands-on Exercise

**Test your "Git-fu" by forking my [`git_training`](https://github.com/fonnesbeck/git_training) repository, cloning it to your local machine, then correcting the grammatical error in the README file and pushing the edited file back to your remote on GitHub. If you can do this, I will be reasonably confident that you know the basics if Git.**