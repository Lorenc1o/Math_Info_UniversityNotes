% Ejercicio 3.2
clc
clear all
addpath('../Matrices')

% Apartado 1
n = 4;
A = matrizDiagonalDominante(n);


% Apartado 2
[L, D, R] = LDR(A);
control_ldr = norm(A - L*D*R)


% Apartado 3
A = symmetricMat(n);


% Apartado 4
A = spdMat(n)
[P, D] = eig(A)

% Apartado 5
L = factorLdeCholeski(A)
control_Choleski = norm(A-L*L')

%% El comando chol de octave/matlab devuelve la matriz L^t
R=chol(A);
L_oct=R'

% Apartado 6
b=10*rand(n,1)-5*ones(n,1);

%% Se han incluido en biblioteca la funcion solveCholeski_L(L,b) que devueve
%% la solución de Ax=b como solveU(L',solveL(L,b)), suponiendo que se obtuvo L (de Choleski)
%% con antelacion.
%% Tambien se ha incluido la funcion solveCholeski(A,b) que devuelve la solucion
%% de Ax=b calculando dentro la matriz L de Choleski.

sol1=solveCholeski_L(L,b)
res1=norm(b-A*sol1)

sol2=solveCholeski(A,b)
res2=norm(b-A*sol2)


rmpath('../Matrices')