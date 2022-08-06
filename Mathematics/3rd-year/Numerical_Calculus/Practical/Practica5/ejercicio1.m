%Ejercicio 1
%Tenemos que hacer una tabla de los valores de la distribución normal
%La integral entre -inf y x es igual a 1/2 + int entre 0 y x
%Debemos estimar el error

clc 
clear all
addpath('../Biblioteca')

f=@(x) (1/sqrt(2*pi))*exp(-x.^2/2);

%% (a)

%% acotamos primero integ entre M e Inf f(t)dt por 10^-6

M=2;
while (2/M*f(M)>1e-7)
  M=2*M;
end
M


n=2; %numero de particiones para simpson
S1=simpson_fi(f,0,M,n);
S2=simpson_fi(f,0,M,2*n);

while (abs(S2-S1)>1e-6)
  n=2*n;
  S1=S2;
  S2=simpson_fi(f,0,M,2*n);
end 

display('numero de particiones para que el error sea < 10^-6')
n

%si x está entre 0 y M con n particiones tenemos que el error es menor que 10^-6

for (i=0:40)
  for(j=0:9)
    T(i+1,j+1)=0.5+simpson_fi(f,0,i*0.1+j*0.01,n);
  end
end

printf('El valor de la integral buscada es %d\n', T(11,1));

A="<html>\n\t<head>\n\t</head>\n\t<body>\n\t\t<table style=\"width:100%\">\n\t\t<tr style=\"background-color: #DEB887\">\n\t\t\t<td></td>\n";
for (j=0:9)
  A = [A "\t\t\t<td>" num2str(j*0.01) "</td>\n"];
end
for (i=0:40)
  A=[A "\t\t<tr>\n\t\t\t<td style=\"background-color: #DEB887\">" num2str(i*0.1) "</td>\n"];
  for(j=0:9)
    A=[A "\t\t\t<td style=\"background-color: #F2F5A9\">" num2str(T(i+1,j+1)) "</td>\n"];
  end
  A = [A "\t\t</tr>\n"];
end
A = [A "\t\t</tr>\n"];
A = [A "\t</body>\n</html>"];
save tabla_normal.html A

