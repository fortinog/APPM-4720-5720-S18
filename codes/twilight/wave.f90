program wave
  !
  ! This program solves the wave equation
  ! on a rectanglar domain with Dirichlet bc on top and bottom
  ! and Neumann bc to the left and right
  !
  use type_defs
  use twilight_module
  implicit none
  real(dp) :: x_min = -1.0_dp
  real(dp) :: x_max =  1.0_dp
  real(dp) :: y_min = -2.0_dp
  real(dp) :: y_max =  2.0_dp
  real(dp) :: tend  =  10.0_dp
  real(dp) :: CFL =  0.9_dp
  integer, parameter :: nx = 19
  integer, parameter :: ny = 17
  logical, parameter :: use_twilight = .true. 
  integer, parameter :: debug = 10
  real(dp) :: um(-1:nx+1,-1:ny+1),&
    u(-1:nx+1,-1:ny+1),up(-1:nx+1,-1:ny+1),&
    uxx(0:nx,0:ny),uyy(0:nx,0:ny),utt(0:nx,0:ny),&
    f(0:nx,0:ny)
  real(dp) :: x(-1:nx+1),y(-1:ny+1)
  integer :: i,j,nt,it
  real(dp) :: dx,dy,dt,t,max_err,tmp_err,floc
  CHARACTER(7) :: charit
  ! 
  dx = (x_max-x_min)/real(nx,dp)
  dy = (y_max-y_min)/real(ny,dp)
  dt = CFL*min(dx,dy)
  nt = ceiling(tend/dt)
  dt = tend/real(nt,dp)
  t = 0.0_dp
  do i = -1,nx+1
   x(i) = x_min+real(i,dp)*dx
  end do
  do i = -1,ny+1
   y(i) = y_min+real(i,dp)*dy
  end do
  !
  twilight_type = 1
  call set_trig(1.0_dp,1.2_dp,1.4_dp,1.11_dp,1.51_dp,1.9_dp)
  !
  do j = 0,ny
   do i = 0,nx
    call twilight(um(i,j),x(i),y(j),t-dt,0,0,0)
    call twilight(u(i,j),x(i),y(j),t,0,0,0) 
   end do
  end do
  !
  call set_bc(u,x,y,t,dx,dy,nx,ny,use_twilight)
  if(debug .gt. 5) then
   max_err = 0.0_dp
   do j = 0,ny
    do i = -1,nx+1
     call twilight(tmp_err,x(i),y(j),t,0,0,0) 
     tmp_err = abs(u(i,j)-tmp_err)
     if (tmp_err .gt. max_err) max_err = tmp_err
    end do
   end do
   write(*,*) 'Debug: Error in boundary condition routine is: ', max_err 
   call compute_laplace(uxx,uyy,u,dx,dy,nx,ny)
   max_err = 0.0_dp
   do j = 0,ny
    do i = 0,nx
     call twilight(tmp_err,x(i),y(j),t,2,0,0) 
     tmp_err = abs(uxx(i,j)-tmp_err)
     if (tmp_err .gt. max_err) max_err = tmp_err
    end do
   end do
   write(*,*) 'Debug: Error in u_xx is: ', max_err 
   max_err = 0.0_dp
   do j = 1,ny-1 ! NB Dirichlet on top / bottom
    do i = 0,nx
     call twilight(tmp_err,x(i),y(j),t,0,2,0) 
     tmp_err = abs(uyy(i,j)-tmp_err)
     if (tmp_err .gt. max_err) max_err = tmp_err
    end do
   end do
   write(*,*) 'Debug: Error in u_yy is: ', max_err 
  end if

  t = 0.0_dp
  call set_bc(u,x,y,t,dx,dy,nx,ny,use_twilight)
  ! Make sure the boundary conditions are set at initial time
  
  ! Do some time-stepping
  do it = 1,nt
   t = real(it-1,dp)*dt
   call compute_laplace(uxx,uyy,u,dx,dy,nx,ny)
   if(use_twilight) then
    ! Forcing is u_tt - u_xx - u_yy
    do j = 0,ny
     do i = 0,nx
      call twilight(floc,x(i),y(j),t,0,0,2)
      f(i,j) = floc
      call twilight(floc,x(i),y(j),t,2,0,0)
      f(i,j) = f(i,j) - floc
      call twilight(floc,x(i),y(j),t,0,2,0)
      f(i,j) = f(i,j) - floc
     end do
    end do
   else
    f = 0.0_dp
   end if
   do j = 0,ny
    do i = 0,nx
     up(i,j) = 2.0_dp*u(i,j) - um(i,j) + dt**2*(uxx(i,j) + uyy(i,j) + f(i,j)) 
    end do
   end do
   ! Swap solution 
   um = u
   u  = up
   t = t+dt
   call set_bc(u,x,y,t,dx,dy,nx,ny,use_twilight)
   if(debug .gt.10) then
    max_err = 0.0_dp
    do j = 0,ny 
     do i = 0,nx
      call twilight(tmp_err,x(i),y(j),t,0,0,0) 
      tmp_err = abs(u(i,j)-tmp_err)
      if (tmp_err .gt. max_err) max_err = tmp_err
     end do
    end do
    write(*,*) 'Debug: Error in u is: ', max_err, ' at time: ',t  
   end if
   
  end do

  if(debug .gt.5) then
   max_err = 0.0_dp
   do j = 0,ny 
    do i = 0,nx
     call twilight(tmp_err,x(i),y(j),tend,0,0,0) 
     tmp_err = abs(u(i,j)-tmp_err)
     if (tmp_err .gt. max_err) max_err = tmp_err
    end do
   end do
   write(*,*) 'Debug: Final error in u is: ', max_err
  end if

   
  
end program wave

subroutine compute_laplace(uxx,uyy,u,dx,dy,nx,ny)
  use type_defs
  implicit none
  integer  :: nx,ny
  real(dp) :: u(-1:nx+1,-1:ny+1),uxx(0:nx,0:ny),uyy(0:nx,0:ny),dx,dy
  integer  :: i,j
  real(dp) :: dx2i,dy2i

  dx2i = 1.0_dp/dx**2
  dy2i = 1.0_dp/dy**2
  do j = 0,ny
   do i = 0,nx
    uxx(i,j) = dx2i*(u(i+1,j) - 2.0_dp*u(i,j) + u(i-1,j))
    uyy(i,j) = dy2i*(u(i,j+1) - 2.0_dp*u(i,j) + u(i,j-1))
   end do
  end do
end subroutine compute_laplace


subroutine set_bc(u,x,y,t,dx,dy,nx,ny,use_twilight)
  use type_defs
  use twilight_module
  implicit none
  real(dp) :: u(-1:nx+1,-1:ny+1),x(-1:nx+1),y(-1:ny+1),t,dx,dy
  integer  :: nx,ny
  logical  :: use_twilight
  real(dp) :: ux
  integer  :: i
  
  !
  if (use_twilight) then
   !
   do i = 0,nx
    ! Bottom
    call twilight(u(i,0),x(i),y(0),t,0,0,0)
    ! Top
    call twilight(u(i,ny),x(i),y(ny),t,0,0,0)
     
   end do
   do i = 0,ny
    ! Left
    call twilight(ux,x(0),y(i),t,1,0,0)
    ! Use a second order accurate approximation to get
    ! the value at the ghostpoint
    u(-1,i) = -2.d0*dx*ux + u(1,i)
    ! Right
    call twilight(ux,x(nx),y(i),t,1,0,0)
    u(nx+1,i) = 2.d0*dx*ux + u(nx-1,i)
   end do
  else
   write(*,*) use_twilight, 'Non-twilight forcing is not implemented'
   stop 112
  end if
  
end subroutine set_bc
