clc
clear all
clf
addpath("Matrices")

f=@ (x,y) sin(4*pi*x.*y)-2*y-x;
g=@ (x,y) (4*pi-1)/(4*pi)*(exp(2*x)-6)+4*e*y.^2-2*e*x;

ezplot(f,1000) %1000 porque el valor por defecto no proporciona una buena gráfica
hold on
ezplot(g)

%parece haber 4 puntos de corte

format long g
global paso=0.01;
global precision=0.5e-5;
nmaxiteraciones=100;

X1=[-1;0.1]; %Fijandonos en la grafica, aproximamos las soluciones 'a ojo'
X2=[-0.9;0.2];
X3=[-0.6;0.4]
X4=[0.8;-0.6];
X5=[1.2;-0.4];
X6=[1.2;-0.2];

F=@ (X) [sin(4*pi*X(1)*X(2))-2*X(2)-X(1); 
     (4*pi-1)/(4*pi)*(exp(2*X(1))-6)+4*e*X(2).^2-2*e*X(1)];
     
dF= @(X) difAproximada(F,X);

[X_1,FX_1,pasos_1]=newtonV(F,dF,X1,nmaxiteraciones)

[X_2,FX_2,pasos_2]=newtonV(F,dF,X2,nmaxiteraciones)

[X_3,FX_3,pasos_3]=newtonV(F,dF,X3,nmaxiteraciones)

[X_4,FX_4,pasos_4]=newtonV(F,dF,X4,nmaxiteraciones)

[X_5,FX_5,pasos_5]=newtonV(F,dF,X5,nmaxiteraciones)

[X_6,FX_6,pasos_6]=newtonV(F,dF,X6,nmaxiteraciones)

%obtenemos los cuatro puntos de corte

rmpath("Matrices")