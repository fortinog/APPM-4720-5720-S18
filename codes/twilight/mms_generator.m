clear all

nd = 8;

syms x y t 
syms cx0 cx1 cx2 cx3 cx4
syms cy0 cy1 cy2 cy3 cy4
syms ct0 ct1 ct2 ct3 ct4

cx = [cx0 cx1 cx2 cx3 cx4];
cy = [cy0 cy1 cy2 cy3 cy4];
ct = [ct0 ct1 ct2 ct3 ct4];

px = cx(1)*(1+0*x);
py = cy(1)*(1+0*y);
pt = ct(1)*(1+0*t);

for i = 1:length(cx)-1
  px = px+cx(i+1)*x^i;
  py = py+cy(i+1)*y^i;
  pt = pt+ct(i+1)*t^i;
end

for it=0:nd
  for ix=0:nd
    for iy=0:nd
      Z(ix+1,iy+1,it+1) = diff(px,x,ix)*diff(py,y,iy)*diff(pt,t,it);
    end
  end
end

fortran(Z, 'file', 'mms.f')