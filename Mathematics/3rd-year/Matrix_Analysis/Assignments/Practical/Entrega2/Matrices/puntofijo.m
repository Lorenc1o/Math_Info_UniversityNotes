%% Devuelve una aproximacion a un punto fijo de la funcion "fun"
%% donde "fun" es una funcion interna o externa
%% 
%% realiza iteraciones funcionales  x_n=f(x_(n-1) empezando en una aproximación inicial
%% x0
%% 
%% la condicion de parada es que  norm(f(x)-x) < precision
%% donde precision es una variable global,  o que se sobrepase un numero prefijado 
%% de iteraciones, en cuyo caso enviara un error.

function [x,npasos] = puntofijo (fun, x0,nmaxiteraciones)
  global precision
  npasos=1;
  x=x0;
  fval=feval(fun,x);
  while(npasos <= nmaxiteraciones)
    if(norm(x-fval)<= precision)
      return
    end 
    x=fval;
    fval=feval(fun,x);
    npasos=npasos+1;
  end
  error('No hay convergencia de punto fijo');
endfunction
