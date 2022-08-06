% Ejercicio 1
% Ejemplo 3 de 7.5 en Burdain-Faires

clear all
clc
addpath('../Matrices')

U=[0,0.1,1,1,0;
   0,0, -1,1,-1;
   0,0,0, 0,-2;
   0,0,0,0,4;
   0,0,0,0,0];
dA=[0.2,4,60,8,700]';
D=diag(dA);

A=U'+D+U
b=[10,2,3,40,5]'

condicion_A=cond(A)
           %% condicion_A = 12265.15914047151

x=solveGaussParcial(A, b);
res=b-A*x;
control_residual=norm(res)
           %% control_residual = 1.812079887306976e-14

%% Jacobi y GaussSeidel
xn=ones(5,1);
prec=0.5e-4;
nmaxit=1000;

  try
  
    tic
  x=iterJacobi(A,b,xn,nmaxit,prec);
    toc
    %% Elapsed time is 0.00683999 seconds.
  control_Jacobi=norm(b-A*x)
      %% Jacobi converge en 79 iteraciones con precision 4.81625e-05 en el residual
      %% control_Jacobi = 0.002007862188612569
  catch
  display('Jacobi no converge');
  end

  try
    tic
  x=iterGaussSeidel(A,b,xn,nmaxit,prec);
    toc
    %% Elapsed time is 0.024682 seconds.
  control_GS=norm(b-A*x)
      %% Gauss Seidel converge en 30 iteraciones con precision 4.46017e-05 en el residual
      %% control_GS = 0.0002222467531242776
  catch
  display('Gauss-Seidel no converge');
end 

  try
  J=inv(D)*(-U'-U);
  lambda=eig(J);% funcion valores y vectores propios
  rho=max(abs(lambda))
  %% 
  peso=2/(1+sqrt(1-rho^2))
  %% peso = 1.356838550149635
    tic
  x=iterRelajacion(A,b,peso,xn,nmaxit,prec);
    toc
    %% Elapsed time is 0.00962114 seconds.
  control_relajacion=norm(b-A*x)
      %% Relajacion converge en 15 iteraciones con precision 2.24393e-05 en el residual
      %% control_relajacion = 0.0003344196319772052
  catch
  display('Relajacion no converge');
  end  
 C=sqrt(D); %no mejora el condicionamiento porque es multiplo de la identidad.

  tic
x=gradienteConjugadoPrecondicionado (A,b,xn,C,prec);
  toc
  %% Elapsed time is 0.0318129 seconds.
control_grad_Precond=norm(b-A*x)
  %% gradiente precondicionado converge en 5 iteraciones con precion 1.14228e-15 en el residual
  %% control_grad_Precond = 4.077164630631166e-14

  tic
x=gradienteConjugado (A,b,xn,prec);
  toc
  %% Elapsed time is 0.017808 seconds.
control_grad=norm(b-A*x)
  %% Gradiente converge en 5 iteraciones con precion 8.47019e-07 en el residual
  %% control_grad = 3.531163663400858e-05

rmpath('../Matrices')
  
  
  
  
  
  
  
  
  
  

