function [vp,V]=QRvp(A)
  [Q,T]=tridQHouseholder(A);
  tol=10e-8;
  nit=500;
  [vp,v]=vQRTRid(T, tol, nit);
  V=Q*v;
endfunction