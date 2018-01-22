.. -*- rst -*- -*- restructuredtext -*-

.. _HOMEWORK3:

================================
Homework 3, due 08.00, 12/9-2014
================================

Fortran and numerical integration (quadrature)
----------------------------------------------

Consider the integral

.. math::
   :nowrap:
   
   \begin{equation}
     I =  \int_{-1}^1 e^{\cos(k x)} dx,
   \end{equation}

with :math:`k = \pi` or :math:`\pi^2`. In this homework you will experiment with two different ways of computing approximate values of :math:`I`. After doing this homework you will have written a Fortran program from scratch, called a subroutine that someone else has written and gained some knowledge of the accuracy of some different methods for numerical integration (quadrature). In future homework we will see how these computations can be performed in parallel.

I will talk briefly about the most basic quadrature rules in class, for a more detailed description you can take a look at `Olof Runborg's notes`__. 

__ http://www.nada.kth.se/kurser/kth/2D1250/integral.pdf

Trapezoidal rule
----------------

Recall that for a grid :math:`x_i = X_L + ih, \ \ i = 0,\ldots,n, \ \ h = \frac{X_R-X_L}{n}`, the composite trapezoidal rule is:

.. math::
   :nowrap:
  
   \begin{equation}
     \int_{X_L}^{X_R} f(x) dx \approx h\left(\frac{f(x_0)+f(x_n)}{2} + \sum_{i=1}^{n-1} f(x_i) \right).
   \end{equation}

Write a Fortran program that uses the composite trapezoidal rule to approximate the above integral for both :math:`k` and for :math:`n = 2,3,\ldots,N`, where you should pick :math:`N` so that the absolute error is smaller than :math:`10^{-10}`.

 * In your report, plot the error against :math:`n` using a logarithmic scale for both axis. 
 * Can you read off the order of the method from the slopes? How does this agree with theory? 
 * What is special with the integrand in the case :math:`k = \pi` and why does it make the method converge faster then expected? Hint: take a look at the `Euler-Maclaurin formula`__.

The trapezoidal rule belongs to a class of quadrature called `Newton-Cotes`__ quadrature that approximates integrals using equidistant grids. The order of a composite Newton-Cotes method is typically :math:`s` or math:`s+1`, where :math:`s` is the number of points in each panel (2 for the Trapezoidal rule). 

Gauss Quadrature
----------------

Another class of methods is Gauss quadrature. In `Gauss quadrature`__ the location of the grid-points (usually referred to as nodes) and weights, :math:`\omega_i`, are chosen so that the order of the approximation to the weighted integral   

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

for all polynomials :math:`q(z)` of degree less than :math:`n`. Or, equivalently, the nodes are the zeros to the degree :math:`n` `orthogonal polynomial`__ associated with the weight function :math:`w(z)`. 
 
Don't worry if this sounds complicated, we will only consider the case :math:`w(z) = 1` and obtain the weights and nodes by a call to the subroutine ``lglnodes.f90`` (which is a f90 version of Greg von Winckel's `matlab version`__.) Use the subroutine ``lglnodes.f90`` from the repository and compute the integral by the code below (which implements the above formula): 
 
.. code-block:: fortran

     call lglnodes(x,w,n)
     f = exp(cos(pi*pi*x))
     Integral_value = sum(f*w)

Again:

 * plot the error against :math:`n` using a logarithmic scale for both axis (perhaps in the same figure.) 
 * For Gauss quadrature the error is expected to decrease as :math:`e(n) \sim C^{-\alpha n}`. Try some different :math:`C` and :math:`\alpha` to see if you can fit the computed error curves.    
 

Notes
-----

 1. The errors should look something like the figure below (note that you should label the curves, I left them out on purpose.)

 .. image:: quad_error.png
    :height: 600

 2. For this homework you will call a routine from another file which means that to build your executable you will have to compile two object files and then link them together: 

 .. code-block:: none


  $ gfortran -O3 -c gq_test.f90
  $ gfortran -O3 -c lglnodes.f90
  $ gfortran  -o gq_test.x  gq_test.o lglnodes.o 

 3. A better way of doing this is to use a makefile as was discussed in class. 
 4. It is probably a good idea to use allocatable arrays for ``x,w,f`` above

    .. code-block:: fortran
  
      allocate(x(0:n),f(0:n),w(0:n))
      ...Code here... 
      deallocate(x,f,w)

    as their size will change as you change :math:`n`. Don't forget to deallocate the arrays.
 

__ http://en.wikipedia.org/wiki/Euler-Maclaurin_formula
__ http://en.wikipedia.org/wiki/Newton-Cotes_formulas
__ http://en.wikipedia.org/wiki/Gaussian_quadrature
__ http://people.math.sfu.ca/~cbm/aands/page_773.htm
__ http://www.mathworks.com/matlabcentral/fileexchange/4775-legende-gauss-lobatto-nodes-and-weights/content/lglnodes.m

.. For this particular example we choose :math:`x_L = 0, \, x_R = 1, \, f(x) = \sin(2 \pi x)`.
.. http://amath.colorado.edu/faculty/fornberg/Docs/sirev_cl.pdf

