.. include:: .special.rst
	     
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

 ! A very simple example 
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

FORTRAN stands for :red:`FOR` mula :red:`TRAN` slator and came to use with then first version Fortran I in 1954. Versions II, III, IV and Fortran 66 are all but forgotten but the more modern Fortran 77 is still very much in use.

The version we will use is a mix of Fortran 90/95/2003. Mainly we will
use features that were introduced already in F90 but we will also need
some features from 95/2003. Many of the features in the more modern
Fortran standards make the language look more like C / C++ but we
won't touch on these at all.  


Fortran Syntax 
==============

* Unlike e.g. perl Fortran is case insensitive.

* In Fortran 77 there are some quirky rules for the syntax. For example each line may have a fixed length (typically 72 characters) and has to start with 6 blanks. This is requirements carried over from the days of punch cards. 

* In modern Fortran each line can contain 132 characters but every
  line can be continued by `&` (up to 39 times in F95 and more in F2003). 

  .. image:: FortranCard.jpg
   :width: 540px


Fortran Language Elements
============================

* Characters: a-z, 0-9, _, =, +, etc.
* Tokens (separators): / (  ) (/ /) => : :: ; %
* Tokens (operators): ** + -  .not.  .and.  .or. //  etc.
* Keywords: if do where forall select case etc.
* Keywords(with or without space): enddo or end do,  go to or goto, etc.

:red:`Intrinsic Data Types:`

* INTEGER (numeric)
* REAL (numeric) 
* COMPLEX (numeric) 
* CHARACTER (non-numeric) 
* LOGICAL (non-numeric) 

Integers
============================

* An integer is simply.... an integer like 1, 2, 0, -2, 1234.  
* The :blue:`range` of an integer is not specified in the language but
  typically it is :math:`-2^{n-1}` to :math:`+2^{n-1} -1` with
  :math:`n` being the word size in bits. So on a 32-bit computer the
  range would be -2147483648 to 2147483647. 
* Fortran allows for you to select the range by

  .. code-block:: fortran

   integer, parameter :: k3 = selected_int_kind(3)
   integer (kind = k3) :: i,j,k
   ! integer (k3) :: i,j,k ! Alternative form
   ! i,j,k are in the range -999,999 

   i = 22_k3 ! Makes sure 22 is of kind k3 
   
Real
============================

* Real numbers also have range as specified by
  ``selected_real_kind(D,E)`` where ``D`` is number of digits and
  ``E`` is the exponent. 
* Old Fortran often used ``DOUBLE PRECISION`` which is not strictly
  set in standard, although in practice it is often the same as ``selected_real_kind(15, 307)`` 
* On the next slide are some options for declaring a "double precision" real. 

Real
============================

   .. code-block:: fortran

     integer, parameter :: dp = selected_real_kind(15, 307)   
     ! Or
     integer, parameter :: dp = kind(1.d0)
     ! Or all of single, double and quad
     integer, parameter ::                              &
      sp = kind(1.0),                                &
      dp = selected_real_kind(2*precision(1.0_sp)),  &
      qp = selected_real_kind(2*precision(1.0_dp))
     ! Or by the F2008 iso standard
     use, intrinsic :: iso_fortran_env
     integer, parameter :: sp = REAL32
     integer, parameter :: dp = REAL64
     ! If you are planning to mix and match with C 
     use iso_c_binding
     integer, parameter:: sp = c_float
     integer, parameter:: dp = c_double
     integer, parameter:: li = c_long
     real(kind = dp) :: x,y,z
     integer(kind = li) :: ii,jj,kk

Watch out for single precision bugs!!!
========================================================
     
  .. code-block:: fortran

     program apa1
       use, intrinsic :: iso_fortran_env
       implicit none
       real(REAL64), parameter :: pi_1 = 3.141592653589793238462643383279502884197169_REAL64
       real(REAL64), parameter :: pi_2 = 3.141592653589793238462643383279502884197169
       write(*,*) pi_1-acos(-1.d0), pi_1-acos(-1.0)
       write(*,*) pi_2-acos(-1.d0), pi_2-acos(-1.0)
       write(*,*) pi_1, pi_2
     end program apa1
     
  .. code-block:: none

   $ gfortran apa1.f90 
   $ ./a.out 
     0.0000000000000000       -8.7422780126189537E-008
     8.7422780126189537E-008   0.0000000000000000     
     3.1415926535897931        3.1415927410125732          


Scalars and Arrays
======================

* The different numerical types can be scalars or arrays.
* Arrays are very flexible in Fortran and can have 7 dimensions (rank)
  or 15 for those compilers (Intel but not gfortran) that support it
  (F2008 standard). 
* Some examples:       

  .. code-block:: fortran

     real, dimension(-1:3) :: a
     real(-2:2) :: b
     real, dimension(3,0:2) :: c
     integer, parameter :: n = 10
     integer, dimension(n,n,n,n) :: i4

* Accessing elements in an array   

  .. code-block:: fortran

     a(-1:3:2) = 1.0
     b(:) = a(:) 

Allocating Memory for Arrays
============================================

* Explicit-shape arrays in the beginning of the main program are
  allocated at compile/run time.
* Deferred-shape arrays can be ``allocatable`` or ``pointers``   

  .. code-block:: fortran

     real, allocatable, dimension(:,:) :: a
      
     allocate(a(10,0:33)) 

     ! Stuff ...

     deallocate(a)

We will talk more about arrays once we discuss subroutines.      

Control Constructs
============================================

The ``if else`` statement: 

  .. code-block:: fortran

     if (i .ge. 3) p = 1.0
     if (i .ge. 3) then
         p = 1.0
     end if		  

  .. code-block:: fortran

     if (i .ge. 3) then
         p = 1.0
     else if (i .eq. 1) then 
         p = 2.0
     else
         p = 1.0
     end if		  

  .. code-block:: fortran

     name: if (i >=  3) then
              p = 1.0
           end if name		  


Do Construct
============================================

  .. code-block:: fortran

     n = 10 
     sum = 0.0
     do i = 1,n,3 
       sum = sum + 1.0
     end do
	   
  .. code-block:: fortran

     do i = j+4,m,-k(j)**2 
       sum = sum + 1.0
     end do

  .. code-block:: fortran

     i = 1 		   
     do 
       i = i*(i+1)
       if (i .le. 10) exit
     end do

Do Construct
============================================

:red:`Preferred`

  .. code-block:: fortran

     do j = 1,10
       do i = 1,10 
         a(i,j) = 1.0 
       end do
     end do

:red:`Slower`
     
  .. code-block:: fortran

     do i = 1,10
       do j = 1,10 
         a(i,j) = 1.0 
       end do
     end do

Case Construct
============================================

  .. code-block:: fortran

     select case (number)   ! numer is an integer
     case (:-1)                    ! all values below 0   
       sgn = -1
     case (0)                       ! only 0
       sgn = 0
     case (1:)                     ! all values above 0   
       sgn = 1
     end select

Questions? Examples
============================================
  

Example program 2, loops.f90
============================

.. code-block:: fortran

   integer, parameter :: n = 3
   real(kind = dp), parameter :: pi = 3.141592653589793238462643383279_dp
   integer :: i 
   real(kind = dp) :: a
   real :: c = 0.0
   logical :: correct  
   do i = 1,n
      if ( i < 2) then
         c = c + pi ; a = abs(dble(i)*pi-c)/(dble(i)*pi) ; correct = .false.
      elseif (i == 2) then
         a = (i/n)*pi ; correct = .false.
      else
         a = (i/n)*pi ; correct = .true.
      endif
      print *, i, a, correct
   end do


.. slide:: 
   :level: 2
 
   Be careful with single/double precision!

   .. code-block:: fortran

     real(kind = dp) :: a
     real :: c = 0.0
     logical :: correct  
     do i = 1,n
        if ( i < 2) then
           c = c + pi ; a = abs(dble(i)*pi-c)/(dble(i)*pi) ; correct = .false.
        elseif (i == 2) then
           a = (i/n)*pi ; correct = .false.
        else
           a = (i/n)*pi ; correct = .true.
        endif
        print *, i, a, correct
     end do

   .. code-block:: none

     1   2.7827535191837951E-008 F
     2   0.0000000000000000      F
     3   3.1415926535897931      T


Example program 3, pfun.f90
===========================

.. code-block:: fortran

 program pfun
   implicit none
   real(dp) :: x,y
   real(dp), external  :: myfun
   x = 3.d0
   y = myfun(x)
   write(*,*) "x = ",x, "and y = ",y
 end program pfun

 real(dp) function myfun(x)
   real(dp), intent(in) :: x
   myfun = x*x
 end function myfun

External functions must be declared as ``external``. Use intent to
help the compiler. ``Write`` instead of ``print``. The function is
external although it is in the same file as the program. It is outside
the program statement.

:red:`This function is pure, it does not have any side effects.`

Example program 4, psub.f90
===========================

.. code-block:: fortran

 program psub
   implicit none
   real(dp) :: x,y
   x = 3.0_dp
   call mysub(x,y)
   write(*,*) "x = ",x, "and y = ",y
 end program psub 
 
 subroutine mysub(x,y)
   implicit none
   real(dp), intent(in)  :: x
   real(dp), intent(out) :: y
   y =  x*x
 end subroutine mysub

Subroutines does not return anything and does not have to be declared.  


Program 5, psub_bugs.f90 
====================================================================

:red:`BE CAREFUL WITH ARGUMENTS!!! They are typically NOT checked`

.. code-block:: fortran

 program psub_bugs
   implicit none
   real(dp) :: x,y
   real(sp) :: s
   integer :: k
   x = 3.0_dp ; s = 3.0_sp ; k = 3
   call mysub(x,y) ; write(*,*) "x = ",x, "and y = ",y
   call mysub(s,y) ; write(*,*) "x = ",s, "and y = ",y
   call mysub(k,y) ; write(*,*) "x = ",k, "and y = ",y
 end program psub_bugs

.. code-block:: none

 $ gfortran psub_bugs.f90; ./a.out 
  x = 3.0000000000000000  and y = 9.0000000000000000     
  x = 3.00000000          and y = 0.0000000000000000     
  x = 3                   and y = Infinity


Program units
===================================

There are three program units in Fortran

* ``PROGRAM``
* ``MODULE``
*  Subprogram i.e. ``SUBROUTINE`` / ``FUNCTION``     

.. slide::  
   
   .. figure:: L5p1.pdf
    :class: fill
    :width: 850px

  

What to think about for dG
============================


 +---------+-----------------------------------------------+ 
 | |pic1|  +  1. Compute integrals                         +
 |         +  2. Approximate solution by polynomial        +
 |         +  3. Store solution on each element            +
 |         +  4. Line / surface / volume integrals         +
 |         +  5. Map from reference element and each elem. +
 |         +  6. Change of variables...                    +
 +---------+-----------------------------------------------+ 

.. |pic1| image:: L5p2.pdf
   :width: 600px


 
