.. -*- rst -*- -*- restructuredtext -*-

.. _FDApprox:

================================
Finite difference approximations
================================

At the heart of scientific computing is finding approximate solutions to problems arising in engineering and science. Such problems are almost always modeled by ordinary or partial differential equations. An example of an equation used to model mechanical vibrations causing sound is the wave equation:

.. math::
   :nowrap:
   
   \begin{equation}
     \frac{\partial^2 u}{\partial t^2} = c^2 \left( \frac{\partial^2 u}{\partial x^2} + \frac{\partial^2 u}{\partial y^2} + \frac{\partial^2 u}{\partial z^2} \right).
   \end{equation}

Here the solution :math:`u = u(x,y,z,t)` can represent the displacement in a solid, the acoustic pressure or particle velocity or, under certain conditions, the electric or magnetic fields. The quantity :math:`c` is the "speed of sound". 

The above equation is for (3+1) dimensions. In a single dimension it takes the form     
  
.. math::
   :nowrap:
   
   \begin{eqnarray}
     \frac{\partial^2 u(x,t)}{\partial t^2} = c^2 \frac{\partial^2 u(x,t)}{\partial x^2}, \ \ x \in [X_L,X_R], \ \ t>0, \\
     u(x,0) = f_0(x), \ \  \frac{\partial u(x,0)}{\partial t} = f_1(x), \\
     u(X_L,t) = g_L(t), \ \  u(X_R,t) = g_R(t).
   \end{eqnarray}

Here we have included initial conditions (at time :math:`t = 0`) and boundary conditions at the left and right boundary. 

As a computer typically has a **finite amount of memory** we will have to restrict ourselves to finding approximate solutions to the equation at a **finite** number of :math:`x` and :math:`t` values. Eventually we will learn how to solve evolve the solution in time, but for now let's restrict ourselves to how to approximate the spatial derivative on the right hand side.

First we have to choose where ("for what values of :math:`x`") we would like to know the approximate value of the derivative. A natural choice is the **equidistant grid** consisting of the :math:`n+1` **grid points** 

.. math::
   :nowrap:
   
   \begin{equation}
      x_i = X_L + i h, \, i = 0,\ldots,n, \ \ h = \frac{X_R-X_L}{n}. 
   \end{equation} 

Here :math:`h` is the grid spacing which has been chosen such that :math:`x_0 = X_L` and :math:`x_n = X_R`. 

Now, in order to find an approximation to the second derivative we expand the solution in a Taylor series around :math:`x+h` and :math:`x-h`. For notational convenience we suppress the dependence on time and get  


.. math::
   :nowrap:
   
   \begin{eqnarray}
     u(x+h) \approx u(x) + h \frac{\partial u(x)}{\partial x} + h^2/2 \frac{\partial^2 u(x)}{\partial x^2} + h^3/6 \frac{\partial^3 u(x)}{\partial x^3} + h^4/24 \frac{\partial^4 u(x)}{\partial x^4} + \mathcal{O}(h^5), \\ 
     u(x-h) \approx u(x) - h \frac{\partial u(x)}{\partial x} + h^2/2 \frac{\partial^2 u(x)}{\partial x^2} - h^3/6 \frac{\partial^3 u(x)}{\partial x^3} + h^4/24 \frac{\partial^4 u(x)}{\partial x^4} + \mathcal{O}(h^5).
   \end{eqnarray}

Adding these equations together we find: 

.. math::
   :nowrap:
   
   \begin{equation}
     u(x+h) + u(x-h) \approx 2 u(x) + h^2 \frac{\partial^2 u(x)}{\partial x^2} + h^4/12 \frac{\partial^4 u(x)}{\partial x^4} + \mathcal{O}(h^5),
   \end{equation}

which can be rearranged to 

.. math::
   :nowrap:

   \begin{equation}
     \frac{u(x+h) -2 u(x) + u(x-h)}{h^2} -  \frac{\partial^2 u(x)}{\partial x^2}  \approx   + h^2/12 \frac{\partial^4 u(x)}{\partial x^4} + \mathcal{O}(h^3).
   \end{equation}

The finite difference approximation on the left hand side is thus a second order accurate approximation to :math:`\frac{\partial^2 u(x)}{\partial x^2}`. In particular we see that if we choose :math:`x=x_i` and use the fact that :math:`x_i \pm h = x_{i \pm 1}` and also introduce the notation :math:`u_i = u(x_i)` we may write:

.. math::
   :nowrap:

   \begin{equation}
   \frac{\partial^2 u_i}{\partial x^2} =  \frac{\partial^2 u(x_i)}{\partial x^2} \approx \frac{u(x_{i+1}) -2 u(x_i) + u(x_{i-1})}{h^2}  = \frac{u_{i+1} -2 u_i + u_{i-1}}{h^2}. 
   \end{equation}


Biased stencils 
---------------

Assuming that we know :math:`u_i, \, i = 0,\ldots,n` we see that it is not possible to use the above **centered** finite difference stencil at :math:`x_0` and :math:`x_n` as that would require knowing :math:`x_{-1}` and :math:`x_{n+1}`. Instead we can derive **biased** stencils at the end-points of the grid. The idea is the same as above, expand in a Taylor series, but now only around interior points, precisely we expand 

.. math::
   :nowrap:
   
   \begin{eqnarray}
     u_1 \approx u_0 + h \frac{\partial u_0}{\partial x} + h^2/2 \frac{\partial^2 u_0}{\partial x^2} + h^3/6 \frac{\partial^3 u_0}{\partial x^3} + h^4/24 \frac{\partial^4 u_0}{\partial x^4} + \mathcal{O}(h^5), \\ 
     u_2 \approx u_0 + 2h \frac{\partial u_0}{\partial x} + 4h^2/2 \frac{\partial^2 u_0}{\partial x^2} + 8h^3/6 \frac{\partial^3 u_0}{\partial x^3} + 16h^4/24 \frac{\partial^4 u_0}{\partial x^4} + \mathcal{O}(h^5). 
    \end{eqnarray}

Now we can subtract two times the first equation form the second equation yielding the first order accurate approximation

.. math::
   :nowrap:
   
   \begin{equation}
     \frac{u_2 - 2u_1 + u_0}{h^2} \approx \frac{\partial^2 u_0}{\partial x^2} + \mathcal{O}(h). 
    \end{equation}
 
If we also include the expansion for :math:`u_3` we can get the second order approximation  

.. math::
   :nowrap:

   \begin{equation}
     \frac{-u_3 + 4u_2 - 5u_1 + 2u_0}{h^2} \approx \frac{\partial^2 u_0}{\partial x^2} + \mathcal{O}(h^2). 
    \end{equation}

To check the coefficients of the stencils we can consider the special cases of a constant and a linear function which should be differentiated exactly by a first and second order accurate method respectively. Obviously both stencils are exact for a constant (the coefficients add up to zero) and additionally the secon approximation is exact for the linear function :math:`x` on the grid :math:`x_0 = 0, x_1 = 1, x_2 = 2, x_3 = 3`. The second derivative of a linear is zero which is exactly what comes out, i.e. :math:`-3 + 2\times 4 - 5\times 1 + 1\times 0 = 0`.


Higher order approximations 
---------------------------

The above procedure can of course, in principle, be extended to use all the points on the grid, yielding, in principle, a very high order accurate approximation. A general algorithm for finding finite difference stencils of all orders has been found by Bengt Fornberg and is described in his excellent `review paper`__. 

In the section :ref:`FORTRAN_FD_EXAMPLE` we discus how the above approximations can be implemented in Fortan.

__ http://amath.colorado.edu/faculty/fornberg/Docs/sirev_cl.pdf
