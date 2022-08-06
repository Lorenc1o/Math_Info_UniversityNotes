% Ejemplo 5.1.6
clear all
clc

format long g


function Y=f(X)
  Y(1)=  0.3*cos(X(2).*X(3))+0.15;
	Y(2)= 0.1*sqrt(X(1).^2+sin(X(3))+1.1)-0.2;
  Y(3)= -exp(-X(1)*X(2)-3)-0.5;
end

% X(1) \in [-0.15,0.45]
% x(2) \in [-0.2,0]
% x(3) \in [-0.55,-0.53]
% con estas acotaciones || D Y(X) ||_\infty < 1.

X0=[1,1,-1]

global precision=0.5e-12;
nmaxiteraciones=100;


[X,npasos] = puntofijo (@f, X0,nmaxiteraciones)


function Y=f_Gauss_Seidel(X)
  Y(1)=  0.3*cos(X(2).*X(3))+0.15;
	Y(2)= 0.1*sqrt(Y(1).^2+sin(X(3))+1.1)-0.2;
  Y(3)= -exp(-Y(1)*Y(2)-3)-0.5;
end

[X_Gauss_Seidel,npasos_Gauss_Seidel] = puntofijo (@f_Gauss_Seidel, X0,nmaxiteraciones)
%%
display(' ')
display('PUNTO FIJO ACELERACION DE AITKEN')
[X,npasos] = puntofijoAitkenVV (@f, X0,nmaxiteraciones)