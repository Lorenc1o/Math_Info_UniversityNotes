%ejercicio 2

clc 
clear 

f1=@(x)(x-1).^6;
f2=@(x)1/((x+1).^6);
f3=@(x)(3-2*x).^3;
f4=@(x)1/((3+2*x).^3);
f5=@(x)99-70*x;
f6=@(x)1/(99+70*x);




raiz2=sqrt(2);

h=0.001;

df=@(f,x) (f(x+h)-f(x-h))/(2*h);

cond=@(f,x) abs(x.*df(f,x)/f(x));
cond(f1, raiz2)
cond(f2, raiz2)
cond(f3, raiz2)
cond(f4, raiz2)
cond(f5, raiz2)
cond(f6, raiz2)