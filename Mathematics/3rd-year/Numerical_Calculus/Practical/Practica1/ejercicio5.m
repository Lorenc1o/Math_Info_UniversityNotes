disp('Ejercicio 5')
clear all
clc 
%addpath(../biblioteca)

format long g

global n;
num_sum=10^4

sum_decr=0;
sum_crec=0;

suma_real=pi^2/6

%en doble precisión

tic
for j=1:num_sum 
  sum_decr += 1/j^2;
end
toc 

sum_decr

tic
for j=num_sum:-1:1
  sum_crec += 1/j^2;
end 
toc

sum_crec 

%con 8 dígitos
n=8;
sum_decr_fls=0;
sum_crec_fls=0;

tic
for j=1:num_sum 
  sum_decr_fls += fls(1/j^2);
end
toc
sum_decr_fls

tic
for j=num_sum:-1:1
  sum_crec_fls += fls(1/j^2);
end 
toc

sum_crec_fls