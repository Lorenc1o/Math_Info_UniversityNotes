%ejercicio 1

clc
clear all 
addpath('../Biblioteca');

xx=[0,0,3,3,5,5,9,9,12,12];
yy=[0,0,99,99,165,165,290,290,380,380];
difdiv_2=[30,33,33,33,30,31.25,25,30,33];

dif_div=diferencias_divididas_Hermite(xx,yy,difdiv_2);

pol9=coef_polinomio_interpolador(dif_div,xx);

t=10;
pos10=polyval(pol9,t)

pol_der=polyder(pol9);

vel10=polyval(pol_der,t)

%los resultados no parecen muy fiables (derivada) y no tenemos información 
%para estimar errores
%ALTERNATIVA Usar información de puntos proximos

xx_prox=[9,9,12,12];
yy_prox=[290,290,380,380];
dif_div_prox_2=[25,30,33];
dif_div_prox=diferencias_divididas_Hermite(xx_prox,yy_prox,dif_div_prox_2);

pol3=coef_polinomio_interpolador(dif_div_prox,xx_prox);

pos10=polyval(pol3,t)

pol_der2=polyder(pol3);

vel10=polyval(pol_der2,t)

%error en posicion es del orden de f^(4)/4!*Prod(10-XX(i)) 
%eso esta acotado por 0.2 (ver columna 5 en tabla de hermite)

error_cota_posicion = 0.2*(t-9)*(t-9)*(t-12)*(t-12)

%para estimar el error en la derivada ir al tema de derivacion aproximada
%se usan la derivada 4 y la 5 y algunos productos (error bruta +/- 2m/s)

