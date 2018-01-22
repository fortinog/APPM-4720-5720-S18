.. include:: .special.rst

+++++++++
Lecture 3
+++++++++
 
**Branching and merging**

Topics
==============================================

1. Recap.
2. Simultaneously working on different aspects of a code. Branching /
   merging.
3. Mini case study, solving :math:`u_{tt} = c^2u_{xx}`


Quick recap --- Singe local user cycle
==============================================

- Edit files  --- emacs / vi or whatever editor you like
- Stage changes  --- ``git add file.txt``  
- Review changes  --- ``git status`` / ``git diff``  
- Commit changes  --- ``git commit -m "Message"``

Other useful commands

- ``git log`` to see what has happened
- ``git log --graph --oneline`` Neater output
- ``git push``  Push commits to the remote ``origin/master`` 

  

Use of branches / merging 
==============================================

  .. image:: L3p1.pdf
   :width: 840px


.. slide::  

   .. figure:: L3p2.pdf
    :class: fill
    :width: 900px

.. slide::  

   .. figure:: L3p3.pdf
    :class: fill
    :width: 900px

.. slide::  

   .. figure:: L3p4.pdf
    :class: fill
    :width: 900px


Two workers W1 and W2
==============================================

Start from a cloned repository with a ``main.m``

:red:`show full file on github`

Important part below. W1 will do :math:`u_{xx}` and W1 will do I.C. and B.C.   
   
:: 

 % Compute initial data 
 [u,um] = set_initial_data(x,t); 
 % Time Loop 
 for it = 1:nsteps
    t = (it-1);
    % Set Boundary Conditions
    u   = set_boundary_cond(u,x,t,c);
    % Compute uxx
    uxx = compute_uxx(u,h);
    % Leap-frog in time
    up = 2*u - um + dtc2*uxx;
 end

	    
.. slide::  

   .. figure:: L3p5.pdf
    :class: fill
    :width: 850px


Worker 2 
==============================================

Worker 2 starts by cloning the repo

``$ git clone https://github.com/appelo/Lecture_3.git L3_worker2``

And creates a new branch with the name ``initial_data``

::

 $ git checkout -b initial_data``
  Switched to a new branch 'initial_data'
 $ git log
 commit 406d29... (HEAD -> initial_data, origin/master, origin/HEAD, master)
 $ git branch
  * initial_data 
     master

     
The head is now pointing to the branch ``initial_data`` as indicated
by the star. 


Worker 2
==============

Add two files and fix the input to the files in ``main.m`` 

::
 
    $ git status 
    On branch initial_data
    Changes not staged for commit:
     (use "git add <file>..." to update what will be committed)
     (use "git checkout -- <file>..." to discard changes in working directory)
   	modified:   main.m
    Untracked files:
     (use "git add <file>..." to include in what will be committed)
   	set_boundary_cond.m
   	set_initial_data.m
    no changes added to commit (use "git add" and/or "git commit -a")

We do two commits, one for I.C. and one for B.C. First I.C.

::

   $ git add set_initial_data.m 
   $ git commit -m "Added initial data routine. Had to change in main to pass c."

Worker 2
==============

Whoops, forgot to add changes in ``main.m``, use ``add --amend`` to
add more stuff to latest commit. 

::

   $ git add main.m 
   $ git commit --amend

And add and commit boundary condition routine.

::

  $ git add set_boundary_cond.m 
  $ git commit -m "Added boundry condition routine."

Worker two is happy with the changes / additions and decides to merge
the branch into the master branch. To do this we change back to master
and then merge.   

::

  $ git checkout master
   Switched to branch 'master'
   Your branch is up-to-date with 'origin/master'.

Worker 2
==============

All looks good so we merge. 
    
::

  $ git branch
     initial_data
   * master
  $ git merge initial_data
      Updating 406d29a..8c5cf71
     Fast-forward
     wave_1d/main.m              | 6 +++---
     wave_1d/set_boundary_cond.m | 8 ++++++++
     wave_1d/set_initial_data.m  | 8 ++++++++
     3 files changed, 19 insertions(+), 3 deletions(-)
     create mode 100644 wave_1d/set_boundary_cond.m
     create mode 100644 wave_1d/set_initial_data.m

Git tells us what changes were made by the merge and what strategy was
used. Here there were no conflicts between the branches. We added to
``main.m`` and we added two new files so we can simply fast-forward    


.. slide::  

   .. figure:: L3p6.pdf
    :class: fill
    :width: 900px


Recap
==============

Given a task / fix

 1. Create and checkout a new branch --- ``git checkout -b new_b``
 2. Do the standard add / commit work cycle, perhaps many times
 3. Switch back to master branch when your task is done and merge
     --- ``git merge new_b``
 4. Clean up --- ``git branch -d new_b``

NOTE that all of this was LOCAL. We finish by pushing the local
changes to the remote.

Worker 2
==============

::
   
  $ git push
    Counting objects: 9, done.
    Delta compression using up to 4 threads.
    Compressing objects: 100% (9/9), done.
    Writing objects: 100% (9/9), 1.08 KiB | 1.08 MiB/s, done.
    Total 9 (delta 2), reused 0 (delta 0)
    remote: Resolving deltas: 100% (2/2), completed with 1 local object.
    To https://github.com/appelo/Lecture_3.git
    406d29a..8c5cf71  master -> master
  $ git log
    commit 8c5cf71 (HEAD -> master, origin/master, origin/HEAD)
    Author: Daniel Appelo <daniel.appelo@colorado.edu>
    Date:   Sun Jan 21 16:57:28 2018 -0700
    Added boundry condition routine.


Worker 1
==============

So what have worker 1 been up to? She also implemented her feature,
computing :math:`u_{xx}` directly in the master branch and added and
committed changes in ``main.m`` and ``compute_uxx.m``

:: 

  $ git add compute_uxx.m main.m
  $ git status .
     On branch master
     Your branch is up-to-date with 'origin/master'.
     Changes to be committed:
     (use "git reset HEAD <file>..." to unstage)
	new file:   compute_uxx.m
	modified:   main.m
  $ git commit -m "Added fake computation of uxx. Made some changes
                               to the call of compute_uxx in main."

All looks good! Let's push our changes to the remote... 


Trouble!!!
==============

::

  $ git push
  To https://github.com/appelo/Lecture_3.git
    ! [rejected]        master -> master (fetch first)
    error: failed to push some refs to 'https://github.com/appelo/Lecture_3.git'
    hint: Updates were rejected because the remote contains work that you do
    hint: not have locally. This is usually caused by another repository pushing
    hint: to the same ref. You may want to first integrate the remote changes

We must fetch a new copy of the remote

:: 

  $ git fetch origin
    remote: Counting objects: 9, done.
    From https://github.com/appelo/Lecture_3
    406d29a..8c5cf71  master     -> origin/master

  $ git status 
   On branch master
   Your branch and 'origin/master' have diverged,
   and have 1 and 2 different commits each, respectively.


Merge conflict
==============

We try to merge the local master and the remote origin/master

::
   
  $ git merge origin/master
      Auto-merging wave_1d/main.m
      CONFLICT (content): Merge conflict in wave_1d/main.m
      Automatic merge failed; fix conflicts and then commit the result.

  $ git status   
    ....
   You have unmerged paths.
   (fix conflicts and run "git commit")
   (use "git merge --abort" to abort the merge)

   Changes to be committed:
   new file:   set_boundary_cond.m
   new file:   set_initial_data.m
   Unmerged paths:
   (use "git add <file>..." to mark resolution)
   both modified:   main.m

    

Merge conflict
==============

After fixing the conflict region with the conflict (some new whitespace) 

:: 

  up = 2*u - um + dtc2*uxx;
  <<<<<<< HEAD
    % Swap time levels;
    um = u;
    u = up;
    % Add plotting
    plot(x,u,'linewidth',2), axis([XL XR -1 1]), drawnow
  =======
  >>>>>>> origin/master
  end

We add, commit and push 


Merge conflict
==============

::

  $ git add .
  $ git commit -m "Fixed conflict in main.m"
   [master 3018a7b] Fixed conflict in main.m
  $ git status
   On branch master
   Your branch is ahead of 'origin/master' by 2 commits.
     (use "git push" to publish your local commits)
  $ git push
   Counting objects: 9, done.
   Delta compression using up to 4 threads.
   Compressing objects: 100% (9/9), done.
   Writing objects: 100% (9/9), 1.05 KiB | 1.05 MiB/s, done.
   Total 9 (delta 2), reused 0 (delta 0)
   remote: Resolving deltas: 100% (2/2), completed with 1 local object.
   To https://github.com/appelo/Lecture_3.git
   8c5cf71..3018a7b  master -> master
  $ 


.. slide::  

   .. figure:: L3p7.pdf
    :class: fill
    :width: 800px
  
Lab work
==============

Repeat the example for the problem of solving  :math:`f(x) = x^2-a = 0`
with:

1. Newton's method,
2. secant method and.
3. bisection.

- Start a file and a repository as a group. 
- Each member clones the repo and adds their feature.  
