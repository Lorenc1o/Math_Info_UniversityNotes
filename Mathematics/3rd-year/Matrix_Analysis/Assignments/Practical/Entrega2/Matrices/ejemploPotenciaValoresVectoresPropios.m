clear all
clc

format long g
n=3;
A=[6,1,-0.5; 0.8,-1, 0.1; 1, -1, -4]

%%n=5
%%A=rand(n,n)

display(' los valores de la diagonal seran nuestras aproximaciones ')

% Resultados del comando eig() de octave/Matlab
d=eig(A)

[V,D]= eig(A)

% Parametros para el metodo de la potencia
% 

x0=ones(n,1);
v=x0;

prec=10^(-8);
nmaxiteraciones=1000;

% Metodo de la potencia 
% Busca el valor propio de mayor tamaño
display('METODO DE LA POTENCIA')


[valorpropio_1,vectorpropio_1]=potencia(A,x0,nmaxiteraciones,prec)

display(' vectorpropio_1 == - V(:,1) ')
% En realidad no coinciden en todos los dígitos...



% Metodo de la potencia inversa
% Busca el valor propio de menor tamaño
display('METODO DE LA POTENCIA INVERSA')
vaprox=0;
[valorpropio_3,vectorpropio_3]=potenciaInvDesplazada(A,vaprox,x0,nmaxiteraciones,prec)
display(' vectorpropio_3 == - V(:,3) ')

% Metodo de la potencia inversa con desplazamiento
% busca el valor propio más próximo a -4

display('METODO DE LA POTENCIA INVERSA CON DESPLAZAMIENTO A -4')

vaprox=-4

[valorpropio_2,vectorpropio_2]=potenciaInvDesplazada(A,vaprox,x0,nmaxiteraciones,prec)
display(' vectorpropio_2 == - V(:,2) ')