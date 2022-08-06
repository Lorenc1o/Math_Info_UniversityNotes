%Ejercicio 2.2 
clc
clear all
addpath('../Matrices')
disp("Ejercicio 2.2");
b=[32,23,33,31]'

A=[10,7,8,7;7,5,6,5;8,6,10,9;7,5,9,10]

[Q,R]=GramSchmidt(A)       %Factorizacion de A 

x=solveQR(Q,R,b)
residuo= b-A*x
control_1= norm(residuo)

ix=solveQR(Q,R,residuo);   %Mejoramos la solución
xn= x+ix;
control_2= norm(b-A*xn)