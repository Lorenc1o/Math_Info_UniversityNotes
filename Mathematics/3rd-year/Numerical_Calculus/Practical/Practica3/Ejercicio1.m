%Ejercicio1

addpath('../Biblioteca');

x=[1, 2, 3, 4];
y=[1, 7, 4, 2];
n=3;

polyfit(x, y, n)

coef_polinomio_interpolador(diferencias_divididas(x,y),x)
