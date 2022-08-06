% ejercicio 2
clc
clear all
clf

addpath('../Nolineal')


[x,y,z]=meshgrid(-2:0.2:2,-2:0.2:2,-2:0.2:2);

eq1=3*x-cos(y+z)-0.5;
eq2=x.^2-81*(y+0.1).^2+sin(z)+1.06;
eq3=exp(-x.*y)+20*z-(10*pi-3)/3;

isosurface(x,y,z,eq1,0);
isosurface(x,y,z,eq2,0);
isosurface(x,y,z,eq3,0);

function Y=f(X)
  Y(1)=  1/3*(0.5+cos(X(2)+X(3)));
	Y(2)= sqrt(1/9*(X(1)^2+sin(X(3)+1.06)))-0.1 ;
  Y(3)= 1/20*((10*pi-3)/3 - exp(-X(1)*X(2)));
end

X=[0.5,0.5,0.5]
global precision;
precision=0.5e-12;
nmaxiteraciones=100;

[pfijo,npasosPf]=puntofijo(@f, X,nmaxiteraciones)


function Y=f2(X)
  Y(1)=  1/3*(0.5+cos(X(2)+X(3)));
	Y(2)= -sqrt(1/9*(X(1)^2+sin(X(3)+1.06)))-0.1 ;
  Y(3)= 1/20*((10*pi-3)/3 - exp(-X(1)*X(2)));
end
X2=[0.5,-0.5,0.5]
[pfijo2,npasosPf2]=puntofijo(@f2, X2,nmaxiteraciones)









rmpath('../Nolineal')