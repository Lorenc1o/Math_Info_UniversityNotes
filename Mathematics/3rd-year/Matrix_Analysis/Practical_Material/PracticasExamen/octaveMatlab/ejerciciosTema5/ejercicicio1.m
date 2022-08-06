% ejercicio 1
clc
clear all

addpath('../Nolineal')

f=@(x) 1.4 * cos(x);

F=@(X) [f(X(2)),f(X(1))];


G=@(X) [f(X(2)),f(f(X(2)))];

global precision

precision=5E-7;
X0=[1,f(1)];
nmaxiteraciones=200;

[xf,npasosf] = puntofijo (F, X0,nmaxiteraciones)

[xg,npasosg] = puntofijo (G, X0,nmaxiteraciones)

X1=[-0.34,f(-0.34)];
[xf1,npasosf1] = puntofijo (F, X1,nmaxiteraciones)

[xg1,npasosg1] = puntofijo (G, X1,nmaxiteraciones)

tx=linspace(-0.5,1.4,127);
plot([-0.5,1.4],[-0.5,1.4],tx,f(tx),tx,f(f(tx)))





