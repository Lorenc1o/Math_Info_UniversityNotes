clc
clear 
addpath("Matrices")


%1
T1=[4,1,0,0;
  1,-3,-1,0;
  0,-1,5,2;
  0,0,2,2]
tol=10e-8;
nit=100;
[v1,V1]=vQRTRid(T1,tol,nit)

[v,V]=eig(T1) %para comprobar que nos da los valores y vectores correctos


T2=[6,-1,0,0,0,0;
  -1,4,0,0,0,0;
  0,0,5,2,0,0;
  0,0,2,1,-1,0;
  0,0,0,-1,3,2;
  0,0,0,0,2,3]
[v2,V2]=vQRTRid(T2,tol,nit)

[v,V]=eig(T2)

%2
n=4;
A=symmetricMat(n)
[vp,V]=QRvp(A)
[V,D]=eig(A) %para comprobar que está bien