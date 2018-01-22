+++++++++
Lecture 7
+++++++++
 
**Finite Differences, More Fortran, and Makefiles**

Recap
=====

We saw that Taylor series could be used to find approximations to derivatives. Let :math:`x_i + h = x_{i+1}` and denote :math:`f_i = f(x_i)` then: 

.. math::
   :nowrap:
   
   \begin{eqnarray}
     f_{i+1} \approx f_i + h \frac{d f_i}{d x} + \frac{h^2}{2} \frac{d^2 f_i}{d x^2} + \frac{h^3}{6} \frac{d^3 f_i}{d x^3} + \mathcal{O}(h^4), \\ 
     f_{i-1} \approx f_i - h \frac{d f_i}{d x} + \frac{h^2}{2} \frac{d^2 f_i}{d x^2} - \frac{h^3}{6} \frac{d^3 f_i}{d x^3} + \mathcal{O}(h^4).
   \end{eqnarray}

can be combined to 

.. math::
   :nowrap:
   
   \begin{equation}
     \frac{f_{i+1} - f_{i-1}}{2h} \approx \frac{d f_i}{d x} + \mathcal{O}(h^2).
   \end{equation}


Recap
=====

To implement this in Fortran it is convenient to use arrays. 

 1. Arrays in Fortran can be **Allocatable or fixed size**.
 2. Index starts at 1 by default but can be chosen to start at any number. 
 3. Intrinsic functions are element wise (except matmul and transpose).

Arrays in Fortran
=================
**Allocatable or fixed size**

.. code-block:: fortran
 :linenos:
 :emphasize-lines: 3,4
 
 integer, parameter :: n = 3
 integer :: i
 real(kind = 8) :: A(1:3,-2:0), B(n,n) 
 real(kind = 8), dimension(:,:), allocatable :: C

 allocate(C(0:n-1,0:n-1))

 A = 1.d0
 B = 2.d0
 B(3,3) = 0.d0
 C = A+B
 do i = 1,n
  write(*,*) C(i,:) 
 end do  
 deallocate(C)


Arrays in Fortran
=================

.. code-block:: fortran
 :linenos:
 :emphasize-lines: 11
 
 integer, parameter :: n = 3
 integer :: i
 real(kind = 8) :: A(1:3,-2:0), B(n,n) 
 real(kind = 8), dimension(:,:), allocatable :: C

 allocate(C(0:n-1,0:n-1))

 A = 1.d0
 B = 2.d0
 B(3,3) = 0.d0
 C = A+B
 do i = 1,n
  write(*,*) C(i,:) 
 end do  
 deallocate(C)

Arrays in Fortran
=================

.. code-block:: fortran
 :linenos:
 :emphasize-lines: 11 

 integer, parameter :: n = 3
 integer :: i
 real(kind = 8) :: A(1:3,-2:0), B(n,n) 
 real(kind = 8), dimension(:,:), allocatable :: C

 allocate(C(0:n-1,0:n-1))

 A = 1.d0
 B = 2.d0
 B(3,3) = 0.d0
 C = A*B
 do i = 1,n
  write(*,*) C(i,:) 
 end do  
 deallocate(C)



Arrays in Fortran
=================

.. code-block:: fortran
 :linenos:
 :emphasize-lines: 11
 
 integer, parameter :: n = 3
 integer :: i
 real(kind = 8) :: A(1:3,-2:0), B(n,n) 
 real(kind = 8), dimension(:,:), allocatable :: C

 allocate(C(0:n-1,0:n-1))

 A = 1.d0
 B = 2.d0
 B(3,3) = 0.d0
 C = matmul(A,B)
 do i = 1,n
  write(*,*) C(i,:) 
 end do  

 deallocate(C)

Show Demo Example
=================

1. differentiate_v1.f90 
2. Makefile1,  ``$ make  -f Makefile1``

Makefiles
=========

.. code-block:: make
 :linenos:

 # Makefile1
 run_it: diff.x
	 ./diff.x   
 # Compile, run, process and open.
 graph_it: diff.x
         ./diff.x > out.txt
	 nohup matlab -nosplash -nodisplay < plot_err.m > o.txt
	 open -a preview error_v1.eps

 diff.x: differentiate_v1.o 
	 gfortran differentiate_v1.o -o diff.x

 differentiate_v1.o: differentiate_v1.f90 
	 gfortran -c differentiate_v1.f90


Makefiles
=========

.. code-block:: make
 :linenos:
 :emphasize-lines: 10-14 

 # Makefile1
 run_it: diff.x
	 ./diff.x   
 # Compile, run, process and open.
 graph_it: diff.x
         ./diff.x > out.txt
	 nohup matlab -nosplash -nodisplay < plot_err.m > o.txt
	 open -a preview error_v1.eps

 diff.x: differentiate_v1.o 
	 gfortran differentiate_v1.o -o diff.x

 differentiate_v1.o: differentiate_v1.f90 
	 gfortran -c differentiate_v1.f90


Makefiles
=========

.. code-block:: make
 :linenos:
 :emphasize-lines: 1,2,4,5 

 diff.x: differentiate_v1.o 
	 gfortran differentiate_v1.o -o diff.x

 differentiate_v1.o: differentiate_v1.f90 
	 gfortran -c differentiate_v1.f90



General structure is:

.. code-block:: none

 Target: Dependencie(s)
 <TAB> Rule 1 
 <TAB> Rule 2 

For example ``diff.x`` depends on ``differentiate_v1.o`` which in turn depends on ``differentiate_v1.f90``.


Makefiles
=========

.. code-block:: make
 :linenos:

 diff.x: differentiate_v1.o 
	 gfortran differentiate_v1.o -o diff.x

 differentiate_v1.o: differentiate_v1.f90 
	 gfortran -c differentiate_v1.f90


Dependencies are checked by date-stamp.

If the ``.f90`` is newer than ``.o`` file make recreates the ``.o`` file. 



Makefile3, multiple file example
================================

.. code-block:: make
 :linenos:
 :emphasize-lines: 1,2 
 
 diff.x: differentiate_v3.o weights.o lglnodes.o
	 gfortran differentiate_v3.o weights.o lglnodes.o -o diff.x
 differentiate_v3.o: differentiate_v3.f90 
	 gfortran -c differentiate_v3.f90
 weights.o: weights.f 
	 gfortran -c weights.f
 lglnodes.o: lglnodes.f90
	 gfortran -c lglnodes.f90
 
Notes: 
 1. Now diff.x depends on three files.   
 2. The files are compiled in the same way
 3. We can avoid this by using **macros** and **rules**. 

 
Makefile4, Macros and Rules
===========================

.. code-block:: make
 :linenos:
 :emphasize-lines: 1-3,8-11 

 FC = gfortran
 FFLAGS = -O3
 F90FLAGS = -O3
 run_it: diff.x
	 ./diff.x   
 diff.x: differentiate_v3.o weights.o lglnodes.o
	 gfortran differentiate_v3.o weights.o lglnodes.o -o diff.x
 %.o : %.f90
	 $(FC) $(F90FLAGS) -c $<
 %.o : %.f
	 $(FC) $(FFLAGS) -c $<

Notes:
 1. A single rule for all ``.f90`` and ``.f`` files.
 2. ``FC`` is a macro or makefile variable, use by ``$(FC)``. 

Makefile5, Macros and Rules
===========================

.. code-block:: make
 :linenos:
 :emphasize-lines: 6 

 FC = gfortran
 LD = gfortran
 LDFLAGS = 
 FFLAGS = -O3
 F90FLAGS = -O3
 OBJECTS = differentiate_v3.o weights.o lglnodes.o
 .PHONY: clean
 diff.x: $(OBJECTS)
	 $(LD) $(OBJECTS) -o diff.x
 %.o : %.f90
	 $(FC) $(F90FLAGS) -c $<
 %.o : %.f
	 $(FC) $(FFLAGS) -c $<
 clean:
	 rm -f $(OBJECTS) diff.x *.eps out.txt output.txt

Makefile5, Macros and Rules
===========================

.. code-block:: make
 :linenos:
 :emphasize-lines: 7,14,15

 FC = gfortran
 LD = gfortran
 LDFLAGS = 
 FFLAGS = -O3
 F90FLAGS = -O3
 OBJECTS = differentiate_v3.o weights.o lglnodes.o
 .PHONY: clean
 diff.x: $(OBJECTS)
	 $(LD) $(OBJECTS) -o diff.x
 %.o : %.f90
	 $(FC) $(F90FLAGS) -c $<
 %.o : %.f
	 $(FC) $(FFLAGS) -c $<
 clean:
	 rm -f $(OBJECTS) diff.x *.eps out.txt output.txt
