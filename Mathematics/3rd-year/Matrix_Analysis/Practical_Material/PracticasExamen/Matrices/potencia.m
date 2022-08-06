%% Método de la potencia  para aproximar el mayor valorpropio 
%% de la matriz "A"  utilizando el vector inicial "x0" 
%% la condición de parada viene dada porque las diferencias de radios consecutivos 
%% son menores que la "precision" (variable global) utilizada  o porque el residual Bx-rx 
%% menor que "precision"
%% Si en el numero maximo de iteraciones indicado no converge devuelve un error
 
function [valorpropio,vectorpropio]=potencia(A,x0,nmaxiteraciones,prec)
  n=length(A);
  %x0=ones(n,1); 
  v=x0;
  y0=x0/norm(x0);
  Ay=A*y0;
  r0=dot(Ay,v)/dot(y0,v);
  for i=1:nmaxiteraciones
    y1=Ay/norm(Ay);
    Ay=A*y1;
    r1=dot(Ay,v)/dot(y1,v);
    if and(abs(r1-r0)<prec, norm(A*y1-r1*y1)<prec)
      valorpropio=r1;
      vectorpropio=y1;
      %fprintf(' aproximación en %d pasos \n',i);
      return
    end
    r0=r1;
  end 
  fprintf(' Potencia no converge en %d pasos \n', nmaxiteraciones );
  error('Potencia no converge');
end