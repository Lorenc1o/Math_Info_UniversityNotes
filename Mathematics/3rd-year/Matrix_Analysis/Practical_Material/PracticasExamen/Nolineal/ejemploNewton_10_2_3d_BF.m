% ejemplo 10.2 2d BF
clear all
clc
clf




[x,y,z]=meshgrid(-2:0.2:2,-2:0.2:2,-2:0.2:2);

eq1=2*x-3*y+z-4;
eq2=2*x+y-z+4;
eq3=x.^2+y.^2+z.^2-4;

isosurface(x,y,z,eq1,0);
isosurface(x,y,z,eq2,0);
isosurface(x,y,z,eq3,0);


format long g
global paso=0.01;
global precision=0.5e-5;
nmaxiteraciones=100;
%%
X1=[-0.5;-1.3;0];
X2=[-0.5;-1;2];
%%
%%
%%
F=@ (X) [2*X(1)-3*X(2)+X(3)-4; 
              2*X(1)+X(2)-X(3)+4;
              X(1).^2+X(2).^2+X(3).^2-4];

F(X1)

dF=@ (X) difAproximada(F,X);
dF(X1)

[X_1,FX_1,pasos_1]=newtonV(F,dF,X1,nmaxiteraciones)

[X_2,FX_2,pasos_2]=newtonV(F,dF,X2,nmaxiteraciones)
