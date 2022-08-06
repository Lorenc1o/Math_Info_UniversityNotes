% metodo de Boyren (quasi-Newton) para funciones vectoriales
% para aproximar una solucion de F(X)=0,
% como datos de entrada están la aproximacion inicial X0 y la diferencial de F en X0

function [X,FX,npasos,op] = quasiNewtonBoyrenVop(F, dFX0,X0,nmaxiteraciones,ev)
  global precision;
  addpath('../Matrices')
  npasos=0;
  X=X0;
  FX=feval(F,X);
  h=X;
  invJa=inv(dFX0);
  n=length(X0);
  op=n^3+ev;
  while npasos<nmaxiteraciones
     try
     h=-invJa*FX;
     op=op+2*n^2-n;
    catch
    error('aproximacion a Diferencial singular');
    end
     X=X+h;
     FX=F(X);
     op=op+n+ev;
     if or(norm(h) < precision,norm(FX)<precision)
       display('cero de F en X')
       break
     endif
     npasos=npasos+1;
     u=invJa*FX;
     op=op+2*n^2-n;
     iden=1/(dot(h+u,h));
     op=op+3*n;
     w=(iden*h)'*invJa;
     op=op+2*n^2-n;
     invJa=invJa-u*w; 
     op=op+2*n^2;    
  endwhile
  if npasos==nmaxiteraciones
      npasos
      error('Newton no converge');
  endif
endfunction
