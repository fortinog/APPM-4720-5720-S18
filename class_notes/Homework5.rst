.. -*- rst -*- -*- restructuredtext -*-

=================================
Homework 5, due 08.00, 15/10-2014
=================================

Parallel Differentiating and integration with OpenPM
----------------------------------------------------

In this homework you will use your code from homework 4 to build a
program that uses shared memory to differentiate and integrate. Most
likely your computer has OpenMP so you should be able to do most of
the development locally and just run the timing tests on Stampede.

 * First! pick one mapping from the last homework (for example a quarter
   annulus) and check that your code converges with second order. 
 * Next, use OpenMP constructs to parallelize your serial code. Make sure
   you do this in a non-intrusive way so that the code still compiles in
   serial mode. Try to make your program as parallel as possible, I will
   take this into account when grading.  
 * Demonstrate that your code gives the same result independent of
   number of threads used.  
 * Use the ``omp_get_wtime()`` function to time the computational part
   of your code (try to exclude ``allocate`` statements but include
   assignments, where you can use the workshare construct). 
 * Before starting the timing look over your code for places where you
   can optimize it by the techniques discussed in class. Also try out
   some different compiler options. See `this`__ and `this`__.
 * For simplicity set the number of gridpoints the same in both
   directions and time your program with 1 to 16 cores
   for grids of size 20 by 20 to 800 by 800 with increments
   of 1. Display the results in a figure where you scale the wall
   clock time by the inverse of the size of the grid, :math:`n_r \times n_s`. This should
   give you roughly straight lines with jumps when you hit cache
   size limits.  
 * Weak scaling. Compute the speedup and efficiency (1-16 cores) for fixed
   problem size. Try a small grid and a larger grid. 
 * Strong scaling. Compute the speedup and efficiency (1-16 cores) for
   grids with a fixed number of gridpoints per core.  
 * Count (by hand by looking at the code) the number of floating point
   operations you perform in the differentiation and add a timing to
   that part of the code. For the 800 by 800 case report how many
   floating points per second you get and compare to the `theoretical
   maximum.`__ 


As usual, arrange your results neatly in your report and comment on
them. This time, also discuss the ways you made your code parallel and
what, if anything, you could improve.   

__ https://www.tacc.utexas.edu/user-services/user-guides/stampede-user-guide#overview-specs-compute
__ https://www.tacc.utexas.edu/user-services/user-guides/stampede-user-guide#overview-specs-compute
__ https://www.tacc.utexas.edu/user-services/user-guides/stampede-user-guide#overview-specs-compute



.. Shared, distributed and hybrid memory models. 


