module twilight_module
  !
  real(kind(1.0d0)) :: cx0,cx1,cx2,cx3,cx4
  real(kind(1.0d0)) :: cy0,cy1,cy2,cy3,cy4
  real(kind(1.0d0)) :: ct0,ct1,ct2,ct3,ct4
  real(kind(1.0d0)) :: kx,x0,ky,y0,kt,t0
  integer :: twilight_type 
  !
contains
  
  subroutine twilight(u,x,y,t,dx,dy,dt)
    implicit none
    real(kind(1.0d0)) :: u,x,y,t
    integer :: dx,dy,dt

    if (twilight_type .eq. 1) then
     call trig_twilight(u,x,y,t,dx,dy,dt)
    elseif (twilight_type .eq. 2) then
     call polynomial_twilight(u,x,y,t,dx,dy,dt)
    end if
  end subroutine twilight
  
  subroutine set_trig(kx_in,x0_in,ky_in,y0_in,kt_in,t0_in)
    implicit none
    real(kind(1.0d0)) :: kx_in,x0_in,ky_in,y0_in,kt_in,t0_in
    !
    kx = kx_in
    x0 = x0_in
    ky = ky_in
    y0 = y0_in
    kt = kt_in
    t0 = t0_in
    !
  end subroutine set_trig

  subroutine set_polynomial(cx,cy,ct)
    implicit none
    real(kind(1.0d0)) :: cx(0:4),cy(0:4),ct(0:4)
    !
    cx0 = cx(0); cx1 = cx(1); cx2 = cx(2); cx3 = cx(3); cx4 = cx(4)
    cy0 = cy(0); cy1 = cy(1); cy2 = cy(2); cy3 = cy(3); cy4 = cy(4)
    ct0 = ct(0); ct1 = ct(1); ct2 = ct(2); ct3 = ct(3); ct4 = ct(4)
    !
  end subroutine set_polynomial
  
  subroutine trig_twilight(u,x,y,t,dx,dy,dt)
    ! Returns u = sin(kx*x+x0)*sin(ky*y+y0)*sin(kt*t+t0)
    implicit real(kind(1.0d0)) (t)
    real(kind(1.0d0)) :: A0(5,5,5),u,x,y,t
    integer :: dx,dy,dt
    !
    if ((dx.gt.4).or.(dx.gt.4).or.(dx.gt.4)) then
     u = 0.0d0
    else
     t2 = kt*t
     t3 = t0+t2
     t4 = kx*x
     t5 = t4+x0
     t6 = sin(t5)
     t7 = ky*y
     t8 = t7+y0
     t9 = sin(t8)
     t10 = sin(t3)
     t11 = kt**2
     t12 = cos(t3)
     t13 = cos(t8)
     t14 = t11**2
     t15 = ky**2
     t16 = t15**2
     t17 = cos(t5)
     t18 = kx**2
     t19 = t18**2
     A0(1,1,1) = t6*t9*t10
     A0(1,1,2) = kt*t6*t9*t12
     A0(1,1,3) = -t6*t9*t10*t11
     A0(1,1,4) = -kt*t6*t9*t11*t12
     A0(1,1,5) = t6*t9*t10*t14
     A0(1,2,1) = ky*t6*t10*t13
     A0(1,2,2) = kt*ky*t6*t12*t13
     A0(1,2,3) = -ky*t6*t10*t11*t13
     A0(1,2,4) = -kt*ky*t6*t11*t12*t13
     A0(1,2,5) = ky*t6*t10*t13*t14
     A0(1,3,1) = -t6*t9*t10*t15
     A0(1,3,2) = -kt*t6*t9*t12*t15
     A0(1,3,3) = t6*t9*t10*t11*t15
     A0(1,3,4) = kt*t6*t9*t11*t12*t15
     A0(1,3,5) = -t6*t9*t10*t14*t15
     A0(1,4,1) = -ky*t6*t10*t13*t15
     A0(1,4,2) = -kt*ky*t6*t12*t13*t15
     A0(1,4,3) = ky*t6*t10*t11*t13*t15
     A0(1,4,4) = kt*ky*t6*t11*t12*t13*t15
     A0(1,4,5) = -ky*t6*t10*t13*t14*t15
     A0(1,5,1) = t6*t9*t10*t16
     A0(1,5,2) = kt*t6*t9*t12*t16
     A0(1,5,3) = -t6*t9*t10*t11*t16
     A0(1,5,4) = -kt*t6*t9*t11*t12*t16
     A0(1,5,5) = t6*t9*t10*t14*t16
     A0(2,1,1) = kx*t9*t10*t17
     A0(2,1,2) = kt*kx*t9*t12*t17
     A0(2,1,3) = -kx*t9*t10*t11*t17
     A0(2,1,4) = -kt*kx*t9*t11*t12*t17
     A0(2,1,5) = kx*t9*t10*t14*t17
     A0(2,2,1) = kx*ky*t10*t13*t17
     A0(2,2,2) = kt*kx*ky*t12*t13*t17
     A0(2,2,3) = -kx*ky*t10*t11*t13*t17
     A0(2,2,4) = -kt*kx*ky*t11*t12*t13*t17
     A0(2,2,5) = kx*ky*t10*t13*t14*t17
     A0(2,3,1) = -kx*t9*t10*t15*t17
     A0(2,3,2) = -kt*kx*t9*t12*t15*t17
     A0(2,3,3) = kx*t9*t10*t11*t15*t17
     A0(2,3,4) = kt*kx*t9*t11*t12*t15*t17
     A0(2,3,5) = -kx*t9*t10*t14*t15*t17
     A0(2,4,1) = -kx*ky*t10*t13*t15*t17
     A0(2,4,2) = -kt*kx*ky*t12*t13*t15*t17
     A0(2,4,3) = kx*ky*t10*t11*t13*t15*t17
     A0(2,4,4) = kt*kx*ky*t11*t12*t13*t15*t17
     A0(2,4,5) = -kx*ky*t10*t13*t14*t15*t17
     A0(2,5,1) = kx*t9*t10*t16*t17
     A0(2,5,2) = kt*kx*t9*t12*t16*t17
     A0(2,5,3) = -kx*t9*t10*t11*t16*t17
     A0(2,5,4) = -kt*kx*t9*t11*t12*t16*t17
     A0(2,5,5) = kx*t9*t10*t14*t16*t17
     A0(3,1,1) = -t6*t9*t10*t18
     A0(3,1,2) = -kt*t6*t9*t12*t18
     A0(3,1,3) = t6*t9*t10*t11*t18
     A0(3,1,4) = kt*t6*t9*t11*t12*t18
     A0(3,1,5) = -t6*t9*t10*t14*t18
     A0(3,2,1) = -ky*t6*t10*t13*t18
     A0(3,2,2) = -kt*ky*t6*t12*t13*t18
     A0(3,2,3) = ky*t6*t10*t11*t13*t18
     A0(3,2,4) = kt*ky*t6*t11*t12*t13*t18
     A0(3,2,5) = -ky*t6*t10*t13*t14*t18
     A0(3,3,1) = t6*t9*t10*t15*t18
     A0(3,3,2) = kt*t6*t9*t12*t15*t18
     A0(3,3,3) = -t6*t9*t10*t11*t15*t18
     A0(3,3,4) = -kt*t6*t9*t11*t12*t15*t18
     A0(3,3,5) = t6*t9*t10*t14*t15*t18
     A0(3,4,1) = ky*t6*t10*t13*t15*t18
     A0(3,4,2) = kt*ky*t6*t12*t13*t15*t18
     A0(3,4,3) = -ky*t6*t10*t11*t13*t15*t18
     A0(3,4,4) = -kt*ky*t6*t11*t12*t13*t15*t18
     A0(3,4,5) = ky*t6*t10*t13*t14*t15*t18
     A0(3,5,1) = -t6*t9*t10*t16*t18
     A0(3,5,2) = -kt*t6*t9*t12*t16*t18
     A0(3,5,3) = t6*t9*t10*t11*t16*t18
     A0(3,5,4) = kt*t6*t9*t11*t12*t16*t18
     A0(3,5,5) = -t6*t9*t10*t14*t16*t18
     A0(4,1,1) = -kx*t9*t10*t17*t18
     A0(4,1,2) = -kt*kx*t9*t12*t17*t18
     A0(4,1,3) = kx*t9*t10*t11*t17*t18
     A0(4,1,4) = kt*kx*t9*t11*t12*t17*t18
     A0(4,1,5) = -kx*t9*t10*t14*t17*t18
     A0(4,2,1) = -kx*ky*t10*t13*t17*t18
     A0(4,2,2) = -kt*kx*ky*t12*t13*t17*t18
     A0(4,2,3) = kx*ky*t10*t11*t13*t17*t18
     A0(4,2,4) = kt*kx*ky*t11*t12*t13*t17*t18
     A0(4,2,5) = -kx*ky*t10*t13*t14*t17*t18
     A0(4,3,1) = kx*t9*t10*t15*t17*t18
     A0(4,3,2) = kt*kx*t9*t12*t15*t17*t18
     A0(4,3,3) = -kx*t9*t10*t11*t15*t17*t18
     A0(4,3,4) = -kt*kx*t9*t11*t12*t15*t17*t18
     A0(4,3,5) = kx*t9*t10*t14*t15*t17*t18
     A0(4,4,1) = kx*ky*t10*t13*t15*t17*t18
     A0(4,4,2) = kt*kx*ky*t12*t13*t15*t17*t18
     A0(4,4,3) = -kx*ky*t10*t11*t13*t15*t17*t18
     A0(4,4,4) = -kt*kx*ky*t11*t12*t13*t15*t17*t18
     A0(4,4,5) = kx*ky*t10*t13*t14*t15*t17*t18
     A0(4,5,1) = -kx*t9*t10*t16*t17*t18
     A0(4,5,2) = -kt*kx*t9*t12*t16*t17*t18
     A0(4,5,3) = kx*t9*t10*t11*t16*t17*t18
     A0(4,5,4) = kt*kx*t9*t11*t12*t16*t17*t18
     A0(4,5,5) = -kx*t9*t10*t14*t16*t17*t18
     A0(5,1,1) = t6*t9*t10*t19
     A0(5,1,2) = kt*t6*t9*t12*t19
     A0(5,1,3) = -t6*t9*t10*t11*t19
     A0(5,1,4) = -kt*t6*t9*t11*t12*t19
     A0(5,1,5) = t6*t9*t10*t14*t19
     A0(5,2,1) = ky*t6*t10*t13*t19
     A0(5,2,2) = kt*ky*t6*t12*t13*t19
     A0(5,2,3) = -ky*t6*t10*t11*t13*t19
     A0(5,2,4) = -kt*ky*t6*t11*t12*t13*t19
     A0(5,2,5) = ky*t6*t10*t13*t14*t19
     A0(5,3,1) = -t6*t9*t10*t15*t19
     A0(5,3,2) = -kt*t6*t9*t12*t15*t19
     A0(5,3,3) = t6*t9*t10*t11*t15*t19
     A0(5,3,4) = kt*t6*t9*t11*t12*t15*t19
     A0(5,3,5) = -t6*t9*t10*t14*t15*t19
     A0(5,4,1) = -ky*t6*t10*t13*t15*t19
     A0(5,4,2) = -kt*ky*t6*t12*t13*t15*t19
     A0(5,4,3) = ky*t6*t10*t11*t13*t15*t19
     A0(5,4,4) = kt*ky*t6*t11*t12*t13*t15*t19
     A0(5,4,5) = -ky*t6*t10*t13*t14*t15*t19
     A0(5,5,1) = t6*t9*t10*t16*t19
     A0(5,5,2) = kt*t6*t9*t12*t16*t19
     A0(5,5,3) = -t6*t9*t10*t11*t16*t19
     A0(5,5,4) = -kt*t6*t9*t11*t12*t16*t19
     A0(5,5,5) = t6*t9*t10*t14*t16*t19
     u = A0(dx+1,dy+1,dt+1)
    end if
    !
  end subroutine trig_twilight

  subroutine polynomial_twilight(u,x,y,t,dx,dy,dt)
    ! Returns u = (cx0 + cx1*x +...+ cx4*x^4)
    !            *(cy0 + ... + cy4*y^4)
    !            *(ct0 + ... + ct4*t^4)
    implicit real(kind(1.0d0)) (t)
    real(kind(1.0d0)) :: A0(5,5,5),u,x,y,t
    integer :: dx,dy,dt
    !
    if ((dx.gt.4).or.(dx.gt.4).or.(dx.gt.4)) then
     u = 0.0d0
    else
     t2 = t**2
     t3 = x**2
     t4 = y**2
     t5 = cx1*x
     t6 = cx2*t3
     t7 = cx3*t3*x
     t8 = t3**2
     t9 = cx4*t8
     t10 = cx0+t5+t6+t7+t9
     t11 = cy1*y
     t12 = cy2*t4
     t13 = cy3*t4*y
     t14 = t4**2
     t15 = cy4*t14
     t16 = cy0+t11+t12+t13+t15
     t17 = ct1*t
     t18 = ct2*t2
     t19 = ct3*t*t2
     t20 = t2**2
     t21 = ct4*t20
     t22 = ct0+t17+t18+t19+t21
     t23 = ct2*t*2.0D0
     t24 = ct3*t2*3.0D0
     t25 = ct4*t*t2*4.0D0
     t26 = ct1+t23+t24+t25
     t27 = cy2*y*2.0D0
     t28 = cy3*t4*3.0D0
     t29 = cy4*t4*y*4.0D0
     t30 = cy1+t27+t28+t29
     t31 = ct2*2.0D0
     t32 = ct3*t*6.0D0
     t33 = ct4*t2*1.2D1
     t34 = t31+t32+t33
     t35 = ct3*6.0D0
     t36 = ct4*t*2.4D1
     t37 = t35+t36
     t38 = cy2*2.0D0
     t39 = cy3*y*6.0D0
     t40 = cy4*t4*1.2D1
     t41 = t38+t39+t40
     t42 = cy3*6.0D0
     t43 = cy4*y*2.4D1
     t44 = t42+t43
     t45 = cx2*x*2.0D0
     t46 = cx3*t3*3.0D0
     t47 = cx4*t3*x*4.0D0
     t48 = cx1+t45+t46+t47
     t49 = cx2*2.0D0
     t50 = cx3*x*6.0D0
     t51 = cx4*t3*1.2D1
     t52 = t49+t50+t51
     t53 = cx3*6.0D0
     t54 = cx4*x*2.4D1
     t55 = t53+t54
     A0(1,1,1) = t10*t16*t22
     A0(1,1,2) = t10*t16*t26
     A0(1,1,3) = t10*t16*t34
     A0(1,1,4) = t10*t16*t37
     A0(1,1,5) = ct4*t10*t16*2.4D1
     A0(1,2,1) = t10*t22*t30
     A0(1,2,2) = t10*t26*t30
     A0(1,2,3) = t10*t30*t34
     A0(1,2,4) = t10*t30*t37
     A0(1,2,5) = ct4*t10*t30*2.4D1
     A0(1,3,1) = t10*t22*t41
     A0(1,3,2) = t10*t26*t41
     A0(1,3,3) = t10*t34*t41
     A0(1,3,4) = t10*t37*t41
     A0(1,3,5) = ct4*t10*t41*2.4D1
     A0(1,4,1) = t10*t22*t44
     A0(1,4,2) = t10*t26*t44
     A0(1,4,3) = t10*t34*t44
     A0(1,4,4) = t10*t37*t44
     A0(1,4,5) = ct4*t10*t44*2.4D1
     A0(1,5,1) = cy4*t10*t22*2.4D1
     A0(1,5,2) = cy4*t10*t26*2.4D1
     A0(1,5,3) = cy4*t10*t34*2.4D1
     A0(1,5,4) = cy4*t10*t37*2.4D1
     A0(1,5,5) = ct4*cy4*t10*5.76D2
     A0(2,1,1) = t16*t22*t48
     A0(2,1,2) = t16*t26*t48
     A0(2,1,3) = t16*t34*t48
     A0(2,1,4) = t16*t37*t48
     A0(2,1,5) = ct4*t16*t48*2.4D1
     A0(2,2,1) = t22*t30*t48
     A0(2,2,2) = t26*t30*t48
     A0(2,2,3) = t30*t34*t48
     A0(2,2,4) = t30*t37*t48
     A0(2,2,5) = ct4*t30*t48*2.4D1
     A0(2,3,1) = t22*t41*t48
     A0(2,3,2) = t26*t41*t48
     A0(2,3,3) = t34*t41*t48
     A0(2,3,4) = t37*t41*t48
     A0(2,3,5) = ct4*t41*t48*2.4D1
     A0(2,4,1) = t22*t44*t48
     A0(2,4,2) = t26*t44*t48
     A0(2,4,3) = t34*t44*t48
     A0(2,4,4) = t37*t44*t48
     A0(2,4,5) = ct4*t44*t48*2.4D1
     A0(2,5,1) = cy4*t22*t48*2.4D1
     A0(2,5,2) = cy4*t26*t48*2.4D1
     A0(2,5,3) = cy4*t34*t48*2.4D1
     A0(2,5,4) = cy4*t37*t48*2.4D1
     A0(2,5,5) = ct4*cy4*t48*5.76D2
     A0(3,1,1) = t16*t22*t52
     A0(3,1,2) = t16*t26*t52
     A0(3,1,3) = t16*t34*t52
     A0(3,1,4) = t16*t37*t52
     A0(3,1,5) = ct4*t16*t52*2.4D1
     A0(3,2,1) = t22*t30*t52
     A0(3,2,2) = t26*t30*t52
     A0(3,2,3) = t30*t34*t52
     A0(3,2,4) = t30*t37*t52
     A0(3,2,5) = ct4*t30*t52*2.4D1
     A0(3,3,1) = t22*t41*t52
     A0(3,3,2) = t26*t41*t52
     A0(3,3,3) = t34*t41*t52
     A0(3,3,4) = t37*t41*t52
     A0(3,3,5) = ct4*t41*t52*2.4D1
     A0(3,4,1) = t22*t44*t52
     A0(3,4,2) = t26*t44*t52
     A0(3,4,3) = t34*t44*t52
     A0(3,4,4) = t37*t44*t52
     A0(3,4,5) = ct4*t44*t52*2.4D1
     A0(3,5,1) = cy4*t22*t52*2.4D1
     A0(3,5,2) = cy4*t26*t52*2.4D1
     A0(3,5,3) = cy4*t34*t52*2.4D1
     A0(3,5,4) = cy4*t37*t52*2.4D1
     A0(3,5,5) = ct4*cy4*t52*5.76D2
     A0(4,1,1) = t16*t22*t55
     A0(4,1,2) = t16*t26*t55
     A0(4,1,3) = t16*t34*t55
     A0(4,1,4) = t16*t37*t55
     A0(4,1,5) = ct4*t16*t55*2.4D1
     A0(4,2,1) = t22*t30*t55
     A0(4,2,2) = t26*t30*t55
     A0(4,2,3) = t30*t34*t55
     A0(4,2,4) = t30*t37*t55
     A0(4,2,5) = ct4*t30*t55*2.4D1
     A0(4,3,1) = t22*t41*t55
     A0(4,3,2) = t26*t41*t55
     A0(4,3,3) = t34*t41*t55
     A0(4,3,4) = t37*t41*t55
     A0(4,3,5) = ct4*t41*t55*2.4D1
     A0(4,4,1) = t22*t44*t55
     A0(4,4,2) = t26*t44*t55
     A0(4,4,3) = t34*t44*t55
     A0(4,4,4) = t37*t44*t55
     A0(4,4,5) = ct4*t44*t55*2.4D1
     A0(4,5,1) = cy4*t22*t55*2.4D1
     A0(4,5,2) = cy4*t26*t55*2.4D1
     A0(4,5,3) = cy4*t34*t55*2.4D1
     A0(4,5,4) = cy4*t37*t55*2.4D1
     A0(4,5,5) = ct4*cy4*t55*5.76D2
     A0(5,1,1) = cx4*t16*t22*2.4D1
     A0(5,1,2) = cx4*t16*t26*2.4D1
     A0(5,1,3) = cx4*t16*t34*2.4D1
     A0(5,1,4) = cx4*t16*t37*2.4D1
     A0(5,1,5) = ct4*cx4*t16*5.76D2
     A0(5,2,1) = cx4*t22*t30*2.4D1
     A0(5,2,2) = cx4*t26*t30*2.4D1
     A0(5,2,3) = cx4*t30*t34*2.4D1
     A0(5,2,4) = cx4*t30*t37*2.4D1
     A0(5,2,5) = ct4*cx4*t30*5.76D2
     A0(5,3,1) = cx4*t22*t41*2.4D1
     A0(5,3,2) = cx4*t26*t41*2.4D1
     A0(5,3,3) = cx4*t34*t41*2.4D1
     A0(5,3,4) = cx4*t37*t41*2.4D1
     A0(5,3,5) = ct4*cx4*t41*5.76D2
     A0(5,4,1) = cx4*t22*t44*2.4D1
     A0(5,4,2) = cx4*t26*t44*2.4D1
     A0(5,4,3) = cx4*t34*t44*2.4D1
     A0(5,4,4) = cx4*t37*t44*2.4D1
     A0(5,4,5) = ct4*cx4*t44*5.76D2
     A0(5,5,1) = cx4*cy4*t22*5.76D2
     A0(5,5,2) = cx4*cy4*t26*5.76D2
     A0(5,5,3) = cx4*cy4*t34*5.76D2
     A0(5,5,4) = cx4*cy4*t37*5.76D2
     A0(5,5,5) = ct4*cx4*cy4*1.3824D4
     u = A0(dx+1,dy+1,dt+1)
    end if
    !
  end subroutine polynomial_twilight
end module twilight_module
