clear all
clc
clf 
addpath("../Matrices")

x=[1,2,3,4,5,6,7,8,9,10];
y=[2,4,6,7,9,10,12,13,14,15];

A=ones(10,3);
b=ones(10,1);

for i=1:10
  A(i,1)=exp(x(i))*x(i);
  A(i,2)=exp(x(i))*x(i).^2;
  A(i,3)=exp(x(i))*x(i).^3;
  b(i)=exp(y(i));
endfor

X=fitMinimosCuadradosQR(A,b)

f=@(x) x+log(X(1)*x + X(2)*x.^2 + X(3)*x.^3);

z=linspace(0,10);
plot(z,f(z))