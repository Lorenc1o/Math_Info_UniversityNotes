%ejercicio 2

clc

clear all

addpath('../Matrices')
n=6;
dp=linspace(8,10,n).*(ones(1,n)-2*randi([0,1],1,n))

di=5*rand(n-1,1)-2.5*ones(n-1,1);
ds=5*rand(n-1,1)-2.5*ones(n-1,1);

A=diag(dp)+diag(di,-1)+diag(ds,1)
b=5*rand(n,1)-2.5*ones(n,1);

x=solveGaussParcial(A, b);
res=b-A*x;
control_residual=norm(res)

xn=ones(n,1);
nmaxit=10;
prec=1.0e-3




    tic
  [x,k,e]=iter3dGaussSeidel(di,dp,ds,b,xn,nmaxit,prec);
    toc
  control_GS=norm(b-A*x)


try
    tic
  x_M=iterGaussSeidel(A,b,xn,nmaxit,prec);
    toc
  control_GS=norm(b-A*x_M)
  catch
  display('Gauss-Seidel no converge');
end 

%% relajación

%Matriz Jacobi
J=-diag(ones(1,n)./dp)*(diag(di,-1)+diag(ds,1));
rho=max(abs(eig(J)))
w=2/(1+sqrt(1-rho^2)) %% peso optimo



   tic
  [x,k,e]=iter3dRelajacion(di,dp,ds,b,w,xn,nmaxit,prec);
    toc
  control_Relajacion=norm(b-A*x)


try
    tic
  x_M=iterRelajacion(A,b,w,xn,nmaxit,prec);
    toc
  control_Relajacion=norm(b-A*x_M)
  catch
  display('Relajacion no converge');
end 

%%%  Laplaciana



f=@(x) 2*cos(pi*x).^2;
n=200  % n= 10 100 y 1000
printf('\n Laplaciana con n=%d \n ',n)

dp=2.03*ones(1,n-1);
di=-1*ones(1,n-2);
pa=2;
pb=2;
% termino independiente
b=1:n-1;
b=f(b'./n)./n^2;
b(1)=b(1)+pa;
b(n-1)=b(n-1)+pb;

A=diag(dp)+diag(di,-1)+diag(di,1);
%Matriz Jacobi
prec=1.0e-3
nmaxit=10000;
w=2/(1+sin(pi/n)) %% peso optimo

xn=ones(n-1,1);

  tic
  [x,k,e]=iter3dRelajacion(di,dp,di,b,w,xn,nmaxit,prec);
    toc
  control_Relajacion=norm(b-A*x)


try
    tic
  x_M=iterRelajacion(A,b,w,xn,nmaxit,prec);
    toc
  control_Relajacion=norm(b-A*x_M)
  catch
  display('Relajacion no converge');
end 



rmpath('../Matrices')