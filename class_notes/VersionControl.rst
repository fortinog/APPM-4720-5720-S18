.. -*- rst -*- -*- restructuredtext -*-

===================================
Reproducibility and Version Control
===================================

`Reproducibility`__ is one of the cornerstones of the scientific method and as computational science is increasingly becoming an alternative to costly experiments it is natural that the computational science community adopts the openness and *full disclosure* practices of experimental sciences, see for example `this Science opinion piece`__. Other interesting reads are `this piece`__ and the `sciencecodemanifesto.org`__

__ http://en.wikipedia.org/wiki/Reproducibility
__ http://www.nature.com/news/2010/101013/full/467753a.html
__ http://www.nature.com/news/2010/101013/full/467775a.html
__ http://sciencecodemanifesto.org

At the heart of reproducibility in computational sciences are the use of version control software (VCS). VCS allows you to keep track of the development of your software so that you can easily go back in the history of the software if needed. This can be highly useful in many situations. For example if you use your code to compute some results for a paper but realize a year later when you get the reviews back that you should have used 1.32 for some parameter, not 1.23. Most likely your code will have changed significantly in one year but if it is under version control it will be trivial to redo the computation! 

Another example could be when you decide to add some new feature to your code but you don't quite think through all the implications of the change until later. With version control you can just check out an old copy and start again.

Larger software projects with multiple developers are almost always under version control so that different developers can work simultaneously on different parts of the code. For larger projects it is also very important to have some kind of `unit testing`__.  

__ http://en.wikipedia.org/wiki/Unit_testing.

The most basic version control you can use is to simply make a new copy of a file every time you make a significant change. This works ok-ish if you are continuously working on the file, however if you work on some other project for a week it is not so easy to remember if it was ``file_a2.f90``, ``file_b1.f90`` or ``file_new.f90`` that was the last version you used. Even harder is to remember what changes were made in between two versions. This is where VCS comes in. The typical VCS allows you to store all versions (or at least the differences between versions) of your file set along with user supplied information about what changed. In this course we will use `GIT`__ which is a distributed VCS. Other commonly used VCS are Subversion (or SVN), CVS and Mercurial. 

The course information about GIT can be found in :ref:`GIT`.


__ http://git-scm.com
