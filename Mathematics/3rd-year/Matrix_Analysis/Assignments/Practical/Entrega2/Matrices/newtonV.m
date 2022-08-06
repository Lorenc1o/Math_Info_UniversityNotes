% metodo de Newton para funciones vectoriales
% con calculo de derivadas parciales aproximadas

function [X,FX,npasos] = newtonV (F, dF,X0,nmaxiteraciones)
  global precision;
  %addpath('../Matrices')
  npasos=0;
  X=X0;
  FX=feval(F,X);
  h=X;
  while npasos<nmaxiteraciones
       J=dF(X);
     try
     h=solveGaussParcial(J,FX);
    catch
    error('Diferencial singular');
    end
     X=X-h;
     FX=F(X);
     if or(norm(h) < precision,norm(FX)<precision)
       display('cero de F en X')
       break
     endif
     npasos=npasos+1;
  endwhile
  if npasos==nmaxiteraciones
      npasos
      error('Newton no converge');
  endif
endfunction
