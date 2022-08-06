clear all
clc 
addpath('../Matrices');

n=10;

Ar = 10*rand(n,n)-5*ones(n,n)

[L,U,P]=LUPGauss(Ar);

%% en biblioteca se ha incluido la función determinantePerm(P) para evaluar
%% el determinante de una matriz permutacion
display('Distitntas evaluaciones de los determinantes')
det_P=determinantePerm(P)
%det_L=prod(diag(L))=1
det_U=prod(diag(U))
det_LUP1=det_P*1*det_U


det_lup = determinanteLUP(L, U, P);

det_octave = det(Ar);

det_Gauss= determinanteGauss(Ar);

display('calculo de la inversa con Gauss LUP')
inversa = inversaGaussLUP(L, U, P)

control_inv = norm(eye(n)-inversa*Ar) 





rmpath('../Matrices')