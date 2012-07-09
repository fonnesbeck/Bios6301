# Version Control using Git

Version control is used widely by software developers, but can be employed very widely, by anyone who creates and edits documents of any kind, not just source code.

* Create
* Save
* Edit
* Save again
* Edit
* Save again

We would usually like a "paper trail" or a history of the changes that took place in each document, and the ability to roll back changes when necessary. This is particularly important when collaborating on projects with others, when multiple people are editing the same set of documents, data or source code. We need to know who changed what, when they did it, and why. In the absence of a version control system, developers have had to resort to making "backup" copies of entire folders of code each time they made significant changes, or handed it off for collaborators to contribute.

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

	git config --global user.name "Moe Szyslak"
	git congig --global user.email "moe@moesbar.com"
	
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


## My Notes

History:

* Torvalds 2005
* collection of low-level functions
* fast, efficient, distributed

Git is only superficially similar to SVN. It is a *content tracker* that just happens to be used as a SCM system.

Most SCM systems store diffs or deltas, which is inefficient.

Git stores **trees**, blobs of content and pointers to that content. This implies that identical content is stored only once.

There are three stages to Git:

* working
* staging ("shopping cart")
* comitting to repo ("permanent history")

Note that a repo can reside anywhere.

### Create a repo

	$ git init firstrepo
	
	Initialized empty Git repository in /Users/fonnescj/firstrepo/.git/
	
Have a look at the `.git` directory that is created. This is the only thing that Git adds to the file structure.

	$ cd firstrepo
	$ touch model.r
	$ git status
	
	# On branch master
	#
	# Initial commit
	#
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	model.r
	nothing added to commit but untracked files present (use "git add" to track)
	
Creating a file then checking the status of the repo will show that Git is aware of the file, but views it as *untracked*.

	$ git add model.r
	
	# On branch master
	#
	# Initial commit
	#
	# Changes to be committed:
	#   (use "git rm --cached <file>..." to unstage)
	#
	#	new file:   model.r
	#

Adding this file to the staging area means that it will be committed to the repository the next time the `commit` function is called.

	$ git commit -m "Draft of first model"
	
	[master (root-commit) cace59c] Draft of first model
	 0 files changed
	 create mode 100644 model.r
	 
Note that there is no network activity here. The repo that was created above is a *local* repository.

If we try making a directory inside the working directory:

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
	#	modified:   model.r
	#
	no changes added to commit (use "git add" and/or "git commit -a")
	
Now we have changed the contents of our file, so it appears as *modified* in Git.

The use of a staging area allows us to be surgical about our commits. In other words, it makes it easier to gather a set of related changes to be comitted as a meaningful unit. It also adds a layer of protection from accidentally commiting changes that were unintended.

We can add all modified files simultaneously by the syntax:

	$ git add .
	
Note that this will add only existing files that have been modified. To add new files, or to commit file deletions, we need to add an additional flag:

	$ git add -A .

**Exercise: Try renaming a file under version control**


### Ignoring, removing and renaming files

Simply removing a file by throwing it in the trash does not remove it from the repoisitory; it only registers as a modification of the file. We can remove files from the repository using `git rm`. For example, if we create a new file, and commit it:

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
	#	deleted:    badfile.txt
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
	#	deleted:    badfile.txt
	#
	
Now the change is staged to be comitted, and the file will no longer be tracked by the repository (though evidence of its previous existence still appears in the git log). Later, we will show you how to retrieve files deleted from the repository, if you decide later that you need them.

Similar to deleting files, you cannot change the name of a file without doing so through Git. Here's what happens if, rather than deleting `badfile.txt`, I change its name to `goodfile.txt` simply by using the UNIX command `mv`:

	$ mv badfile.txt goodfile.txt
	$ git status
	
	# On branch master
	# Changes not staged for commit:
	#   (use "git add/rm <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	deleted:    badfile.txt
	#
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	goodfile.txt
	no changes added to commit (use "git add" and/or "git commit -a")
	
So, as far as Git is concerned, you have deleted `badfile.txt` and created `goodfile.txt`, which is currently not tracked. For the change to be propogated as a renaming action, I should have used `git mv`, as follows:

	$ git mv badfile.txt goodfile.txt
	$ git status
	
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	renamed:    badfile.txt -> goodfile.txt
	#
	
Of course, just because a file exists in your working directory, it does not necessarily imply that you want to track it with the repository. For example, temporary files created by software, program output files, or private content may not be appropriate for tracking. At the same time, we do not want our status messages to be cluttered with files that Git can see but does not track. To prevent particular files (or entire file types) from being tracked by the repository, we can create a `.gitignore` file (notice the period at the beginning of the filename) that contains a "blacklist" of files that should not be tracked by your repository at any time. As the file name implies, files in this list are simply ignored by Git.

For example, lets create some phony log files in our working directory:

	$ touch foo.log bar.log
	
If we check the status, these two files iwll appear in the list of untracked files, but we might be using these to monitor some software development, and so do not want to delete them. Let's create an empty file, and add a single line: `*.log`. The asterix is known as a *wildcard* character, meaning that any filename ending in `.log` will be ingnored by Git. Let's see:

	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	.gitignore
	nothing added to commit but untracked files present (use "git add" to track)
	
Notice that the log files now do not appear as untracked files, even though they are still in the working directory, and are not tracked by the repository. 

## How Git Works

Most source control management systems use "deltas" as the unit of storage. That is, rather than storing the entire copies of an original file and its modified version, it simply stores the original file and the *difference* between the modified file and the original. Thus, to retrieve the current version of the file, the SCM would apply the entire set of differences (often called *deltas*), essentially re-creating the edits instantaneously. While this seems sensible and economical, since redundant content is not saved with each commit, delta storage gets slower as the history of the file gets longer.

Instead of storing deltas, Git stores directed acyclic graphs (DAGs). A dag is simply a collection of content (binary large objects, or BLOBs), with pointers to that content. These DAGs resemble computer filesystem structures, with files as the content and a directory to locate the content. The savings come from the fact that Git tracks the content of files, which means that identical files are saved only once. Thus, when we rename a file in Git, for example, since only the name of the file is changed, the repository does not make a copy of the file for the new filename, but rather points the new name to the existing content in the repository. Thus, when changes are committed to the repository, only entire new files are added to the repository; therefore, when the current codebase is retrieved, there is no delta calculations to perfom. Instead, the DAG corresponding to the current state of the repository is pulled into the current working directory. This makes Git fast, efficient and scalable.

### Hashes

Git identifies the uniqueness of all its content using hashcodes. A hashcode is a mapping of some quantity of data (in our case, the contents of files) to a much smaller dataset that uniquely identifies the original dataset. This is done using one of several *hashing algorithms*. One typically encounters hashcodes and hashing algorithms in the context of security, but Git uses this relationship to idenitify the content of files, and hence, to reliably track changes in file content. 

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

### Git Configuration

	git config core.editor “C:\Program Files\Accessories\wordpad.exe”
	
	git config core.editor mate
	
	git config core.editor vim