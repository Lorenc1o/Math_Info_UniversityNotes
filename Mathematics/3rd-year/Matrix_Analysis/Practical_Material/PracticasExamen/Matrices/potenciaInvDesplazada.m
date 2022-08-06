%% Método de la potencia inversa desplazada para aproximar el valorpropio 
%% de la matriz "A" mas cercano
%% a la aproximacion inicial "vaprox" utilizando el vector inicial "x0" 
%% la condición de parada viene dada porque las diferencias de radios consecutivos 
%% son menores que la "precision" (variable global) utilizada  o porque el residual Bx-rx 
%% menor que "precision"
%% Si en el numero maximo de iteraciones indicado no converge devuelve un error
 
function [valorpropio,vectorpropio]=potenciaInvDesplazada(A,vaprox,x0,nmaxiteraciones,prec)
  n=length(A);
  x0=ones(n,1); 
  v=x0;
  y0=x0/norm(x0);
  B=inv(A-vaprox*eye(n));
  By=B*y0;
  r0=dot(By,v)/dot(y0,v);
  for i=1:nmaxiteraciones
    y1=By/norm(By);
    By=B*y1;
    r1=dot(By,v)/dot(y1,v);
    if and(abs(r1-r0)<prec, norm(B*y1-r1*y1)<prec)
      valorpropio=vaprox+1/r1;
      vectorpropio=y1;
    %  fprintf(' aproximación en %d pasos \n',i);
      return
    end
    r0=r1;
  end 
  fprintf(' Potencia no converge en %d pasos \n', nmaxiteraciones);
  error('Potencia no converge');
end