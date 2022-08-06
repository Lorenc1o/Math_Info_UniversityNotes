% Ejercicio 6

clc
clear all
clf

addpath('../Nolineal')



f=@ (x,y) 4*x.^2 -20*x+0.25* y.^2 -8;
g=@ (x,y)  14* x.* y.^2 + 2*x - 5*y +8 ;
ezplot(f)
hold on
ezplot(g)
hold off

F=@(X) [4*X(1).^2-20*X(1)+0.25*X(2).^2-8;14*X(1)* X(2).^2+2*X(1)-5*X(2)+8];

figure(2);
tx = ty = linspace (-3, 3, 41)';
length(tx)
[xx, yy] = meshgrid (tx, ty);
tz=f(xx,yy).^2+g(xx,yy).^2;

mesh (tx, ty, tz);
xlabel ("tx");
ylabel ("ty");
zlabel ("tz");
title ("Superficie");



Fobj=@(X) objetivo(F,X);
global paso;
paso=0.01;
global precision;
precision=0.001;
X0=[0,0];
X1=[5,3];
F(X0)

nmaxiter=100;
[Xm1, FXm1, npasos1] = descensoRapido (Fobj, X0, nmaxiter)

[Xm2, FXm2, npasos2] = descensoRapido (Fobj, X1, nmaxiter)

%%
precision=5E-7;

dF=@ (X) difAproximada(F,X);
[X_1,FX_1,pasos_1]=newtonV(F,dF,Xm1',nmaxiter)

[X_2,FX_2,pasos_2]=newtonV(F,dF,Xm2',nmaxiter)








rmpath('../Nolineal')