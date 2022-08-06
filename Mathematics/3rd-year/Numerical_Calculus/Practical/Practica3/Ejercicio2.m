%Ejercicio 2
clear
clc 
clf
addpath('../Biblioteca')

x=[0.3,0.37,0.41,0.52];
y=[0.97741,0.96557,0.95766,0.93157];

difdiv=diferencias_divididas(x,y);

%a
p3=coef_polinomio_interpolador(difdiv,x);
yy=polyval(p3, 0.47);
fx=0.94423;

e_a = abs(fx-yy);
e_r = e_a / fx;
printf('P3(0.47)=%d, con Error Absoluto %d y Error Relativo %d\n', yy, e_a, e_r);

%b

x=[0.3,0.37,0.41,0.52,0.47];
y=[0.97741,0.96557,0.95766,0.93157,0.94423];

difdiv=diferencias_divididas(x,y);

p4=coef_polinomio_interpolador(difdiv,x);

%para dibujar los polinomios
xx=linspace(0,1);
yy=polyval(p3, xx);
zz=polyval(p4,xx);
plot(x,y,'o',xx,yy,'r',xx,zz,'color','green','r');
legend('fx', 'p3', 'p4');
