.. -*- rst -*- -*- restructuredtext -*-

=================================
Homework 6, due 08.00, 29/10-2014
=================================

Numerical solution of ODEs
--------------------------

In this homework you will try out some numerical methods for solving ODEs.

Duffing's attractor
-------------------

This problem is intended to demonstrate that there is a difference between good and not so good numerical methods. Consider the second order ODE:

.. math::
   :nowrap:

   \begin{equation}\label{duffing} 
   \ddot{z}(t)+0.05 \,\dot{z}(t) + z^3(t) = 7.5 \cos(t), \ \ z(0)=0,\, \dot{z}(0)=1. 
   \end{equation}

Your assignment is to compute the solution at :math:`t=70` as accurately as your computer allows. First try forward Euler:

.. math::
   :nowrap:

   \begin{equation*}
   x(t+\Delta t) = x(t) + \Delta t \, f(t,x(t)), 
   \end{equation*}

then the fourth order accurate Runge Kutta method:

.. math::
   :nowrap:

   \begin{align*}
    & k_1=f(t,x(t)),\\
    & k_2=f(t+0.5 \Delta t,x(t)+0.5 \Delta t k_1),\\
    & k_3=f(t+0.5 \Delta t,x(t)+0.5 \Delta t k_2),\\
    & k_4=f(t+ \Delta t,x(t)+ \Delta t k_3),\\	
    & x(t+\Delta t) = x(t) + \frac{\Delta t}{6} (k_1+2 k_2+ 2 k_3+k_4).
    \end{align*}


Here :math:`\dot{x} = f(t,x(t))` is a system of first order ODEs so
you should first rewrite the second order ODE that form by introducing
:math:`x_1=z, \, x_2=\dot{z}`. 

Use the values 

.. math::
   :nowrap:

    x^{ex}_1(70) = 1.582857756103056, \ \ x^{ex}_2(70) =
    -2.835763853877514, 
    
as "exact" and plot the error
:math:`e=\sqrt{(x_1-x^{ex}_1)^2+(x_2-x^{ex}_2)^2}` as a function of
:math:`\Delta t`. If :math:`\Delta t` is small enough (inside
the asymptotic regime) the error is expected to follow a
power law :math:`e \approx C (\Delta t)^p`. Determine
:math:`C` and :math:`p` from your plot and estimate the number of time steps required to reach :math:`e < 10^{-5}` with forward Euler. Is your computer fast enough?


**Note:** Unless you take :math:`\Delta t` small enough the above
methods will not be stable. Take :math:`\Delta t < 8.75\cdot10^{-3}`
for Euler and :math:`\Delta t < 0.35` for Runge-Kutta to be on the
safe side. 

Report the order of convergence by plotting the error vs. the timestep
for both method. Also plot the trajectory of the solution,
``plot(x(:,1),x(:,2))`` for some different timesteps.    

The Wave equation in one dimension
----------------------------------

Consider the wave equation in one dimension with a variable
coefficient 

.. math::
   :nowrap:

   \begin{equation}
   u_{tt} = (a(x)u_x)_x, \ \ x \in [x_l,x_r], \ \ t > 0,
   \end{equation}

with homogenous boundary conditions 

.. math::
   :nowrap:

   \begin{equation}
   u(x_l,t) = u(x_r,t) = 0.
   \end{equation}

In this homework we discretize the first order system

.. math::
   :nowrap:

   \begin{eqnarray}
   && u_t = v, \\
   && v_{t} = (a(x)u_x)_x, \ \ x \in [x_l,x_r], \ \ t > 0,
   \end{eqnarray}


as described in the file ``/codes/fortran/HWK6/rhside.f90``. Note that
as both :math:`u` and  :math:`v` are zero on the boundary we only have
to evolve the solution on the interior gridpoints :math:`x_i, \, i =
1,\ldots,n_x-1`. After discretization in space we thus have to solve a
system of ODE of size :math:`2(n_x-1)`

.. math::
   :nowrap:

   \begin{eqnarray}
   && u_t(x_1,t) = v(x_1),\\ 
   && u_t(x_2,t) = v(x_2),\\ 
   && \vdots \\ 
   && u_t(x_{n_x-1},t) = v(x_{n_x-1}),\\ 
   && v_{t}(x_1,t) = D_- (E(a(x_1)) D_+ u(x_1,t)), \\
   && \vdots \\
   && v_{t}(x_{n_x-1},t) = D_- (E(a(x_{n_x-1})) D_+ u(x_{n_x-1},t)).
   \end{eqnarray}
  
Here we have used the notation

.. math::
   :nowrap:

   \begin{eqnarray}
   && D_- w(x_i,t) = (w(x_i,t)-w(x_{i-1},t))/h_x,\\
   && E(a(x_i)) = (a(x_{i+1})+a(x_i))/h_x,\\
   && D_+ w(x_{i},t) =(w(x_{i+1},t)-w(x_{i},t))/h_x. 
   \end{eqnarray}

See also ``rhside.f90``. 

Start off by compiling and running the program
``/codes/fortran/HWK6/homework6.f90``. The program currently uses
second order Runge-Kutta, or Heun's method to solve the above system
of ODE. This method is not stable but it takes a little while before
the solution bows up. Run the code with ``nx = 100`` and ``nx = 200``
and look at the output by the Matlab program ``plotresults.m``. What
if you increase ``nx`` further? When does the solution blow up? after
a fixed number of timesteps, at a fixed time? Keep refining and try to
find a pattern (for example by plotting the timestep the solution
reaches one million as a function of number of gridpoints).  

  1. Modify the code to use Runge-Kutta 4 and try some different values of
     ``amp``. What happens if :math:`a(x) < 0`?  
  2. Try and change :math:`a(x)`, can you make the waves get
     "trapped"?
  3. For the case with ``amp = 0.d0``, slowly increase ``cfl`` until
     the solution blows up. How can we relate the time-stepping stability of this problem to the stability of
     the Dahlquist equation :math:`y' = \lambda y`? As we saw in
     class, for a linear system of equations :math:`{\bf y}' = {\bf A}{\bf y}`
     the eigenvalues of the matrix plays the role of :math:`\lambda`
     in the scalar case. But what is the matrix in this case? And what
     are the eigenvalues? The right hand side is in fact nothing but a
     linear transformation so (consult your linear algebra book if you
     for got this) we may reconstruct the matrix, column by column if
     we plug in unit vectors info the linear transformation. Look at
     the program ``/codes/fortran/HWK6/getmatrix.f90`` to see how we
     can construct the matrix. The program also computes the
     eigenvalues. Look up the documentation of the Lapack subroutine
     ``dgeev`` to see what is being output in the files ``lam_re.txt``
     and ``lam_im.txt``. 
  4. Find the stability domain of Runge-Kutta 4 in a numerical
     analysis book or online. Compute the eigenvalues for a couple of
     different values of ``hx`` (chosen by setting ``nx``). Multiply
     the eigenvalues by ``dt = cfl*hx``. How large can ``cfl`` be if
     all of the :math:`\Delta t \lambda` are to remain iside the
     stability domiain of Runge-Kutta 4? Does this agree with your
     computational / experimental results from 3.? 
  5. Finally, as you now know the matrix, implement Backward Euler as
     an option for time-stepping in your program. Let :math:`{\bf W} = [u\, v]^T`  
     Then you can write backward Euler :math:`{\bf (I }-\Delta t
     {\bf A) W(t_{n+1})}= {\bf W(t_{n})}`. Read the documentation for
     ``DGETRF`` and ``DGETRS`` and use them to factor (once before the
     time-stepping loop) and solve to get the next timestep. Is is
     true that you can take any size timesteps? Compute the solution
     to some problems using RK4 and backward Euler and compare the
     accuracy and computational time between them.


  
   
