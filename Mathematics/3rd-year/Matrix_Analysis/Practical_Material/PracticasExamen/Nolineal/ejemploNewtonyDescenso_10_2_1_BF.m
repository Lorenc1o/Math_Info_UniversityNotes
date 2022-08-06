% Ejemplo 5.1.6
clear all
clc

format long g
global paso;
paso=0.01;
global precision;

precision=0.5e-3;

%X0=[0.1,0.1,-0.1]';
X0=[11,11,11]';
nmaxiteraciones=1000;


X=X0;

F=@ (X)  [3*X(1)- cos(X(2).*X(3))-0.5 ;
X(1).^2-81*(X(2)+0.1).^2+sin(X(3))+1.6 ;
-exp(-X(1)*X(2))+20*X(3)+(10*pi-3)/3]


dF=@ (X) difAproximada(F,X);

F_objetivo=@ (X) objetivo(F,X);

[Xm, FXm, npasos] = descensoRapido (F_objetivo, X0, nmaxiteraciones)

precision=5E-10;

 [X,FX,pasos]=newtonV(F,dF,Xm,nmaxiteraciones)









