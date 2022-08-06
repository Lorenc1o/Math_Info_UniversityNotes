% ejercicio 3

clc
clear all

addpath('../Matrices')

A=[3 ,-1 ,2 ,-1 ,1 ,0 ;
  -1 ,4 ,-1 ,2 ,-1 ,1 ;
  2 ,-1 ,5 ,-1 ,2 ,-1 ;
  -1 ,2 ,  -1 ,6 ,-1 ,2 ;
  1 ,-1 ,2 ,-1 ,7 ,-1 ;
  0 ,1 ,-1 ,2 ,-1 ,8]
  
  
global precision;
precision=5E-14;
nmaxit=300;
% buscamos valores y vectores propios
[vp,V,iter,control]= jacobiPropios (A,nmaxit)

control_diagonalizacion=norm(V'*A*V-diag(vp))

% buscamos B tal que B*B=A  --->  A= V * D * V'
%  B ---> V * sqrt(D) * V'  --->  B * B = V *sqrt(D) * sqrt(D) * V' = A

B= V * sqrt(diag(vp)) * V'

control_raizcuadrada=norm(A-B*B)






rmpath('../Matrices')