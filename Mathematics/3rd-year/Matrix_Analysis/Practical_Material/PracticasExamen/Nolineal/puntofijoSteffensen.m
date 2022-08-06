%% Devuelve una aproximacion a un punto fijo de la funcion "fun"
%% donde "fun" es una funcion interna o externa (se escribe "fun" entre comillas 
%% si la funcion es externa, cuando es interna se escribe fun sin comillas)
%% 
%% realiza iteraciones funcionales  x_n=f(x_(n-1) empezando en una aproximación inicial
%% x0
%% 
%% la condicion de parada es que  abs(f(x)-x) < precision
%% donde precision es una variable global,  o que se sobrepase un numero prefijado 
%% de iteraciones, en cuyo caso enviara un error.

function [x,npasos] = puntofijoSteffensen (fun, x0,nmaxiteraciones)
  global precision
  npasos=1;
  x=x0;
  fval=feval(fun,x);
  ffval=feval(fun,fval);
  while(npasos <= nmaxiteraciones)
    delta1=x-fval;
    if(abs(delta1)<precision)
      return
    end 
    delta2=ffval-2*fval+x;
    if(abs(delta2)<100*eps)
      return
    end
    x=x-delta1^2/delta2;
    fval=feval(fun,x);
    ffval=feval(fun,fval);
    npasos=npasos+1;
  end
  error('No hay convergencia de punto fijo');
endfunction
