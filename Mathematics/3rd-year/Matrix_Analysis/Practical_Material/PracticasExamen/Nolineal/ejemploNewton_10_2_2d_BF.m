% ejemplo 10.2 2d BF
clear all
clc
clf

f=@ (x,y) x.^2-y.^2+2*y;
g=@ (x,y) 2*x+y.^2-5;
ezplot(f)
hold on
ezplot(g)


format long g
global paso=0.01;
global precision=0.5e-5;
nmaxiteraciones=100;

X1=[2;-2];
X2=[0.7;2];
X3=[-2;3];
X4=[-5;-4];

F=@ (X) [X(1).^2-X(2).^2+2*X(2);2*X(1)+X(2).^2-5];

dF=@ (X) difAproximada(F,X);


[X_1,FX_1,pasos_1]=newtonV(F,dF,X1,nmaxiteraciones)

[X_2,FX_2,pasos_2]=newtonV(F,dF,X2,nmaxiteraciones)

[X_3,FX_3,pasos_3]=newtonV(F,dF,X3,nmaxiteraciones)

[X_4,FX_4,pasos_4]=newtonV(F,dF,X4,nmaxiteraciones)


plot([X_1(1),X_2(1),X_3(1),X_4(1)],[X_1(2),X_2(2),X_3(2),X_4(2)],'r*')