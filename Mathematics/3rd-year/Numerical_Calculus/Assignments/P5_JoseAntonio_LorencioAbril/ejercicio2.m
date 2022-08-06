%Ejercicio 2

%% a

clc 
clear 
addpath('Biblioteca')

f=@(x) (sin(x)+(x==0))./(x+(x==0));
a=-1;
b=1;

comparar(f, a, b, 2);
comparar(f, a, b, 3);

g=@(x) e.^x./(1-x.^2);
a=a+0.00001;
b=b-0.00001;

comparar(g, a, b, 2);
comparar(g, a, b, 3);

h=@(x) 1./(1+x.^2);
a=0;
b=2;

comparar(h, a, b, 2);
comparar(h, a, b, 3);

y=@(x) x.^2 .*sin(x);
b=pi/4;

comparar(y, a, b, 2);
comparar(y, a, b, 3);


z=@(x) x.^2 .*log(x);
a=1;
b=1.5;

comparar(z, a, b, 2);
comparar(z, a, b, 3);

