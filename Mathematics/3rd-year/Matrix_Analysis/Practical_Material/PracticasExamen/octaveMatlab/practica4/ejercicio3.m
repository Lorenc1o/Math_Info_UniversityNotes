clear all
clc
addpath('../Matrices')

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
B=Q*U
[L,U,P,Q,r]=LUPQGeneral(B)
control_factorizacion=norm(P*B*Q-L*U)




rmpath('../Matrices')