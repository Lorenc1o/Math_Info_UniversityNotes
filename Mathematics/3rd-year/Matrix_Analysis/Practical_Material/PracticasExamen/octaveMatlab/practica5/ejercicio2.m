%ejercicio 2
clear all
clc

addpath('../Matrices')

n=110% 10
m=200% 100
r=n
A=rand(r,r);
[Q,R]=GramSchmidt(A);
controlrmax=(r==size(Q)(2)) %para ver que Q tiene r columnas
if r<m
Q=[Q;rand(m-r,r)];
end
U=triu(rand(r,n));
B=Q*U;

%% B es matriz m x n de rango r
b=10*rand(m,1)-5*ones(m,1);

display(' Prueba del fitMinimosCuadradosQR Ax=b')
tic
x=fitMinimosCuadradosQR(B,b);
toc

distancia_min_QR= norm(B*x-b)
control_1_QR= norm(B'*B*x-B'*b)

display(' Prueba del fitMinimosCuadradosCholeski Ax=b')
tic
x=fitMinimosCuadradosCholeski(B,b);
toc

distancia_min_Choleski= norm(B*x-b)
control_1_Choleski= norm(B'*B*x-B'*b)

rmpath('../Matrices')



%%%
%%%  fitMinimosCuadradosQR(A,b)
%%Usa la factorizaci ́on QR deApara reducir la soluci ́on a la de un sistema con factorizaci ́on LU (A∗A=R∗R=R∗1R1)en 
%%la funci ́on
%%    fitMinimosCuadradosCholeski(A,b)