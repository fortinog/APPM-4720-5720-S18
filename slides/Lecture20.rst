++++++++++
Lecture 20
++++++++++
 
**OpenMP**


What is OpenMP?
===============

 * OpenMP is a collection of compiler directives and library routines for parallel shared memory programs.

 * Thread A, B, C & D share memory. Fork - Join Model! 

  .. image:: http://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Fork_join.svg/800px-Fork_join.svg.png
     :width: 600

``http://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Fork_join.svg/800px-Fork_join.svg.png``


How does OpenMP work?
=====================

 * The idea is to take your serial code and "convert it" in such a way that you can still run it in serial mode.
 * This is done by two **directive sentinels** 
   
     1. ``!$OMP`` 
     2. ``!$``
    
 * When a non-OpenMP compiler encounters these it will treat those lines as comments.
 * When an OpenMP compiler encounters ``!$`` it will replace it by two whitespaces leading to a **conditional compiling**.
 * OpenMP compiler also knows that ``!$OMP`` will be followed by an OpenMP directive.


Compiler Directives
===================

Used for various purposes:
 
 * Splitting loops 
 * Parallel regions
 * Distributing blocks of code on threads
 * Synchronization 

 Syntax: 

 ``sentinel directive-name [clause, ...]``

 ``!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(A)``


Library Routines:
=================

 * Manipulating the number of threads
 * Inquiring 
 * Wall clock time

``!$ call OMP_set_num_threads(8)``

``!$ my_id = OMP_get_thread_num()``

``time2a = omp_get_wtime()`` 
 

ENVIRONMENTAL VARIABLES
=======================

Controls the execution of parallel code at run-time.

 * Manipulating the number of threads
 * Nested parallelism
 * Stack size
 * ``export OMP_NUM_THREADS=8``


A simple example
================

.. code-block:: fortran
   :linenos:
   :emphasize-lines: 2,6,8,10,15

   program OMPtest
    !$ use omp_lib
    IMPLICIT NONE
    integer :: my_id,n_threads,i
    real(kind = 8) :: sum
    !$ call OMP_set_num_threads(8)
    sum = 0.d0
    !$OMP PARALLEL PRIVATE(my_id,i,sum)
    my_id = 1
    !$ my_id = OMP_get_thread_num()  
    do i = 1,my_id
       sum = sum + 1.d0
    end do
    write(*,*) "Hello world, I am ", my_id, " my sum is ", sum 
    !$OMP END PARALLEL
    end program OMPtest


A simple example
================

.. code-block:: fortran
   :linenos:
   :emphasize-lines: 2,6

   program OMPtest
    !$ use omp_lib
    IMPLICIT NONE
    integer :: my_id,n_threads,i
    real(kind = 8) :: sum
    !$ call OMP_set_num_threads(8)

* Line 2: Use the OpenMP module to have access to subroutines. 
* Line 6: Set the number of threads.


A simple example
================

.. code-block:: fortran
   :linenos:
   :emphasize-lines: 1,3,8

    !$OMP PARALLEL PRIVATE(my_id,i,sum)
    my_id = 1
    !$ my_id = OMP_get_thread_num()  
    do i = 1,my_id
       sum = sum + 1.d0
    end do
    write(*,*) "Hello world, I am ", my_id, " my sum is ", sum 
    !$OMP END PARALLEL

* The code between ``!$OMP PARALLEL`` and ``!$OMP END PARALLEL`` will be executed in parallel.  


Compiler flags
==============

.. code-block:: make
   :linenos:
   :emphasize-lines: 3,4

   # From my apple
   FC = gfortran
   LD = gfortran
   LDFLAGS = -fopenmp
   F90FLAGS = -fopenmp
   EX = ./OPMtest.x
   OBJECTS = OMPtest.o

   # Compile, run, process and open.
   $(EX): $(MODULES) $(OBJECTS) 
        $(LD) $(LDFLAGS) $(OBJECTS) -o $(EX) 

   # From Stampede
   FC = ifort
   LD = ifort
   LDFLAGS = -openmp
   F90FLAGS = -openmp


Compiling and output
====================

.. code-block:: none
 
    bash-3.2$ make
    gfortran -fopenmp -c OMPtest.f90
    gfortran -fopenmp OMPtest.o -o ./OPMtest.x 
    bash-3.2$ ./OPMtest.x 
    Hello world, I am            4  my sum is    4.0000000000000000     
    Hello world, I am            3  my sum is    3.0000000000000000     
    Hello world, I am            2  my sum is    2.0000000000000000     
    Hello world, I am            1  my sum is    1.0000000000000000     
    Hello world, I am            5  my sum is    5.0000000000000000     
    Hello world, I am            6  my sum is    6.0000000000000000     
    Hello world, I am            0  my sum is    0.0000000000000000     
    Hello world, I am            7  my sum is    7.0000000000000000     

* Order of execution in NOT guaranteed!



Parallel do, buggy version
==========================

.. code-block:: fortran
  :linenos:
  :emphasize-lines: 13-15

  integer, parameter :: n = 1000
  real(kind = 8) :: sum,h,x(0:n),f(0:n)
  !$ call OMP_set_num_threads(8)
  h = 2.d0/dble(n)
  !$OMP PARALLEL DO PRIVATE(i)
  do i = 0,n
     x(i) = -1.d0+dble(i)*h
     f(i) = 2.d0*x(i)
  end do
  !$OMP END PARALLEL DO
  sum = 0.d0
  !$OMP PARALLEL DO PRIVATE(i)
  do i = 0,n-1
     sum = sum + h*f(i)
  end do
  !$OMP END PARALLEL DO
  write(*,*) "The integral is  ", sum 


Output
======

.. code-block:: none

   bash-3.2$ make
   gfortran -fopenmp -c OMPtest2.f90
   gfortran -fopenmp OMPtest2.o -o ./OPMtest.x 
   bash-3.2$ ./OPMtest.x 
   The integral is    -3.9999999999998405E-003
   bash-3.2$ ./OPMtest.x 
   The integral is    -3.9999999999997295E-003
   bash-3.2$ ./OPMtest.x 
   The integral is   -0.14137599999999978     
   bash-3.2$ ./OPMtest.x 
   The integral is    -3.9999999999998960E-003
   bash-3.2$ ./OPMtest.x 
   The integral is    -9.4335999999999975E-002


Parallel do with reduction
==========================


.. code-block:: fortran
  :linenos:
  :emphasize-lines: 12

  integer, parameter :: n = 1000

  h = 2.d0/dble(n)
  !$OMP PARALLEL DO PRIVATE(i)
  do i = 0,n
     x(i) = -1.d0+dble(i)*h
     f(i) = 2.d0*x(i)
  end do
  !$OMP END PARALLEL DO

  sum = 0.d0
  !$OMP PARALLEL DO PRIVATE(i) REDUCTION(+:SUM)
  do i = 0,n-1
     sum = sum + h*f(i)
  end do
  !$OMP END PARALLEL DO
  write(*,*) "The integral is  ", sum 
