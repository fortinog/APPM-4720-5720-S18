clear all

nd = 4;

syms x y t 
% u = sin(kx*x+x0)*sin(ky*y+y0)*sin(kt*t+t0) 
syms kx ky kt x0 y0 t0

px = sin(kx*x+x0);
py = sin(ky*y+y0);
pt = sin(kt*t+t0); 


for it=0:nd
  for ix=0:nd
    for iy=0:nd
      Z(ix+1,iy+1,it+1) = diff(px,x,ix)*diff(py,y,iy)*diff(pt,t,it);
    end
  end
end

fortran(Z, 'file', 'mms.f')