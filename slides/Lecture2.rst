.. include:: .special.rst
	     
===========
 Lecture 2
===========
 
**Version control and GIT**

Other Stuff
===========

- Homepage will be up after the wekend (I am in a fight with the
  Drupal content management software). 
- Option 1. We will meet for lectures MW 8-8.50 and there will be Lab
  / Office hours in Newton Lab ECCR 257, 17-19 on M and 18-20 on W. **Bring your own computers.**
- Later in the semester one per group will be sufficient but for
  next week please bring your own to make sure you have a workable
  setup. 


What is version control?
========================

.. rst-class:: build
	       
- The simplest form of version control is to keep multiple copies of files and  directories. 
- The problem with this approach is that it is hard for **you** to remember if ``file1.f90``, ``filea.f90`` or ``file1a.f90`` is the latest version.
- Moreover, it is **impossible** for your **collaborators** to know! 
- Rather than coming up with our own creative file / directory naming scheme we can have Version Control Software do it (and much more) for us.

 

Why version control?
====================

.. rst-class:: build

- Leads to reproducible results. For example you can get back
  *exactly* the version of a code that you used for some paper or
  report.
- I predict that in your lifetime it will become a requirement to
  release the code that produced the results in a paper.    
- It is not uncommon that the review process of a paper takes 6
  months, making it hard to know what combination of parameters you
  used to produce some figure. 
- Safety. With a VCS you will most likely store your files on multiple computers. Hard disk crashes **do happen!** 
- If you work on multiple computers version control is a way of
  synchronizing your files.
- Makes collaboration easier. Different persons can work on the same project at the same time. 
- Not limited to software. Very useful for papers and thesis work as well. 


Client-server VCS
=================

.. rst-class:: build
	       
- In a  client-server system one computer, the server, keeps all the files in the repository and all other computers, the clients, check out and in the code. 
- The original version control program CVS and the more modern Subversion (or SVN) are two VCS that use this model. 
- A drawback of this model is that it requires connectivity and that
  there is a risk that all code, or at least the history of the code,
  to be lost if the server crashes.
- This is OLD-SCHOOL and is going away.   


Distributed VCS
===============

.. rst-class:: build

- Modern VCS like GIT and Mercurial are distributed systems where all local repositories contain all the files and the full history of the repo.  
- The distributed approach is more resilient to hardware crashes and
  you can actually still be working on your project and committing
  changes even if you happen to be Internet-less!
- Is access to fast internet part of the UN charter yet? ;-)

GIT
===

.. rst-class:: build

- Originally developed by Linus Torvalds for the development for the Linux kernel.
- It is easy to learn the basic work-cycle to get started.
- For single author projects this is really all you need.  
- Git also have many advanced features and is highly flexible. 
- It is modern and popular, thus there are tons of podcasts and tutorials.
- In this course you will only use the basic features that allows you
  to work in a small team but feel free to learn more on your own.

GitHub - Bitbucket
==================

.. rst-class:: build

- It is possible to use git for local version control on a single computer but it is more common to also host a public or private repository on a remote server. 
- There are many free git-hosting options like ``git-hub``, ``bitbucket``, ``code.google``, etc. 
- Bitbucket allows multiple private repositories even if you are not a
  student.  
- The ``Bitbucket 101`` tutorial is a good place to start if you are new to version control


Git fits on two pages
=====================

  .. image:: git-cheat-sheet-p-1.pdf
   :width: 340px
  .. image:: git-cheat-sheet-p-2.pdf
   :width: 340px


The basic cycle of coding
=========================

.. rst-class:: build

- :red:`THINK!`
- Change
- Save
- :red:`TEST!`
- Repeat
  
The basic cycle of coding
=========================

- :red:`THINK!`
- Change
- Save
- :red:`TEST!`
- :purple:`Do version control`
- Repeat


Creating a repository
=====================

- Use ``git init`` or (simpler) create it on github and clone it to your
  local computer using ``git clone``.
- One time configures:
- ``git config --global user.name "Kalle Anka"``
- ``git config --global user.email "Kalle@Anka.se"``
  
- :red:`DEAA` Show on computer.  


The local environment
=====================

The local repository has three parts:

- A Working Directory that holds all the files.
- The index or staging area.
- The ``HEAD`` pointing to the last commit made.

Files can be in three stages

1. Committed
2. Modified
3. Staged   

You check by using ``git status``   

Singe local user cycle
======================

.. rst-class:: build
	       
- Edit files  --- emacs
- Stage changes  --- ``git add file.txt``  
- Review changes  --- ``git status`` / ``git diff``  
- Commit changes  --- ``git commit -m "Message"``
- :red:`DEAA` Show and note the use of git add -p

Forgot something? Amend the commit
==================================
  
-   ``git commit -m 'initial commit'``
-   ``git add forgotten_file``
-   ``git commit --amend``

Added too much or don't like your changes
==============================================
  
-   ``git reset HEAD file.txt``
-   ``git checkout -- file.txt``
    

Keeping track of commits by SHA-1 checksums
===========================================


::

 commit 22f11a96c33cb1dba52bde7e62587bf2d56772b9 
 Author: Daniel Appelo <daniel.appelo@colorado.edu>
 Date:   Tue Jan 16 13:44:23 2018 -0700

    Commit two

 commit f2a2971ff715ae801f84dd93c5626c010e46404b
 Author: Daniel Appelo <daniel.appelo@colorado.edu>
 Date:   Tue Jan 16 13:43:52 2018 -0700

    Commit one

 commit 12d3ece48d33711b32c6af8c61ceac31bab422a4
 Author: Daniel Appelo <daniel.appelo@colorado.edu>
 Date:   Tue Jan 16 13:41:08 2018 -0700

    Initial commit


:red:`Git almost only adds so it is very hard to loose data in an
unrecoverable way.`


  
Remotes 
==============================================

Showing the name of the remotes and their adress

::

  $ git remote
  origin
  $ git remote -v
  origin	https://github.com/appelo/hello-world.git (fetch)
  origin	https://github.com/appelo/hello-world.git (push)

Pushing your local changes to the remote

``git push origin master``



Remotes 
==============================================

Show ``git fetch`` and ``git merge origin/master`` time permitting.   


