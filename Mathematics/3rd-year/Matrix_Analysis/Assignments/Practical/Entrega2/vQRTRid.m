function [vp,V]=vQRTRid(T, tol, nit)
  [n,m]=size(T);
  if(n!=m)
    error("La matriz no es cuadrada");
  endif
  A=T;
  j=0;
  
  
  errA=1;
  V=eye(n);
  while(errA>tol && nit>0)
    [Q,R]=QRTRid(A);
    A=R*Q;
    V=V*Q;
    errA=norm(A)-norm(diag(diag(A))); %Porque la diagonal va absorbiendo todo el 
                                     %peso de la matriz
    nit=nit-1;
  endwhile
  if(errA>tol)
    error('No se alcanza convergencia en ese número de pasos.');
  endif
  vp=diag(A);
endfunction
