disp('Ejercicio 2')
clear all
clc 

global n=7
a = 0.5234563;
b = 0.5711321;
c = -0.5988678;

r1 = fls(a+fls(b+c));
r2 = fls(fls(a+b)+c);

fprintf('Problema 2: El primer resultado es %d y el segundo es %d\n', r1, r2)

