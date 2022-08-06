disp('Ejercicio 6')
clear all 
clc 
clf %borrar figura

h=zeros(1,12);
e_a=h;
e_r=h;
cos1=cos(1);

fprintf('d\terror absoluto\terror relativo\n')

for i=1:12
  h(i)=10^(-i-4);
  der_aprox = (sin(1+h(i))-sin(1))/h(i);
  e_a(i)=abs(der_aprox-cos1);
  e_r(i)=e_a(i)/cos1;
  fprintf('%5d\t%5.7e\t%5.7e\n', h(i), e_a(i), e_r(i))
end

figure(1);
plot(h,e_a,h,e_r)
title('calculo en double')
legend('err-abs', 'err-rel')