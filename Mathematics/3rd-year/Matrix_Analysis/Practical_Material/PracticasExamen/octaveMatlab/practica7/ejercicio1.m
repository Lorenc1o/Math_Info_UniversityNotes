% ejercicio 1 practica 7

clc

clear all

addpath('../Matrices')
global precision;
%% apartado a


d=[2,3,1,5];
D= diag(d);
U=[ 1,-1, 0, 1;1, 1,-1, 0;0, 1, 1, 1;1, 0, 1,-1];
U= 1/sqrt(3)*U;
A= U'*D*U

precision=5e-5;
nmaxit=100;

[vp,V,nite,control_vect] = jacobiPropios (A,nmaxit)

vpo =eig(A)

%% apartado b
display(' ')
display('Apartado b')
display(' ')
n=10
precision=5e-3;
nmaxit=2000;
B=symmetricMat(n);
[vp,V,nite,control_vect] = jacobiPropios (B,nmaxit);
nite
control_vect

%% apartado c
display(' ')
display('Apartado c')
display(' ')

n=10;
dp=6*ones(1,n);
di=-2*ones(1,n-1);
C=diag(dp)+diag(di,-1)+diag(di,1);

%%[vp,V,nite,control_vect] = jacobiPropios (C,nmaxit);
%%nite
%%control_vect

vp=eig(C)


rmpath('../Matrices')