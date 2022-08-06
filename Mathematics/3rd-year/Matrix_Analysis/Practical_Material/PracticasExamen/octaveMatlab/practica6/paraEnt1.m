clear all
clc

addpath('../Matrices')

n=110% 10
m=200% 100
r=n
C=rand(r,r);
[Q,R]=GramSchmidt(C);
controlrmax=(r==size(Q)(2)) %para ver que Q tiene r columnas
if r<m
Q=[Q;rand(m-r,r)];
end
U=triu(rand(r,n));
A=Q*U;

%% B es matriz m x n de rango r
b=10*rand(m,1)-5*ones(m,1);
%%
%%tic
%%[Qqr,Rqr]=GramSchmidt(A);
%%te=toc;
%%
%%tic
%%[Qh,Rh]=QRhouseholder(A);
%%toc;


function X = solveQRhouseholder(A, b)
  [Q,R]=QRhouseholder(A);
  X = solveU(R, Q'*b);
endfunction

t_lu=0; t_qr=0;
res_lu=0; res_qr=0;
n=200
for i=1:100
  A=10*rand(n,n)-5*ones(n,n);
  b=10*rand(n,1)-5*ones(n,1);
  tic
    r1=norm(A*solveGaussParcial(A,b)-b);
  t1=toc;
  t_lu=t_lu+t1;
  res_lu=res_lu+r1;
  tic
    r2=norm(A*solveQRhouseholder(A,b)-b);
  t2=toc;
  t_qr=t_qr+t2;
  res_qr=res_qr+r2;
end 
 
control_gauss_time=t_lu/100 
control_qr_time=t_qr/100
control_gauss_res=res_lu/100
control_qr_res=res_qr/100
