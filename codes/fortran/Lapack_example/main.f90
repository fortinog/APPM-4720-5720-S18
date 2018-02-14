program heat_fd
  use type_defs
  implicit none
  integer, parameter :: n = 1000
  real(dp) :: A(n,n), B(n,n), x(0:n), h, dt
  real(dp) :: u(0:n), up(n)
  integer :: i,info,ipiv(n),it  
  CHARACTER(7) :: charit
  
  h = 1.0_dp/real(n,dp)
  dt = 10.d0!0.1*h
  do i = 0,n
   x(i) = real(i,dp)*h
  end do
  u = x*exp(sin(10.0_dp*x))
  A = 0.0_dp
  do i = 1,n
   A(i,i) = -2.d0/h**2
  end do
  do i = 1,n-1
   A(i,i+1) = 1.d0/h**2
   A(i+1,i) = 1.d0/h**2
  end do
  ! Neumann condition
  A(n,n)   = -3.d0/h**2
  A(n,n-1) =  4.d0/h**2
  A(n,n-2) = -1.d0/h**2

  ! Trapezoidal rule
  ! (u(n+1) - dt/2 u_xx(n+1)) = (u(n+1) + dt/2 u_xx(n+1))
  B = -dt/2.0_dp*A
  do i = 1,n
   B(i,i) = 1.0_dp + B(i,i) 
  end do
  A =  dt/2.0_dp*A
  do i = 1,n
   A(i,i) = 1.0_dp + A(i,i)  
  end do
  
  ! Factor
  CALL DGETRF(n,n,B,n,IPIV,INFO)
  do it = 1,100
   up = matmul(A,u(1:n))
   ! solve
   CALL DGETRS('N',n,1,B,n,IPIV,up,n,INFO)
   u(1:n) = up
   WRITE(charit,"(I7.7)") it
   call printdble1d(u,0,n,'u'//charit//'.txt')
   
  end do
  
end program heat_fd

subroutine printdble1d(u,nx1,nx2,str)
  use type_defs
  IMPLICIT NONE
  integer, intent(in) :: nx1,nx2
  REAL(DP), intent(in) :: u(nx1:nx2)
  character(len=*), intent(in) :: str
  integer :: i
  open(2,file=trim(str),status='unknown')
  do i=nx1,nx2,1
   if(abs(u(i)) .lt. 1e-40_dp) then
    write(2,fmt='(E24.16)',advance='no') 0.0_dp
   else
    write(2,fmt='(E24.16)',advance='no') u(i)
   end if
  end do
  close(2)
end subroutine printdble1d
