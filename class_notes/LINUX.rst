.. -*- rst -*- -*- restructuredtext -*-

=================================
The Linux / Unix operating system
=================================


Shells
++++++

A shell is a program that allows you to interact with the operating system. In this class you will mainly use the `BASH`__ shell. You are probably already familiar with the Matlab shell (or ''Matlab command window'' if you are using a GUI version of Matlab.) 

In the shell you will have a ``prompt`` (usually denoted by ``$`` or ``>>``) where you can type in commands to the operating system. For example if you have forgotten, you can ask ``$ whoami``. There are other commands that are a bit more useful: 


``pwd``, ``cd``, ``mkdir``, ``ls``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The command ``pwd`` prints the working directory, i.e. where your prompt is located in the directory structure. If you want to change the directory you use ``cd``. For example if I am stainding in ``/home/appelo/`` and want to change to ``/home/appelo/repos/math471`` I would just type ``$ cd repos`` and then  ``$ cd math471`` or alternatively I could type ``$ cd repos/math471`` and change two levels at one. The command ``cd`` (and most other commands) can take a *relative* (as above) or *absolute* path. The absolute path starts from the *root directory* ``/`` so we could also type ``$ cd /home/appelo/repos/math471`` with the same result as above. If you want to go up (towards the root) you can use ``$ cd ..`` which brings you up one level. 

If you need to make a new directory use ``$ mkdir dir_name``. 

A very useful command is ``ls`` which lists files and directories

.. code-block:: none

   $ls
   README.rst      notes           slides


The command ``ls`` can be executed with a lot of different flags (see ``man ls``), I find the flags ``-ltr`` which provides a long listing with the latest modified file/directory at the bottom:

.. code-block:: none

   $ls -ltr
   total 8
   -rw-r--r--   1 appelo  staff  451 Aug  4 16:04 README.rst
   drwxr-xr-x  10 appelo  staff  340 Aug 18 08:59 slides
   drwxr-xr-x  21 appelo  staff  714 Aug 18 15:28 notes


Displaying the content of files
+++++++++++++++++++++++++++++++

The commands ``less``, ``more``, ``head`` and ``tail`` can all be used to display the contents of files. ``less`` is somewhat more than ``more`` as it can scroll both up and down. The commands ``head`` and ``tail`` displays the first and last lines of a file. The default number of lines is 10 but that can be adjusted to, say, 21 by giving the flag ``$ tail -n 21``, where ``-n`` sets the number of lines to be displayed.    


Copy, move and delete 
+++++++++++++++++++++

The commands that copy, move and delete files and directories are ``cp``, ``mv`` and ``rm``. Typically you would do something like ``$ cp original.txt copy.txt`` 


These commands also come with many options, for example if you want to copy a directory and all its sub-directories you will have to use the flag ``-r``, that is: ``$ cp -r odir cdir``. The move command  ``mv`` works very much like the copy command. 

To remove files the command to use is ``rm``, again with the option to be executed with flags such as ``-f`` for force or ``-r`` for descending into sub-directories.  


Logging in to a remote computer
+++++++++++++++++++++++++++++++

To login to a remote computer you can use the `secure shell`__, for example to login to ``linux.unm.edu`` you would type: 

.. code-block:: none

 ssh -X appelo@linux.unm.edu

Here the ``-X`` starts the X-server so you can open windows locally on your machine. The result of the above command is the following (angry) message

.. code-block:: none


 ========================================================================
 =                       WARNING NOTICE TO USERS                        =
 =                        Authorized uses only.                         =
 =             All activity may be monitored and reported.              =
 ========================================================================
 appelo@linux.unm.edu's password: 
 Last login: Wed Aug 21 15:54:53 2013 from valhall.math.unm.edu
 
 
          ---------------------------------------
               linux.unm.edu  ftp.unm.edu
          ---------------------------------------
 
 
    Popular Packages:
 
    SAS 9.2  | Matlab  R2011a |  Maple  v12 | Subversion 1.6
    Java 1.6 | PINE: ALPINE (which is PINE)
    GCC, G++ and GNU Fortran, Ruby, Perl, Python, GNU assembler
 


Environment variables
+++++++++++++++++++++ 

The bash shell uses environment variables to keep track of various information. These can be displayed by the command ``printenv`` or simply ``env``. Executing this may give an output that looks something like this: 

.. code-block:: none

 [appelo@mizar ~]$ printenv
 HOSTNAME=mizar.unm.edu
 SHELL=/bin/bash
 USER=appelo
 PATH=/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/nfs/user/a/appelo/bin
 PWD=/nfs/user/a/appelo
 HOME=/nfs/user/a/appelo
 LOGNAME=appelo
 _=/usr/bin/printenv

The environment variables can be accessed through the dollar sign, for example ``ls -ltr $PWD`` would list the content of the current directory. The underscore environment variable holds the last command you executed and can be useful, if you don't want to type in a long command again just type ``$_``.


The search path
+++++++++++++++

The variable ``PATH`` is a list of the directories where the shell searches for the commands you are trying to execute. So if you install some software in a new location, say ``HOME/newbin``, you may want to append ``PATH`` by using the ``export`` command

.. code-block:: none
  
  export PATH=$PATH:$HOME/newbin

The search paths are separated by a colon. If you want the added directory to be searched first you can prepend the ``PATH`` instead
 
.. code-block:: none
  
  export PATH=$HOME/newbin:$PATH


The .bashrc file
++++++++++++++++

Whenever you open a new terminal the file ``$HOME/.bashrc`` is executed so if you always want to append the ``PATH`` variable or do other permanent changes you can add them to the ``.bashrc`` file. For example you can redefine ``ls`` to color the output by adding the line ``alias ls='ls -G'``.  

-------------------

A good resource for reading more about shells and Linux/Unix is `software-carpentry`__.

__ http://en.wikipedia.org/wiki/Bash_(Unix_shell)
__ http://software-carpentry.org/v5/novice/shell/index.html
__ http://en.wikipedia.org/wiki/Secure_Shell


