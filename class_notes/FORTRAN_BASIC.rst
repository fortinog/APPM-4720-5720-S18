.. -*- rst -*- -*- restructuredtext -*-

==============
Fortran basics
==============

Intro
=====
FORTRAN stands for FORmula TANSlator. The first version, Fortran I, came out in 1954. 
The earlier versions, I, II, III, IV and Fortran 66 are all but forgotten 
but the more modern Fortran 77 is still very much in use. The version we will use is Fortran 90/95 
which, unlike the hyper-modern Fortran 2003 and 2008, is supported by most compilers.

These notes are in no way an complete description of all the aspects of Fortran but rather a sequence of examples introducing some basic concepts. For more in-dept coverage I list some alternative sources at the bottom of this page.



Example program 1, ex1.f90
==========================

.. code-block:: fortran
 :linenos:

 ! A very simple exmple for math 471
 program ex1
   implicit none
   real(kind=8) :: a,b,c
 
   a = 1.d0
   b = exp(A)
   c = a+b
   print *, "The output is = ", c
 end program ex1

Notes:

 * In Fortran comments start with an exclamation mark, !, and continue until the end of the line. 
 * A fortran program always starts with the ``program [name]`` statement and ends with the statement ``end program [name]``. 
 * The ``implicit none`` statement on line 3 tells the compiler that all variables will be explicitly declared (you should always use this!). 
 * The variables ``a,b,c`` are real numbers stored in 8 bytes (a.k.a. double precision), note that Fortran is case insensitive so ``a`` and ``A`` are the same. 
 * The notation ``1.0d0`` indicates that the number is double precision.  
 * There are many built-in ``intrinsic`` functions, for example most mathematical functions such as ``exp``, ``log``, ``sin`` etc.
 * To print to screen the ``print`` command can be used, the ``*`` indicates that "As much information as possible" should be displayed.


Fortran is a compiled language where you write the program in one or more
**source files** that are compiled into **objects** that are linked together 
to produce an **executable** which can be run in the shell. Here is an example of how the above code can be compiled and linked / loaded into an executable:

.. code-block:: none

 $ gfortran -c ex1.f90
 $ gfortran -o ex1.x ex1.o
 $ ./ex1.x 
 The output is =    3.7182818284590451     


Example program 2, loops.f90
============================
This second example illustrates the use of loops and the ``if then else`` statement. The code does not really do anything useful but is meant to illustrate that one has to be careful when performing arithmetic operations with different types. If you are only used to programming in Matlab this may cause some hardship for you.

The first if statement illustrates the difference between single and double precision. Here ``dble(i)*pi`` is a double precision computation while the computation ``c = c + pi`` is stored in a single precision number resulting in that the relative difference ``abs(dble(i)*pi-c)/(dble(i)*pi)`` is of the order :math:`10^{-8}`.

The second and third parts of the if statement shows how integer division "floors" (2/3) to 0, while  (3/3) = 1.

.. code-block:: fortran
   :linenos:
  
   integer, parameter :: n = 3
   real(kind = 8), parameter :: pi = 3.1415926535897932d0
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

Notes: 
 
 * The ``parameter`` attribute tells the compiler that the variables that are declared with that attribute will not change. 
 * If a variable is declared as real it will usually become ``real(kind=4)``, i.e. single precision. If you always want to default to ``real(kind = 8)`` you can use the compiler flag ``-fdefault-real-8`` (assuming you are using ``gfortran``). I would not recommend this, it is better to try to be consistent in declaring variables to be whatever precision you want them to be.  
 * Note that the control statement can be expressed either with letters or symbols 

.. code-block:: fortran
 
  (a < b)  same as  (a.lt.b)
  (a <= b)          (a.le.b)
  (a > b)           (a.gt.b)
  (a >= b)          (a.ge.b)
  (a == b)          (a.eq.b)

Executing the above code yields 

   .. code-block:: none

     ./
     1   2.7827535191837951E-008 F
     2   0.0000000000000000      F
     3   3.1415926535897931      T


Example program 3, pfun.f90
===========================
There are two kinds of procedures in Fortran, functions and subroutines. A function returns a single scalar variable of some designated type but can take multiple inputs. The code below shows how to compute the square of a double precision number ``x`` using a function.   

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

Notes: 
 * Functions must be declared as ``external``. 
 * Use intent(in) to help the compiler know that the variable ``x`` won't be changed inside the function. 
 * The ``Write`` statement can also be used to output the results (instead of ``print``.) The first argument takes a file identification number or if you want to output to std out use ``*`` as is done here. The second argument is for specifying the format of the output. Again ``*`` means "as much as possible".


Example program 4, psub.f90
===========================
Below is an example where we use a subroutine for computing the square of ``x``. 

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

Notes:
 * Subroutines does not explicitly return anything but typically change some of the arguments that it is called with.  
 * Subroutines does not have to be declared. 
 * The intent specification help the compiler (and the programmer) to recognize what is to be changed inside the subroutine and what is not.  


Program 5, psub_bugs.f90
========================
As in example 2, it is important to be careful with types when calling functions and subroutines. If the program below we show what happens when a subroutine intended to be called with 8 byte numbers is called with a real(kind = 4) number and an integer.   

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

Below is the output. Again, not what you expect if you are used to working with Matlab.

.. code-block:: none

 $ gfortran psub_bugs.f90; ./a.out 
  x =    3.0000000000000000      and y =    9.0000000000000000     
  x =    3.00000000     and y =    0.0000000000000000     
  x =            3 and y =                   Infinity
  $ 
