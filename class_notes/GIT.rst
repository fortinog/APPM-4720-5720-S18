.. -*- rst -*- -*- restructuredtext -*-

.. _GIT:

================================
GIT
================================

This section will go through the most basic parts of git. More in-depth tutorials and information can be found on the official git `webpage`__. I liked `this very cute`__ intro as well. 

__ http://git-scm.com 
__ https://try.github.io


Cloning a repository
++++++++++++++++++++

The first thing to do in this course is to clone the course repository where all the notes, homework and labs are. First cd into the directory where you want the place the repository then:

.. code-block:: none

 bash-3.2$ clone https://appelo@bitbucket.org/appelo/math471.git
 Cloning into math471...
 Password: 
 remote: Compressing objects: 100% (65/65), done.
 Unpacking objects: 100% (70/70), done.
 bash-3.2$ ls
 math471

Listing the contents of the math471 you will see something like this (there might be more stuff added by the time you read this)

.. code-block:: none

 bash-3.2$ ls math471/
 README.rst      notes           slides

We can now change directory into the repository and fetch new contributions from the ``origin`` and merge them to your ``master`` branch. The ``origin`` is the remote repository at bitbucket and the ``master`` is the main branch in your local repository. 

.. code-block:: none

  bash-3.2$ cd math471/
  bash-3.2$ git fetch origin
  bash-3.2$ git merge origin/master 
  Already up-to-date.

Of course, as we did not change anything git told us we are already up-to-date.

The basic work-flow
+++++++++++++++++++
Suppose I now want to make some changes to the file GIT.rst (containing the text that eventually gets typeset to html by `Sphinx`__) then I can use an editor like `emacs`__ to open and edit the file ``bash-3.2$ emacs GIT.rst &``. When done editing I can ask git for a report of the status of my local repository 

__ http://sphinx-doc.org
__ http://en.wikipedia.org/wiki/Emacs 

.. code-block:: none

   bash-3.2$ git status
   # On branch master
   # Changes not staged for commit:
   #   (use "git add <file>..." to update what will be committed)
   #   (use "git checkout -- <file>..." to discard changes in working directory)
   #
   #       modified:   GIT.rst
   #
   no changes added to commit (use "git add" and/or "git commit -a")

The message from git tells me that I am on the master branch and that I have made changes to the file ``GIT.rst`` which is under version control. To commit the changes we first add them to the staging area and then commit them together with an informative message:  

.. code-block:: none

  bash-3.2$ git add GIT.rst 
  bash-3.2$ git commit -m "Added a heading to the GIT.rst file"
  [master a255475] Added a heading to the GIT.rst file
   1 files changed, 2 insertions(+), 1 deletions(-)

Now we can take a look at the status again:

.. code-block:: none

 bash-3.2$ git status
 # On branch master
 #
 nothing to commit (working directory clean)

We can also take a look at the history of the previous commits

.. code-block:: none 

 bash-3.2$ git log
 commit a255475de89f72f550852a443bd61e3d3936f29f
 Author: Daniel Appelo <appelo@math.unm.edu>
 Date:   Tue Aug 19 08:22:29 2014 -0600
 
     Added a heading to the GIT.rst file

 commit 00acc187a83f496323d3dd645960984d85bd7a27
 Author: Daniel Appelo <appelo@math.unm.edu>
 Date:   Mon Aug 18 21:18:42 2014 -0600
 
     Updated Linux and Version control notes, added a link to the textbook.

 commit 5b76954c4cbdd72c3799a0c228fb8fa2f0d5ae2b
 Author: Daniel Appelo <appelo@math.unm.edu>
 Date:   Mon Aug 18 16:55:30 2014 -0600
 
     Updated the linux description.
 . 
 .
 .


The long hex-strings, e.g. ``a255475de89f72f550852a443bd61e3d3936f29f`` is the name of the commit and is computed by SHA-1 hash. This name is what allows you to get back to older versions of the code. 

If we are happy with the commit we just did we can push it to the remote repository at bitbucket.org  

.. code-block:: none 

 bash-3.2$ git push
 Password: 
 Counting objects: 7, done.
 Delta compression using up to 4 threads.
 Compressing objects: 100% (4/4), done.
 Writing objects: 100% (4/4), 452 bytes, done.
 Total 4 (delta 2), reused 0 (delta 0)
 To https://appelo@bitbucket.org/appelo/math471.git
    00acc18..a255475  master -> master


Pushing your commits to the remote server concludes the basic work cycle. Of course you can do multiple local commits before you push. In  :ref:`Homework 1 <homework1>` you will learn more about how to initialize and work with git. 







