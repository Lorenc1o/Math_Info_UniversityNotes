%% funcion para aproximar derivadas cn la formula de tres puntos
%%
%% requiere el uso de la variable "global paso" para pasar el incremento a usar en
%% la formula de aproximación
%%
%% Uso:
%% derivaprox3("f",x,h)
%% donde f es una "function" interna (@) o externa  

function df=derivaprox3(fun,x)
  global paso;
  h=paso;
  f1=feval(fun,x+h);
  f2=feval(fun,x-h);
  df=(f1-f2)./(2.*h);
endfunction

