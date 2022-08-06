clear 
clc 
addpath("../Matrices")

n=6
m=4
r=3
A=rand(r,r);
[Q,R]=GramSchmidt(A);
controlrmax=(r==size(Q)(2)) %para ver que Q tiene r columnas

if r<m
  Q=[Q;rand(m-r,r)];
end

U=triu(rand(r,n));
B=Q*U %Esta es la matriz que creamos

nuc = nucleo(B)

control = norm(B*nuc)

%Vemos como la norma sale muy pequeña, del orden de 10e-16
%por tanto, sabemos que el método funciona.

rmpath("../Matrices")
