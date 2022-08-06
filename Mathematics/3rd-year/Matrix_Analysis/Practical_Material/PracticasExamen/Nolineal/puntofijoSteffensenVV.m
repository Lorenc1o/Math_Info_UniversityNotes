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

function [x,npasos] = puntofijoSteffensenVV (fun, x0,nmaxiteraciones)
  global precision
  npasos=1;
  x=x0;
  xa=x;
  n=length(x);
  fval=feval(fun,x);
  while(npasos <= nmaxiteraciones)
    delta1=x-fval;
    norm(delta1)
    if(norm(delta1)<precision)
      return
    end 
    ffval=feval(fun,fval);
    for i=1:n
      xa(i)=x(i)-(fval(i)-x(i))^2/(ffval(i)-2*fval(i)+x(i));
    end
    if(norm(xa-feval(fun,xa))<precision)
      x=xa;
      return
    end 
    x=fval;
    fval=feval(fun,x);
    npasos=npasos+1;
  end
  error('No hay convergencia de punto fijo');
endfunction
