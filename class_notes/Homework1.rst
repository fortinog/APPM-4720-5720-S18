.. -*- rst -*- -*- restructuredtext -*-

.. _homework1:

================================
Homework 1, due 08.00, 26/1-2018
================================

Version control and Git
--------------------------------

1.  Sign up for a free personal account and apply for the student
    development pack (allowing you to have private repositories) at
    `the student development pack`_.

2.  Set up Git on your machine if you haven't already. There are good instructions on the official `git-scm.com`_. 

3.  Create a *private* Git repository named homework1-last-name. To do
    this click **start a project** or simply navigate to
    `github.com/new`_. Select the button **Initialize this repository with a README**.

4.  Now you will clone the repository you just created. Go to the root of your home directory (i.e. type ``cd``) and create a directory where you keep all the repositories, e.g. ``mkdir repos`` and change into that directory (``cd repos``.)
 
5.  Next point your browser to your repository and click the green
    button that says *clone or download*. Clicking this button gives
    the adress to the repo. Copy the text and paste it into your
    terminal window (something like ``git clone
    https://github.com/appelo/APPM-4720-5720-S18.git``) and hit
    enter. You should now have a directory with the name of your
    repository, change into that directory.  

6.  In the directory ``your_repo`` there is a file called
    ``README.md``. The extension ``.md`` indicates that this file is
    written in `Markdown`_. For the repository above it looks
    something like this:

.. code-block:: none
   :linenos:

   # APPM-4720-5720-S18
   Course content for APPM 4720 / 5720 Spring 2018

7.  Open the readme file using emacs or vi and make some changes to
    the file, for example you can add a nice poem. If you haven't used
    emacs or vi before it may be a bit easier to get started with
    emacs.       

8.  Once you are done editing your readme file you will first add it to your local git repository, commit locally and then push your changes to your remote repository.
    
    - ``git add README.md``
    - ``git commit -m "Updated the README file"``
    - ``git push``

9. Go through this `tutorial`__ to see the basic work flow of git. 
    
10.  Now create a file from the terminal `touch seriefigurer.txt` and add the following comic characters to the file:

.. code-block:: none

   Kalle Anka 
   Musse Pigg
   Pomperipossa
   Bamse
   Skalman
   Nalle-Maja

11.  Add and commit the file and then add some more of your favourite
     comic characters (they don't have to be in Swedish). Add and
     commit your changes.  

12.  Now you realize that, strictly speaking, `Pomperipossa`__ is not
     a comic character but rather a fictional persona (a witch to be
     precise) and you need to correct this. Rather than changing the
     master branch you should `checkout` a new branch that we call
     `pom-fix` from an earlier snapshot of the history. To do this we
     inspect the logfile for the repository by `git log` which outputs
     something like this:       

     .. code-block:: none

        commit f2a2971ff715ae801f84dd93c5626c010e46404b
        Author: Daniel Appelo <daniel.appelo@colorado.edu>
        Date:   Tue Jan 16 13:43:52 2018 -0700

        Commit one - helpful text goes here

        commit 12d3ece48d33711b32c6af8c61ceac31bab422a4
        Author: Daniel Appelo <daniel.appelo@colorado.edu>
        Date:   Tue Jan 16 13:41:08 2018 -0700

        Initial commit

     Now, suppose we want to go back to the initial commit, then the
     important number is the commit SH1 string `12d3ece...` If we do
     `git checkout 12d3ece -b pom-fix` then in one stroke we create a
     branch called `pom-fix` which is an identical copy of the master
     branch at the time of the commit `12d3ece...`. To see what
     branches you have you can say `git branch`. 

13. Replace Pomperipossa with Gargamel and add and commit in your
    changes.  To merge your branches checkout your master branch again
    and say `git merge pom-fix`. Since there is no conflicts in the
    two files the merge should go through automatically. If it did you
    can delete the branch by `git branch -d pom-fix`.

14. Sometimes things don't go quite this smoothly. Again do `git
    checkout 12d3ece -b pom-fix` but this time change Pomperipossa and
    also add a name at the end of the list. Add and commit the changes
    and checkout the master branch and try to merge. Now you will get
    an error message that looks something like this:

    .. code-block:: none 

       Auto-merging seriefigurer.txt
       CONFLICT (content): Merge conflict in seriefigurer.txt
       Automatic merge failed; fix conflicts and then commit the result.

    A `git status .` will tell you what files have conflicts. Open
    the file with a conflict and fix it by keeping all the names (note
    that Pomperipossa did not cause a conflict). Another `git status
    .` will tell you that your merge conflict is resolved but that you
    still have to do a commit (first add). Do so and push the changes
    to github. Once you have pushed the repository you can go to the
    insights page for the repository and look at the network to see a
    graphical representation of the process.           

15. To conclude the first homework add your group members as
    collaborators on the gighub page for your repository and also add
    me. 

16. To hand in your repository send me an e-mail with the subject line
    APPM 5720 and a link to the homepage of the repository.      
    
    
.. _the student development pack: https://education.github.com/pack
.. _git-scm.com: http://git-scm.com
.. _github.com/new: https://github.com/new 
.. _Markdown: https://en.wikipedia.org/wiki/Markdown

__ https://try.github.io/levels/1/challenges/1
__ https://en.wikipedia.org/wiki/Pomperipossa_in_Monismania


