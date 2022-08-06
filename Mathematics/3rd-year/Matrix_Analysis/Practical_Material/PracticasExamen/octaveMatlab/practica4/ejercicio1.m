clear all
clc 
addpath('../Matrices');

b = [32,23,33,31]';
A = [10,7,8,7;
    7,5,6,5;
    8,6,10,9;
    7,5,9,10]
    
[L,U,P]=LUPGauss(A)

control_lup = norm (P*A-L*U)

X = solveGaussLUP(L,U,P,b);

X = solveGaussParcial(A, b)

residual = b - A*X;
control_X = norm(residual)

%A aleatoria 
n=4;

Ar = 10*rand(n,n)-5*ones(n,n);

[L,U,P]=LUPGauss(Ar);

control_lup = norm (P*Ar-L*U)

br = 4*rand(n,1)-2*ones(n,1);

Xr = solveGaussLUP(L,U,P,br)

residual_Xr = br - Ar*Xr;
control_Xr = norm(residual_Xr)

control_Ar = cond(Ar)

%apartado 2

delta_Xr = solveGaussLUP(L,U, P, residual_Xr);

e_rel_Xr = norm(delta_Xr) / norm(Xr) 

e_rel_br = norm(residual_Xr) / norm(br)

%estimacion del numero de condicion, Apartado 3

estimation_cond = e_rel_Xr/1e-16

display('numero de condicion de octave')
num_cond=cond(Ar)










rmpath('../Matrices');