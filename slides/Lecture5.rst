+++++++++
Lecture 5
+++++++++
 
**Basic Fortran**


Intro
=====
Fortran is a compiled language where you write the program in one or more **source files** that are compiled into **objects** that are linked together to produce an **executable**. 

Example program 1, ex1.f90
==========================

program, implicit none, real, print

.. code-block:: fortran

 ! A very simple exmple for math 471
 program ex1
   implicit none
   real(kind=8) :: a,b,c
   
   a = 1.d0
   b = exp(a)
   c = a+b
   print *, "The output is = ", c
 end program ex1

.. code-block:: none

 $ gfortran -c ex1.f90
 $ gfortran -o ex1.x ex1.o
 $ ./ex1.x 
 The output is =    3.7182818284590451     



History
=======

FORTRAN stands for FORmula TANSlator and came to use with then first version Fortran I in 1954. Versions II, III, IV and Fortran 66 are all but forgotten but the more modern Fortran 77 is still very much in use.

The version we will use is Fortran 90/95 which unlike the hyper-modern Fortran 2003 and 2008 is widely supported by compilers.

Fortran Syntax 
==============

* Unlike e.g. perl Fortran is case insensitive.

* In Fortran 77 there are some quirky rules for the syntax. For example each line may have a fixed length (typically 72 characters) and has to start with 6 blanks. This is requirements carried over from the days of punch cards. 

* In the free format used in Fortran 90 there are not any restrictions on line length or on indentation. 


Example program 2, loops.f90
============================

.. code-block:: fortran

   integer, parameter :: n = 3
   real(kind = 8), parameter :: pi = 3.141592653589793238462643383279d0
   integer :: i 
   real(kind = 8) :: a
   real :: c = 0.0
   logical :: correct  
   do i = 1,n
      if ( i < 2) then
         c = c + pi
         a = abs(dble(i)*pi-c)/(dble(i)*pi)
         correct = .false.
      elseif (i == 2) then
         a = (i/n)*pi
         correct = .false.
      else
         a = (i/n)*pi
         correct = .true.
      endif
      print *, i, a, correct
   end do


.. slide:: 
   :level: 2
 
   Be careful with single/double precision!

   .. code-block:: fortran

     real(kind = 8) :: a
     real :: c = 0.0
     logical :: correct  
     do i = 1,n
        if ( i < 2) then
           c = c + pi
           a = abs(dble(i)*pi-c)/(dble(i)*pi)
           correct = .false.
        elseif (i == 2) then
           a = (i/n)*pi
           correct = .false.
        else
           a = (i/n)*pi
           correct = .true.
        endif
        print *, i, a, correct
     end do

     1   2.7827535191837951E-008 F
     2   0.0000000000000000      F
     3   3.1415926535897931      T


New commands
============

.. code-block:: fortran
 
  (a < b)  (a.lt.b)
  (a <= b) (a.le.b)
  (a > b)  (a.gt.b)
  (a >= b) (a.ge.b)
  (a == b) (a.eq.b)
  
  if (a < b) then
   ...
  elseif(a > b) then
   ...
  else
   ...
  endif 

Example program 3, pfun.f90
===========================

.. code-block:: fortran

 program pfun
   implicit none
   real(kind = 8) :: x,y
   real(kind = 8), external  :: myfun
   x = 3.d0
   y = myfun(x)
   write(*,*) "x = ",x, "and y = ",y
 end program pfun

 real(kind = 8) function myfun(x)
   real(kind = 8), intent(in) :: x
   myfun = x*x
 end function myfun

Functions must be declared as ``external``. Use intent to help the compiler. ``Write`` instead of ``print``. 

Example program 4, psub.f90
===========================

.. code-block:: fortran

 program psub
   implicit none
   real(kind = 8) :: x,y
   x = 3.d0
   call mysub(x,y)
   write(*,*) "x = ",x, "and y = ",y
 end program psub 
 
 subroutine mysub(x,y)
   implicit none
   real(kind = 8), intent(in)  :: x
   real(kind = 8), intent(out) :: y
   y =  x*x
 end subroutine mysub

Subroutines does not return anything and does not have to be declared.  


Program 5, psub_bugs.f90
========================

.. code-block:: fortran

 program psub_bugs
   implicit none
   real(kind = 8) :: x,y
   real :: s
   integer :: k
   x = 3.d0 ; s = 3.0 ; k = 3
   call mysub(x,y)
   write(*,*) "x = ",x, "and y = ",y
   call mysub(s,y)
   write(*,*) "x = ",s, "and y = ",y
   call mysub(k,y)
   write(*,*) "x = ",k, "and y = ",y
 end program psub_bugs


.. code-block:: none

 $ gfortran psub_bugs.f90; ./a.out 
  x =    3.0000000000000000      and y =    9.0000000000000000     
  x =    3.00000000     and y =    0.0000000000000000     
  x =            3 and y =                   Infinity
  $ 


