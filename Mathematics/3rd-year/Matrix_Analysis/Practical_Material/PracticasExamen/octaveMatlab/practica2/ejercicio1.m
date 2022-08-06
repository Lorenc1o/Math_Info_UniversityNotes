%Ejercicio 2.1 
clc
clear all
addpath('../Matrices')
disp("Ejercicio 2.1");
disp("Apartado 1");
A=[10,7,8,7;7,5,6,5;8,6,10,9;7,5,9,10]

condicion1_A=cond(A,1)       
condicionInf_A=cond(A,Inf)
condicion_A=cond(A,2)

disp("Apartado 2");
%Vamos a ver que las matrices de Hilbert están mal condicionadas 
 nd=15    %Número de muestras que vamos a tomar 
 n= 1:nd ;  
 condicion= zeros(1,nd);
 for k=1:nd
   condicion(k)= cond(hilb(k));
 endfor
 
 plot(n,log(condicion))
