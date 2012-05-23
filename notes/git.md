# Version Control using Git

Version control is used widely by software developers, but can be employed very widely, by anyone who creates and edits documents of any cide, not just source code.

* Create
* Save
* Edit
* Save again
* Edit
* Save again

We would usually like a "paper trail" or a history of the changes that took place in each document, and the ability to roll back changes when necessary. This is particularly important when collaborating on projects with others, when multiple people are editing the same set of documents, data or source code. We need to know who changed what, when they did it, and why.

[Git](http://git-scm.com) is a fast and modern system for version control. Git provides a complete history of content changes across all files that compose a project, facilitating the control of both individual and collaborative projects. Unlike many previous implementations of version control, Git is easy to use and relatively easy to learn, making it ideal for the workflow of a scientific programmer. Though there is a large and powerful set of commands, there are just a few core functions, which allow it to be used by non-experts, and learned progressively. One advantge of Git is that it is *distributed*, allowing it to be used both on and offline, rather than having to be constantly connected to a central server. Like UNIX, Git is composed of several discrete functions that work together to a common purpose.


    git init my_analysis
    cd my_analysis
    git add .
    git commit -m "Made analysis run faster"
    
Git allows individuals to work separaetely on a project without hinderance, but then be able to merge their work with either the work of others or their own previous work in a logical, streamlined fashion. This applies even when the same document (or even the same sections of a document) are being edited by multiple people.

    git checkout master
    git commit -a -m "Updated documentation"
    git push
    
    git checkout new_feature
    git commit -a -m "Added a new function"
    git push origin master
    
    git pull
    git merge new_feature
    
Git allows you to control and automate how changes are merged, and helps you manage situations when multiple changes are in conflict with one another. While Git can be kept simple, it is also flexible and powerful enough for power users.

     git log --graph --decorate --abrev-commit --all --pretty=oneline
     
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

Homebrew, direct download. 

[Installers](git-scm.com/downloads) for Linux, Mac, Windows.

Configure user name and email.

	git config --global user.name "Gary Gradstudent"
	git congig --global user.email "gary.gradstudent@vanderbilt.edu"
	
## Creating repositories

A local repository can be initialized using Git's `init` command, either to create a project folder:

	git init my_first_project
	
or from within an existing folder, to turn it into a repository:

	cd my_existing_project
	git init

## Managing files with Git

Committing a new file to our repository (that is, putting the file under the control of Git) is a two-step process. First, we identify a particular file as something we would like to add to our repo:

	git add new_file.r
	
This does not commit the file straight away, but rather, puts it in a staging area, where it is ready to be committed alongside other (perhaps related) files. An explicit `commit` command is then executed to formally give the file membership in the repository:

	git commit -m "Adding some new code"
	
Notice that a commit message has been added, using the `-m` flag. This message is *mandatory*, and acts as documentation for that commit. The file `new_file.r` is now part of the permanent history of the project. Notice also that Git is an "opt-in" system -- you must explicitly specify which files are included in a given commit, rather than having to opt-out files that are commited by default.

Git manages files in any particular repository based on the *content* of those files, rather than superficial changes such as filename, location or file size. 

Git, unlike many other version control systems, is a distributed system. There is no central or master repository (though you will see the name "master" used as a default repository branch name) that users' copies of the repository must necessarily sync to; each clone of a repo is a first-class version, identical in status to the original.

In fact, in the simple exampel above, there has been no network communication between the local repository to which changes are being committed and any central, remote repository. When we collaborate with others (e.g. on GitHub) we will want to have a common remote repository to coordinate the work of all contributors, but Git can operate entirely offline. Later, whenever it is convenient, our local changes may be shared with a remote repo, if one exists:

	git push
	
We will introduce you to pushing, pulling, and other remote repository interactions a little later.

