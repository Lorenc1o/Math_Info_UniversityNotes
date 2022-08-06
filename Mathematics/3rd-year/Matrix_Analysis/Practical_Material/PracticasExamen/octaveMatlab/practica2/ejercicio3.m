%Ejercicio 2.3 
clc
clear all
addpath('../Matrices')
disp("Ejercicio 2.3");

n = 4;
A = 10*rand(n, n) - 5*ones(n, n);
L = tril(A,-1) + diag(ones(n, 1));
U = triu(A);

% El valor ha de ser distinto de 0, pues no puede haber ceros en la diagonal de U
control_diag_U = min(abs(diag(U)))

A = L*U;
[L_d, U_d] = LUdootlittle(A);

% Si la ejecución ha sido correcta, estos dos valores han de ser 0
control_fact_d = norm(A - L_d*U_d)
control_2 = norm(U - U_d);

[L_o,U_o] = lu(A);
control_octave = norm(A - L_o*U_o)

[L_o,U_o,P] = lu(A);
control_octave_2 = norm(P*A - L_o*U_o)


% Apartado 3

B = rand(n, 3);
X = solveLU(L_d, U_d, B);
control_solve = norm(A*X -B)


% Apartado 4

D = 3.1;
n = 1000;
A_s = D*eye(n) - diag(ones(n-1, 1), -1) - diag(ones(n-1, 1), 1) - diag(ones(n-2, 1), 2);
ki = 0:n-1;
b = 3*sin(ki*2*pi/(n-1));
[L, U] = LUdootlittle(A_s);
x = solveLU(L, U, b');
control_5 = norm(A_s*x -b')

rmpath('../Matrices')
