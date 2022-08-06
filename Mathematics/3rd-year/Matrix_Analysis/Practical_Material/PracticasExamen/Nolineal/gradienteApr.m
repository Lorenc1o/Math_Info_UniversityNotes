## Author: apall <apall@DESKTOP-GFJQNNP>
## Created: 2019-05-12

function gradiente = gradienteApr (Fobjetivo, X)
  global paso;
  n=length(X);
  gradiente=X;
  for i=1:n
    Z=X;
    Z(i)=X(i)+paso;
    F1=feval(Fobjetivo,Z);
    Z(i)=X(i)-paso;
    F2=feval(Fobjetivo,Z);
    gradiente(i)=(F1-F2)/(2*paso);
  end
endfunction
