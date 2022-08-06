% Ejercicio 1
clc
clear all
clf

addpath('../Nolineal')



f=@ (x,y) x.^2- 10 *x + y.^2 +8;
g=@ (x,y) x.*y.^2 +x- 10*y -2;
ezplot(f)
hold on
ezplot(g)

% punto fijo

G=@(X) [0.1*(X(1).^2+X(2).^2+8);0.1*(X(1)*X(2)^2+X(1)-2)];

global precision;
precision=5E-10;
nmaxit=200;

X0=[0,0];

[ptofijo,npasosPF]=puntofijo(G,X0,nmaxit)

plot(ptofijo(1),ptofijo(2),'b*') 

X1=[3,3]

[ptofijo2,npasosPF2]=puntofijo(G,X1,nmaxit)
%nos da el mismo punto fijo atractor

function V=GS(X)
  V(1)= 0.1*(X(1).^2+X(2).^2+8);
  V(2)= 0.1*(V(1)*X(2)^2+V(1)-2);
end

[ptofijoGS,npasosPFGS]=puntofijo(@GS,X0,nmaxit)
%Gauss-Seidel no parece mejorar la convergencia con precision=5e-6
display('PUNTO FIJO ACELERACION DE AITKEN')
[X,npasos] = puntofijoAitkenVV (G, X0,nmaxit)


%% Newton o Boyren para buscar la otra solución del sistema que está cerca de (3,3)

X1=[3;3]

F=@ (X) [X(1).^2- 10*X(1) + X(2).^2+8; X(1).*X(2)^2+X(1)- 10*X(2)-2];

global paso=0.01;
dF=@ (X) difAproximada(F,X);


[X_1,FX_1,pasos_1]=newtonV(F,dF,X1,nmaxit)
plot(X_1(1),X_1(2),'b*') 






hold off

rmpath('../Nolineal')
