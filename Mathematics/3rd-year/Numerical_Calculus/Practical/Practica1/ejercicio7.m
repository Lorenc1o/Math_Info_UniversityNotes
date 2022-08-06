disp('Ejercicio 7')
clear all
clc 

real_maximo = realmax
real_minimo = realmin 

% double 1 dig signo 52(+1) mantisa 11 exponente (base 2)

% exponente_max = 1024 o 1023
% exponente_min = -1023 o -1024

exponente_max=1023

mantisa_max=1;
for i=1:52
  mantisa_max += 2^(-i);
end 
mantisa_max 

maximo = mantisa_max*2^exponente_max

exponente_min=-1024

mantisa_min=1;

minimo = mantisa_min*2^exponente_min