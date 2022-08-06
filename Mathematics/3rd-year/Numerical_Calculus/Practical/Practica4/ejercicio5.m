%ejercicio 5

clc 
clear all
clf 
addpath('../Biblioteca');

puntos=[0,0;1,-1;4,5;5,3;7,5;7,0;8,-1;9,0];
puntos_t=transpose(puntos);

tt=1:8;

%spline_n_x=
[bx,cx,dx]=splineNatural(tt,puntos_t(1,:))
%spline_n_y=
[by,cy,dy]=splineNatural(tt,puntos_t(2,:))

figure(1)

tx=linspace(1,8,181);

spl_x_tx=splineEval(tt,puntos_t(1,:),bx,cx,dx,tx);

spl_y_tx=splineEval(tt,puntos_t(2,:),by,cy,dy,tx);

plot(puntos_t(1,:),puntos_t(2,:),'o',spl_x_tx,spl_y_tx)