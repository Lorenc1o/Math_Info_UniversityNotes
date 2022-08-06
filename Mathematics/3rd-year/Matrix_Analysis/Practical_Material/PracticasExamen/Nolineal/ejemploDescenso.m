% ejemplo descenso rapido

clear all
clc

clf

format long g

figure(1);
tx = ty = linspace (-8, 8, 41)';
[xx, yy] = meshgrid (tx, ty);
tz=xx.*exp(-(xx.^2 + yy.^2)) + (xx.^2 + yy.^2)/20;
mesh (tx, ty, tz);
xlabel ("tx");
ylabel ("ty");
zlabel ("tz");
title ("Superficie");

display(' ')
display('Minimo de una funcion de varias variable')
fun = @(x) x(1)*exp(-(x(1)^2 + x(2)^2)) + (x(1)^2 + x(2)^2)/20
X0 = [1,2] 
[X,fval] = fminunc(fun,X0)
global paso=0.001;
global precision=0.5e-9;
nmaxiter=100;
[Xm, FXm, npasos] = descensoRapido (fun, X0, nmaxiter)

