%Ejercicio 1.4 
clc
clear all
disp("Ejercicio 1.4");
disp("Apartado 1");
n=4
A=10*rand(n,n)-5*ones(n,n)  %Para que tome valores entre -5 y 5
R= triu(A)                  %Matriz triangular superior de A
B= 10*rand(n,3)-5*ones(n,3)
x=solveU(R,B)
control_1= norm(R*x-B)      %Compruebo sí es la solución 

disp("Apartado 2");
inversaR= inversaU(R)       %Saco la inversa de la matriz
control_2=norm(R*inversaR-eye(n))

disp("Apartado 3");
L=tril(A)                   %Triangular inferior de A
s= solveL(L,B)
control_3=norm(L*s-B)
inversaL=solveL(L,eye(n))   %Compruebo que solveL nos da la inversa 
control_4=norm(inversaL*L-eye(n))

