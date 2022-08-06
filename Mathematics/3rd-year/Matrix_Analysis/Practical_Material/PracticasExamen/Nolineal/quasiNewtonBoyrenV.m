% metodo de Boyren (quasi-Newton) para funciones vectoriales
% para aproximar una solucion de F(X)=0,
% como datos de entrada están la aproximacion inicial X0 y la diferencial de F en X0

function [X,FX,npasos] = quasiNewtonBoyrenV (F, dFX0,X0,nmaxiteraciones)
  global precision;
  addpath('../Matrices')
  npasos=0;
  X=X0;
  FX=feval(F,X);
  h=X;
  invJa=inv(dFX0);
  while npasos<nmaxiteraciones
   
     h=-invJa*FX;
    
     X=X+h;
     FX=F(X);
     if or(norm(h) < precision,norm(FX)<precision)
       display('cero de F en X')
       break
     endif
     npasos=npasos+1;
     u=invJa*FX;
     iden=1/(dot(h+u,h));
     w=(iden*h)'*invJa;
     invJa=invJa-u*w;     
  endwhile
  if npasos==nmaxiteraciones
      npasos
      error('Newton no converge');
  endif
endfunction
