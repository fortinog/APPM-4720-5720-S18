.. -*- rst -*- -*- restructuredtext -*-

======================================
Homework 7, due 08.00, 5/12-2014
======================================

Solving the wave equation on a curvilinear grid using MPI
---------------------------------------------------------

Consider the wave equation in two dimensions with a variable
coefficient 

.. math::
   :nowrap:

   \begin{equation}
   u_{tt} =(a(x,y)u_x)_x + (a(x,y)u_y)_y + F(x,y,t), \ \ (x,y) \in \Omega, \ \ t > 0,
   \end{equation}

with Dirichlet boundary conditions 

.. math::
   :nowrap:

   \begin{equation}
   u(x,y,t) = g(x,y,t), \ \  \forall \, (x,y) \in \partial \Omega,
   \end{equation}

and initial conditions

.. math::
   :nowrap:

   \begin{equation}
   u(x,y,0) = f(x,y), \ \ u_t(x,y,0) = h(x,y), \ \  \forall \, (x,y) \in \Omega,
   \end{equation}


In this project we will restrict the geometry :math:`\Omega` to be a
logically square shaped domain, as we did in homework 4. That is we
assume that there is a smooth mapping :math:`(x,y)=(x(r,s),y(r,s))`
from the reference element :math:`\Omega_R = \{(r,s) \in [-1,1]^2` 
to :math:`\Omega`.   

In the :math:`(r,s)` coordinate system the wave equation takes the
form:

.. math::
   :nowrap:

   \begin{eqnarray}
   J u_{tt} =(J r_x a(x,y) (r_xu_r + s_x u_s) + J r_y a(x,y) (r_y
   u_r + s_y u_s) )_r \\
   + (J s_x a(x,y) (r_xu_r + s_x u_s) + J s_y a(x,y) (r_y u_r + s_y
     u_s) )_s \\
   + J F(x,y,t), \ \ (x,y) \in \Omega, \ \ t > 0.
   \end{eqnarray}

Here the metric :math:`r_x, r_y, s_x, s_y` and :math:`J(r,s) = x_r
y_s - x_s y_r` can be computed in the same way as in homework 4.


Parallelization Assignments
===========================

  1. Familiarize yourself with the program ``homework7.f90`` in the
     repository. Currently the parallelization strategy is to split
     the computational domain into ``nprocs`` slabs by introducing a
     one dimensional domain decomposition with ``px_max`` processors
     ranging from the processor number ``px=1`` to ``px=px_max``. Here
     the mapping between the labeling of the processors provided by
     ``MPI_COMM_WORLD`` and the labeling for ``px`` is simple, ``myid
     = px-1``. This one dimensional domain decomposition does not
     minimize the communication between domains and your first
     assignment is to improve it by splitting the domain into
     ``px_max*py_max`` processors where ``px_max`` and ``py_max`` are chosen
     to minimize ``abs(nx/px_max-ny/py_max)``. 
     
  2. Once you have found ``px_max`` and ``py_max`` you should split up
     the number of gridpoints as was done in the 1D case. It is
     convenient to create functions that maps the ``myid`` indexation
     to the ``(px,py)`` indexation.

  3. Now that the computational domain is decomposed in a two
     dimensional way you will also have to update the communication.
     Start by assigning (and re-assigning) the left, right, top and
     bottom neighbors of each process.

  4. Check that your domain decomposition and communication is
     working by computing the derivatives (as is already done in the
     ``homework7.f90``) file.  
     
     
Discretization Assignments
==========================

   5. Before you start to discretize the equations you should
      implement a function or subroutine that produces a **Manufactured Solution**.

      What does this mean?

      Say that we are interested in finding a discrete approximation,
      :math:`v`,
      to the solution of the initial-boundary-value-problem

      .. math::
         :nowrap:
      
         \begin{align}
            &u_{tt}=u_{xx}+f, \ \ t > 0,\, x\in[0,1], \\
	    & u(x,0) = u_0(x), \ \ u_t(x,0) = u_1(x),\\
	    & \alpha_0 u(0,t) +\alpha_1 u_x(0,t) = u_l(t), \\ 
	    & \beta_0 u(1,t) +\beta_1 u_x(1,t) = u_r(t), 
	 \end{align}

      by implementing some numerical method on a computer. How can we
      convince ourselves (and the instructor or TA) that the code  is
      implementing the numerical method and thus approximating the
      initial-boundary-value-problem correctly?
      
      Assume that the numerical method has an error that converges to
      zero with some discretization parameter :math:`h` (usually the grid
      spacing) as :math:`\mathcal{O}(h^r)`. Then a good test is to measure
      the error
      
      .. math::
         :nowrap:
      
         \begin{equation}
	 \epsilon_p(t)= \left( 
	 \int_0^1 |u-v|^p \,dx
	 \right)^{\frac{1}{p}},
         \end{equation}
	 
      for some different values of :math:`h` and make sure that :math:`\epsilon_p
      \sim \mathcal{O}(h^r)`, as advertised. The crux of the matter is
      that the computation of :math:`\epsilon_p` require the knowledge of
      :math:`u`, which we don't know!
      

      This is where the method of manufactured solution comes in. If we want the solution to be, say,  

      .. math::
         :nowrap:
      
         \begin{equation}\label{mms}
	 u(x,t) = \sin(\omega (t+t_0) -k x),
	 \end{equation}

      how should we adjust the initial-boundary-value-problem so that
      this is a solution? The answer is simple, we just have to choose the forcing,
      initial- and boundary-conditions we get by plugging in **this** solution.
      For example, with :math:`u` as above, we would get:
      
      .. math::
         :nowrap:

         \begin{align*}
	 & f(x,t)=(k^2-\omega^2) \sin(\omega (t+t_0) -k x),\\ 
	 & u(x,0) = \sin(\omega (t_0) -k x),\\
         & u_l(t) =\alpha_0 \sin(\omega (t+t_0)) - \alpha_1 k \cos(\omega (t+t_0)),\\ 
         & u_r(t) = \beta_0 \sin(\omega (t+t_0) -k) -\beta_1 k \cos(\omega (t+t_0)-k). 
         \end{align*}


      Thus, to use this method you will have to build a library or (at
      least a function or subroutine) of routines of different exact
      solutions and their derivatives w.r.t. time and space.
      
      Two solutions that are commonly used for manufactured solutions
      are the trigonometric solution
      
      .. math::
         :nowrap:

	  \begin{equation}
	  u(x,y,z,t)= \sin(\omega (t+t_0) -k_x x) \sin( k_y y)\sin(k_z z),
	  \end{equation}
	  
      and the polynomial solution

      .. math::
         :nowrap:

	  \begin{equation}
	  u(x,y,z,t)= \left(\sum a_i t^i \right) \left(\sum b_j x^j \right)\left(\sum c_k y^k \right)\left(\sum d_l x^l \right).
	  \end{equation}
	  
      The polynomial solution is very useful for testing separate
      routines as the approximated solution will be *exact* if the
      degree of the polynomials are low enough (a second order method
      is often exact for first order polynomials, etc.).
      
      The trigonometric solution, being bounded by 1, is well
      suited if you need to monitor the error over a long time
      interval. This can be useful if you need to understand the
      mechanisms behind some numerical instabilities.
	 

      I cannot stress enough how useful it is to use the method of
      manufactured solution, if you start using it now it will save you
      *countless hours* once you start implementing more
      complicated algorithms.
      
   6. **Discretization in time.**

      To discretize in time you will use a simple centered
      difference. Precisely, if :math:`v_{i,j}^n \approx
      u(x_i,y_j,t_n)` you should use the approximation

      .. math::
	 :nowrap:

	 \begin{equation}
	 u_{tt}(x_i,y_j,t_n) \approx \frac{v_{i,j}^{n+1}-2 v_{i,j}^n+v_{i,j}^{n-1}}{(\Delta t)^2}
	 \end{equation}

      If you have successfully written your MMS routine you can now
      start to a assemble your complete code. It could look something
      like this. 

      .. code-block:: fortran

	 do it = 1,nsteps
	      t = dt*dble(it-1)

	      ! Set boundary conditions here (if you have boundaries!!!) 
	      call set_bc(u,nxl,nyl,t,bc_type,p_left,p_right,p_up,p_down)
	      
	      ! Communicate to update the ghost points in u 
	      ! send to the left recieve from the right
	      call MPI_Sendrecv(u(1,0:nsl+1),nsl+2,MPI_DOUBLE_PRECISION,p_left,123,&
		      u(nrl+1,0:nsl+1),nsl+2,MPI_DOUBLE_PRECISION,p_right,123,&
		      MPI_COMM_WORLD,status,ierr)
	      ! send to the right recieve from the left
	      call MPI_Sendrecv(u(nrl,0:nsl+1),nsl+2,MPI_DOUBLE_PRECISION,p_right,125,&
		      u(0,0:nsl+1),nsl+2,MPI_DOUBLE_PRECISION,p_left,125,&
		      MPI_COMM_WORLD,status,ierr)
	      ! etc....
	      ! Compute forcing
	      call compute_forcing(Force,nxl,nyl,x,y,t,force_type)
	      ! Compute Laplacian, i.e. (c u_x)_x + (c u_y)_y but on the reference square
	      call compute_lap(Lap,c,J,rx,sx,ry,sy,nxl,nyl,hr,hs)
	      ! Compute the right hand side, if you are just testing the time stepper
	      ! you can set rhside = u_tt !!!
	      rhside = Lap + Force
	      
	      ! Update the solution at the next time level.     
	      up(1:nxl,1:nyl) = 2.d0*u(1:nxl,1:nyl)-um(1:nxl,1:nyl) + dt**2*rhside
	      ! Shift the time levels
	      um = u
	      u = up
	      ! Save your output here.
	      
	      ! Compute errors and display them here
	      !(You might not want to do this every single timestep)
	      call MPI_Reduce(my_max_err,global_max_err,1,&
              MPI_DOUBLE_PRECISION,MPI_MAX,0,MPI_COMM_WORLD,ierr)
	      if(myid == 0) then
	      write(*,*) 'The max error at time : ', t+dt, ' is: ', global_max_err 
	      end if
	 end do

      Once you have created skeleton routines for the forcing,
      boundary conditions and the Laplacian you should test your code
      to make sure it is second order accurate in time. This may also be
      a good time to develop some output and plotting routines. The
      easiest way to output in parallel is to simply have each
      processof write its own part of the solution and then put it all
      together is a visualization program (for example in Matlab.)
      Having each processor write its own file is typically not the
      most efficient way of doing I/O, it is better to have a smaller
      subset of the processes do the writing (the size of the smaller
      subset is hardware dependent), but with our limited timeframe in
      this course it will have to do.   

   7. **Discretization in space.**

      Now that you have checked that your
      time-stepping is working and that you are able to plot the
      solution it is time to put away your mobile device and
      concentrate for a little bit, getting this part right will take
      some effort. 

      I am assuming here that each process has an array
      ``u(0:nxl+1,0:nyl+1)`` where the physical domain owned by each
      process corresponds to the indicies ``1:nxl,1:nyl``. There are
      eight terms of the type :math:`(J r_x a(x(r,s),y(r,s)) r_x u_r)_r` in the
      equation above. We can write any of them compactly as:

      .. math::
         :nowrap:

	  \begin{equation}
	  Q(r,s) u_r)_r, \ \ (Q(r,s) u_s)_s, \ \ (Q(r,s) u_r)_s, \ \ (Q(r,s) u_s)_r.
	  \end{equation}
      
      These should be discretized as follows:

      .. math::
         :nowrap:

	  \begin{eqnarray}
	  &\frac{\partial}{\partial r}(Q u_r) \approx &
	  D_-^r\left(E^r(Q) D_+^r u\right), \\
	  &\frac{\partial}{\partial s}(Q u_s) \approx &
	  D_-^s\left(E^s(Q) D_+^s u\right), \\
	  &\frac{\partial}{\partial r}(Q u_s) \approx &
	  D_0^s \left(Q D_0^r u\right),\\
	  &\frac{\partial}{\partial s}(Q u_r) \approx &
	  D_0^r \left(Q D_0^s u\right).
	  \end{eqnarray}
      

      Here 

      .. math::
         :nowrap:

	  \begin{eqnarray}
	  D_+r u_{i,j} = \frac{u_{i+1,j}-u_{i,j}}{h_r},
	  \ \  D_-^r u_{i,j} = D_+^r u_{i-1,j},\\
	  D_+s u_{i,j} = \frac{u_{i,j+1}-u_{i,j}}{h_s},
	  \ \  D_-^s u_{i,j} = D_+^s u_{i,j-1},\\
	  D_0^r u_{i,j} = \frac{u_{i+1,j}-u_{i-1,j}}{2h_r},\\
	  D_0^s u_{i,j} = \frac{u_{i,j+1}-u_{i,j-1}}{2h_s},\\
	  \end{eqnarray}

      are the standard finite difference operators. The averages are
      defined as:

      .. math::
         :nowrap:

	  \begin{eqnarray}
	  E^r(Q_{i,j}) = (Q_{i+1,j} + Q_{i,j})/2, \\
	  E^s(Q_{i,j}) = (Q_{i,j+1} + Q_{i,j})/2, 
	  \end{eqnarray}

      so that for example 

      .. math::
         :nowrap:

	  \begin{eqnarray}
	  D_-^r\left(E^r(Q_{i,j}) D_+^r u_{i,j}\right) =
	  \frac{(Q_{i+1,j}+Q_{i,j})}{2h_r^2}u_{i+1,j} - 
	  \frac{(Q_{i+1,j}+2Q_{i,j}+Q_{i-1,j})}{2h_r^2}u_{i,j} - 
	  \frac{(Q_{i,j}+Q_{i-1,j})}{2h_r^2}u_{i-1,j}, 
	  \end{eqnarray}

      and so forth.
	  

Experiments (under construction)
================================

   8. **Convergence with MMS.**

      The first thing you should check once you feel your program is
      bug-free is that the error decreases at the rate you expect
      (2). Try some different geometries and different :math:`c(x,y)`.  

   9. Convergence for an analytic solution. Bessel functions in an
      annular region.
      
   10. Strong and week scaling on Stampede.

   11. Excitation of resonant modes in complex shapes. See `example
       3.6 in this paper`__

   12. Mining for gold.

   13. Hybrid parallelization. 
       
   14. Extra assignments (ask the instructor.)
       
__ http://www.math.unm.edu/~appelo/preprints/077223.pdf       


