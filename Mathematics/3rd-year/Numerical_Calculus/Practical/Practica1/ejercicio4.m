disp('Ejercicio 4')
clear all
clc 

fprintf('Problema 4a:\n')
a=5556;
b=5555;

sol_real = cbrt(a)-cbrt(b)

global n=4;
fprintf('Redondeando a 4 dígitos:\n')
A = fls(cbrt(a));
B = fls(cbrt(b));
sol = fls(A-B)

fprintf('Problema 4b:\n')
sol = restaCubicas(a,b,n);
fprintf('La solucion usando el algoritmo es: \n')
sol

fprintf('Problema 4c:\n')

err_abs=abs(sol_real-sol)
err_rel=err_abs/abs(sol_real)

global n=8;
fprintf('Redondeando a 8 dígitos:\n')
A = fls(cbrt(a));
B = fls(cbrt(b));
sol = fls(A-B)

fprintf('Problema 4b:\n')
sol = restaCubicas(a,b,n);
fprintf('La solucion usando el algoritmo es: \n')
sol

fprintf('Problema 4c:\n')

err_abs=abs(sol_real-sol)
err_rel=err_abs/abs(sol_real)