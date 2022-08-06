clear all
clc
clf 
addpath("../Matrices")

x=[0,1/6,1/3,1/2];
y=[0.4,0.5,0.8,1.5];

A=ones(4,2);
b=ones(4,1);

for i=1:4
  A(i,1)=cos(pi*x(i));
  A(i,2)=sin(pi*x(i));
  b(i)=y(i)-1;
endfor

X=fitMinimosCuadradosQR(A,b)

f=@(x) 1+X(1)*cos(pi*x)+X(2)*sin(pi*x);
g=@(x) 1-0.663*cos(pi*x)+0.224*sin(pi*x);

z=linspace(-0.05,0.55);
plot(z,f(z))
hold on
plot(x,y,'o')
plot(z,g(z),'g')