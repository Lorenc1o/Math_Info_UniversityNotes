%ejercicio 3
clc 
clear 
n=127;

f=@(x) (x-1).^4;
%g=@(x) 1-4*x+6*x^2-4*x^3+x^4
pg=[1,-4,6,-4,1];

a=1-3e-4;
b=1+3e-4;
t=linspace(a,b,n);
plot(t,f(t),t,polyval(pg,t));
legend('f','g');