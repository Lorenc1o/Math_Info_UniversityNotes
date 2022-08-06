%introduccion

clc 
clear all 

addpath('Biblioteca')
f='x^3+7*x^2-20*x+1';
a=0;
b=1;
N=10;

int_trapecios=trapecios(f,a,b,N)

int_simpson=simpson(f,a,b,N)

fi=@(x) x.^3+7.*x.^2-20.*x.+1;

int_trapecios_fi=trapecios_fi(fi,a,b,N)

int_simpson_fi=simpson_fi(fi,a,b,N)