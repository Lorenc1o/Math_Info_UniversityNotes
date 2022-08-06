clear all
clc
clf 
format long g
addpath('../Biblioteca');

f=@(x) tan(pi.*x)-6;

aa=0;
bb=0.48;

errorParada = 0.5e-8;

tol = 0.5e-8;
maxIteraciones = 50;

cero = biseccion(f,aa,bb,errorParada)

cero = regulafalsi(f,aa,bb,errorParada,tol,maxIteraciones)

x0=0.475;
x1=bb;
cero = secante(f,x0,x1,errorParada,maxIteraciones)

xx=[aa,bb]
[x,fval,exitflag,output]=fzero(f,xx)

tx=linspace(aa,bb,187);

plot([aa,bb],[0,0],tx,f(tx));
