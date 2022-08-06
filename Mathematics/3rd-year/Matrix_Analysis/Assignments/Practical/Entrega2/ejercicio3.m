clc
clear all
clf
addpath("Matrices")

%a
display("")
display("Apartado a")
[x,y,z]=meshgrid(-2:0.2:2,-2:0.2:2,-2:0.2:2);

eq1=15*x+y.^2-4*z-13;
eq2=x.^2+10*y-z-11;
eq3=y-25*z+22;

isosurface(x,y,z,eq1,0);
isosurface(x,y,z,eq2,0);
isosurface(x,y,z,eq3,0);

F1=@ (X) [15*X(1)+X(2).^2-4*X(3)-13; 
              X(1).^2+10*X(2)-X(3)-11;
              X(2)-25*X(3)+22];

dF1=@ (X) difAproximada(F1,X);

format long g
global paso=0.01;
global precision=0.5e-5;
nmaxiteraciones=1000;


[X0,FX_1,pasos_1]=newtonV(F1,dF1,[1;1;1],nmaxiteraciones) %obtenemos las aproximaciones iniciales


%b
display("")
display("Apartado b")
precision=100; %para que funcione una única iteración
nmaxiteraciones=2;
X0=[0;0;0];

F=@ (X) [(13-X(2).^2 +4*X(3))/15;
          (11-X(1).^2+X(3))/10;
          (22+X(2))/25];
          
dF=@ (X) difAproximada(F,X);
F_objetivo=@ (X) objetivo(F,X);

[X1, pasos1]=puntofijo(F, X0, nmaxiteraciones)

precision=0.5e-5; %para ver qué hace punto fijo con más iteraciones
nmaxiteraciones=1000;
[X1, pasos1]=puntofijo(F, X0, nmaxiteraciones)

%nos da el mismo resultado que el apartado a

%c
display("")
display("Apartado c")
precision=0.5e-3;
nmaxiteraciones=1000;

[X_1,FX_1,pasos_1]=descensoRapido(F_objetivo,X0 ,nmaxiteraciones)


%d
display("")
display("Apartado d")
precision=0.5e-10;

[XN,FXN,pasos_1]=newtonV(F1,dF1,X0,nmaxiteraciones) %3 pasos

dFX0 = dF1(X0);

[XNB,FXNB,pasos_1]=quasiNewtonBoyrenV(F1,dFX0,X0,nmaxiteraciones) %6 pasos

[XN,FXN,pasos_1]=newtonV(F1,dF1,X_1,nmaxiteraciones) %3 pasos

dFX0 = dF1(X_1);

[XN,FXNB,pasos_1]=quasiNewtonBoyrenV(F1,dFX0,X_1,nmaxiteraciones) %7 pasos

%apartado e
display("")
display("apartado e")

[XN,FXN,pasos_1,nop]=newtonVop(F1,dF1,X_1,nmaxiteraciones,14) %3 pasos
%1234 operaciones

dFX0 = dF1(X_1);

[XN,FXNB,pasos_1, nop]=quasiNewtonBoyrenVop(F1,dFX0,X_1,nmaxiteraciones,14) %7 pasos
%696 operaciones






































































