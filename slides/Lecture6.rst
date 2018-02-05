.. include:: .special.rst

+++++++++
Lecture 6
+++++++++
 
**More Fortran**


Recap
========
Fortran is a compiled language where you write the program in one or more **source files** that are compiled into **objects** that are linked together to produce an **executable**. 

:red:`Intrinsic Data Types:`

* INTEGER (numeric)
* REAL (numeric) 
* COMPLEX (numeric) 
* CHARACTER (non-numeric) 
* LOGICAL (non-numeric) 

:red:`Defining precisions`  
  
   .. code-block:: fortran

     use iso_c_binding
     integer, parameter:: sp = c_float
     integer, parameter:: dp = c_double
     integer, parameter:: li = c_long



Arrays
======================

* Arrays are very flexible in Fortran.
* The first dimension is contiguous in memory.
* Dynamic allocation by ``allocate``  

  .. code-block:: fortran

     real, dimension(-1:3) :: a
     real(-2:2) :: b
     real, dimension(3,0:2) :: c
     integer, parameter :: n = 10
     integer, dimension(n,n,n,n) :: i4
     real, allocatable, dimension(:,:) :: a

     allocate(a(10,0:33)) 
     deallocate(a)


Control Constructs 
============================================

  .. code-block:: fortran

     if (i .ge. 3) then
         p = 1.0
     else if (i .eq. 1) then 
         p = 2.0
     else
         p = 1.0
     end if		  

  .. code-block:: fortran

     n = 10 ; stride = 2
     sum = 0.0
     do i = 1,n,stride 
       sum = sum + 1.0
     end do

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

  

     
     

User defined types
============================================
     
A basic example: quaternions :math:`q = a+bi+cj+dk`


    .. code-block:: fortran

     module quat_module
       use type_defs
       implicit none
       !
       type quat
         real(kind=dp) :: q(4)
       end type quad

     contains
      subroutine get_real(qt,qt_real)
       use type_defs
       type(quat), intent(in) :: qt
       real(dp), intent(out)  :: qt_real

       qt_real = qt%q(1)
      end subroutine 
     end module quat_module
     

Alternative
============================================

   .. code-block:: fortran

     module quat_module
       use type_defs
       implicit none
       ! Alternative
       type quat
         real(kind=dp) :: qim(3)
         real(kind=dp) :: qre
       end type quad
     contains
      subroutine get_inv(qt,qt_inv)
       use type_defs
       type(quat), intent(in) :: qt
       type(quat), intent(out) :: qt_inv
       real(kind=dp) :: di
        di = 1.0_dp / (sum((qt%qim)**2) + (qt%qim)**2)
	qt_inv%qre = di*qt%qre
	qt_inv%qim = -di*qt%qim
      end subroutine 
     end module quat_module
     

Main program
===================================

   .. code-block:: fortran

      program apa
       use type_defs
       use quat_module
       implicit none
       type(quat)  :: q1,q2,q3
       q1%qre = 1.0_dp
       q1%qim = 1.0e3_dp
       call get_inv(q1,q2)
       call get_inv(q2,q3)
      end program apa

Compiling, linking and building an executable
======================================================================

   .. code-block:: none

     $ gfortran -c type_defs.f90		   
     $ gfortran -c quat_module.f90		   
     $ gfortran -c apa.f90
     $ gfortran -o apa.x apa.o quad_module.o type_defs.o
     
Once the number of files become moderately large this method does not
work and we will use make instead. 

Walk through Subroutines Array Exampe
======================================================================


     
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

