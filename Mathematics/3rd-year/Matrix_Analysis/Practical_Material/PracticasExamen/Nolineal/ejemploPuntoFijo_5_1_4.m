% Ejemplo 5.1.4
clear all
clc

format long g
global A=0.4
global B=0.2

function Y=f(X)
  global A;
  global B;
  Y(1)=A*sin(X(1))-B*cos(X(2));
  Y(2)=A*cos(X(1))+B*sin(X(2));
end

X0=[0,0]';

global precision=0.5e-10;
nmaxiteraciones=100;

display('PUNTO FIJO')
[X,npasos] = puntofijo (@f, X0,nmaxiteraciones)


display(' ')
display('PUNTO FIJO Gauss-Seidel')
function Y=f_Gauss_Seidel(X)
  global A;
  global B;
  Y(1)=A*sin(X(1))-B*cos(X(2));
  Y(2)=A*cos(Y(1))+B*sin(X(2));
end

[X_Gauss_Seidel,npasos_Gauss_Seidel] = puntofijo (@f_Gauss_Seidel, X0,nmaxiteraciones)
%%
%%
display(' ')
display('PUNTO FIJO ACELERACION DE AITKEN')
[X,npasos] = puntofijoAitkenVV (@f, X0,nmaxiteraciones)