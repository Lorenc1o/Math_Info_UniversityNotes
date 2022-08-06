% Ejemplos "Minimizers"
% Resolver una ecuación  F(x,y)=0 ; G(x,y)=0 
% equivale a encontrar un mímimo de f(x,y)=F(x,y)^2+G(x,y)^2
clear all
clc

clf


figure(1);
tx = ty = linspace (-8, 8, 41)';
[xx, yy] = meshgrid (tx, ty);
tz=xx.*exp(-(xx.^2 + yy.^2)) + (xx.^2 + yy.^2)/20;
mesh (tx, ty, tz);
xlabel ("tx");
ylabel ("ty");
zlabel ("tz");
title ("Superficie");
hold on

display('Minimo de una funcion de una variable')

r0=fminbnd(@(r) 1-sin(r)/r, -pi/2,pi/2)
%[r0, fval, info, output] =fminbnd(@(r) 1-sin(r)/r, -pi/2,pi/2)

display(' ')
display('Minimo de una funcion de varias variable')
fun = @(x)x(1)*exp(-(x(1)^2 + x(2)^2)) + (x(1)^2 + x(2)^2)/20
X0 = [1,2]; [X,fval] = fminunc(fun,X0)



function v = Fobjetivo(X)
  ra=sqrt(X(1)^2+X(2)^2)+eps;
  v=1-sin(ra)/ra;
end
Fobjetivo([2,3]);

figure(2);
tx = ty = linspace (-8, 8, 41)';
[xx, yy] = meshgrid (tx, ty);
r = sqrt (xx .^ 2 + yy .^ 2) + eps;
tz = 1.-sin (r) ./ r;
mesh (tx, ty, tz);
xlabel ("tx");
ylabel ("ty");
zlabel ("tz");
title ("Superficie 2");




X1=[-pi/4,pi/4];
[Y,val2]= fminunc(@Fobjetivo,X1)