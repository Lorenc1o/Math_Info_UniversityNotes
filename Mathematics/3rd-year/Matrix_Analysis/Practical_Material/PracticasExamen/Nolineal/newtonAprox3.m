% Metodo  de Newton devuelve aproximación a solucion de f(x)=0 
%
% como datos de entrada tiene 
% f (funcion), df (derivada de la funcion), x0 una aproximacion inicial a un cero de f (se escribe "f" entre comillas 
% si la funcion es externa, cuando es interna se escribe f sin comillas)
% devuelve
% x (aproximacion a una solucion de f(x)==0)
% fx (el valor f(x))
% npasos (número de iteraciones realizadas)

%% la condicion de parada es que  abs(f(x)) < precision o abs(x-nuevax)< precision
%% donde precision es una variable global,  o que se sobrepase un numero prefijado 
%% de iteraciones, en cuyo caso enviara un error.
function [x,fx,npasos]= newtonAprox3 (f,x0,nmaxiteraciones)
  global precision;
  global paso;
  
  npasos=0;
  x=x0;
  fx=feval(f,x);
  dfx=(feval(f,x+paso)-feval(f,x-paso))/(2*paso);
    if abs(fx)<precision
      return;
    end
    
    while npasos <= nmaxiteraciones
      npasos = npasos +1;
      if( abs(dfx)<100*eps )
        error('newton: derivada nula');
      end
      deltax=fx/dfx;
      x=x-deltax;
      fx=feval(f,x);
      if or(abs(fx)<precision,abs(deltax)<precision)
        return;
      end
      dfx=(feval(f,x+paso)-feval(f,x-paso))/(2*paso);
     end
     error('No hay convergencia de newton');       
end






