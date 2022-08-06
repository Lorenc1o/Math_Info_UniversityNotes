% metodo de Newton para funciones vectoriales
% con calculo de derivadas parciales aproximadas

function [X,FX,npasos,op] = newtonVop(F, dF,X0,nmaxiteraciones,ev)
  global precision;
  addpath('../Matrices')
  npasos=0;
  X=X0;
  FX=feval(F,X);
  n=length(X0);
  op=ev;
  h=X;
  while npasos<nmaxiteraciones
       J=dF(X);
       op=op+2*n^2*ev;
     try
     h=solveGaussParcial(J,FX);
     op=op+2/3*n^3+2*n^2;
    catch
    error('Diferencial singular');
    end
     X=X-h;
     FX=F(X);
      op=op+n+ev;
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
