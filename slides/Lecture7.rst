.. include:: .special.rst

+++++++++
Lecture 7
+++++++++
 
**Makefiles**


     
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


Numerical integration (quadrature)
==================================================

Consider an integral

.. math::
   :nowrap:
   
   \begin{equation}
     I =  \int_{-1}^1 f(x) g(x) h(x) dx,
   \end{equation}

What method should you use to compute this integral?


Trapezoidal rule (bad option)
==================================================

Recall that for a grid :math:`x_i = X_L + ih, \ \ i = 0,\ldots,n, \ \ h = \frac{X_R-X_L}{n}`, the composite trapezoidal rule is:

.. math::
   :nowrap:
  
   \begin{equation}
     \int_{X_L}^{X_R} f(x) dx \approx h\left(\frac{f(x_0)+f(x_n)}{2} + \sum_{i=1}^{n-1} f(x_i) \right).
   \end{equation}

For fun: write a Fortran program that uses the composite trapezoidal rule to approximate any integral for :math:`n = 2,3,\ldots,N`.

There is **ONE** situation where trapezoidal rule is the go-to
method. Which situation am I talking about?

The trapezoidal rule belongs to a class of quadrature called Newton-Cotes quadrature that approximates integrals using equidistant grids. The order of a composite Newton-Cotes method is typically :math:`s` or math:`s+1`, where :math:`s` is the number of points in each panel (2 for the Trapezoidal rule). 

Gauss Quadrature
==================================================

Another class of methods is Gauss quadrature. In Gauss quadrature the location of the grid-points (usually referred to as nodes) and weights, :math:`\omega_i`, are chosen so that the order of the approximation to the weighted integral   

.. math::
   :nowrap:
  
   \begin{equation}
     \int_{-1}^{1} f(z) w(z) dz \approx \sum_{i=0}^n \omega_i \, f(z_i), 
   \end{equation}

is maximized. Here the weight function :math:`w(z)` is positive and integrable (for example :math:`w(z) = 1`.) For a given :math:`w(z)` the nodes, :math:`z_i` are the zeros of the polynomial :math:`\tau_n = (z-z_0)(z-z_1)\cdots(z-z_n)` satisfying 

.. math::
   :nowrap:
  
   \begin{equation}
     \int_{-1}^{1} \tau_n(z) q(z) w(z) dz = 0,
   \end{equation}

for all polynomials :math:`q(z)` of degree less than :math:`n`.

Gauss Quadrature
==================================================

Nodes, :math:`z_i` are the zeros of the polynomial :math:`\tau_n = (z-z_0)(z-z_1)\cdots(z-z_n)` satisfying 

.. math::
   :nowrap:
  
   \begin{equation}
     \int_{-1}^{1} \tau_n(z) q(z) w(z) dz = 0,
   \end{equation}

for all polynomials :math:`q(z)` of degree less than :math:`n`. Or,
equivalently, the nodes are the zeros to the degree :math:`n`
orthogonal polynomial associated with the weight function
:math:`w(z)`. Don't worry if this sounds complicated, we will only
consider the case :math:`w(z) = 1` and obtain the weights by
computation. For example you can use the repository subroutine ``lglnodes.f90`` (which is a f90 version of Greg von Winckel's matlab version.) 
 
.. code-block:: fortran

     call lglnodes(x,w,n)
     f = exp(cos(pi*pi*x))
     Integral_value = sum(f*w)


RECAP: Compiling, linking and building an executable
======================================================================

   .. code-block:: none

     $ gfortran -c type_defs.f90		   
     $ gfortran -c quat_module.f90		   
     $ gfortran -c apa.f90
     $ gfortran -o apa.x apa.o quad_module.o type_defs.o
     
Once the number of files become moderately large this method does not
work and we will use make instead. 



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
