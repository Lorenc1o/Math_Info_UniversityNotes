
addpath("../Nolineal")

global paso;
global precision;
format long;

X0=[0;0;0];

precision=1e-13;
nmaxiteraciones=inf;
paso=0.01;

F1=@ (X) [15*X(1)+X(2).^2-4*X(3)-13; 
              X(1).^2+10*X(2)-X(3)-11;
              X(2)-25*X(3)+22];

dF1=@ (X) difAproximada(F1,X);

F_objetivo=@ (X) objetivo(F1,X);

[X_1,FX_1,pasos_1]=descensoRapido(F_objetivo,X0 ,nmaxiteraciones) %47 pasos 

dFX0 = dF1(X0);

[XN,FXNB,pasos_1, nop]=quasiNewtonBoyrenVop(F1,dFX0,X_1,nmaxiteraciones,14) %4 pasos
%785 operaciones