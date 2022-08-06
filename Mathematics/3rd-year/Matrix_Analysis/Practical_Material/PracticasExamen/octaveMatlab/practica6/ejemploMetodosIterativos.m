% ejemplo metodos iterativos
clear
clc

addpath('../Matrices')

n=10 %prueba con n=10 n=100,n=1000 
%%   y comentando todo menos gradiente conjugado con n=10000
xn=ones(n,1);
nmax=1000;
prec=1.0e-7

d=4;  %Prueba con d=4.1, d=5
A=diag(d*ones(n,1))+diag(-ones(n-1,1),1);
A=A+diag(-ones(n-1,1),-1)+diag(-ones(n-2,1),2)+diag(-ones(n-2,1),-2);
b=rand(n,1);
  if n<10 
    A
    b
  end 
%%  tic
%% x=A\b;
%%  toc
  
  try
  
    tic
  x=iterJacobi(A,b,xn,nmax,prec);
    toc
  control_Jacobi=norm(b-A*x)
  catch
%%  display('Jacobi no converge');
  end
%%  
%%  
%%  
%%  try
%%    tic
%%  x=iterGaussSeidel(A,b,xn,nmax,prec);
%%    toc
%%  control_GS=norm(b-A*x)
%%  catch
%%  display('Gauss-Seidel no converge');
%%  end 
%%  
%%  try
 D=diag(diag(A));
%%  J=inv(D)*(A-D);
%%  lambda=eig(J);% funcion valores y vectores propios
%%  rho=max(abs(lambda));
%%
%%  peso=2/(1+sqrt(1-rho^2))
%%    tic
%%  x=iterRelajacion(A,b,peso,xn,nmax,prec);
%%    toc
%%  control_relajacion=norm(b-A*x)
%%  catch
%%  display('Relajacion no converge');
%%  end  

C=sqrt(D); %no mejora el condicionamiento porque es multiplo de la identidad.

%%  tic
%%x=gradienteConjugadoPrecondicionado (A,b,xn,C,prec);
%%  toc
%%control_grad_Precond=norm(b-A*x)

  tic
x=gradienteConjugado (A,b,xn,prec);
toc
control_grad=norm(b-A*x)







rmpath('../Matrices')

