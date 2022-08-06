% ejercicio 2 practica 7

clc

clear all

addpath('../Matrices')
global precision;
global desplazamiento;
%% apartado a


d=[2,3,1,5];
D= diag(d);
U=[ 1,-1, 0, 1;1, 1,-1, 0;0, 1, 1, 1;1, 0, 1,-1];
U= 1/sqrt(3)*U;
A= U'*D*U

precision=5e-5;
desplazamiento=0.01;

nmaxit=100;

[vp,V,nite,control_vect] = QRPropios (A,nmaxit)

[V,D]=eig(A)

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

[vp,V,nite,control_vect] = jacobiPropios (C,nmaxit);
nite
control_vect

vp=eig(C)


%% Apartado 2

%% matriz compañera de  (x-1)(x-2)(x-3)(x-4)(x-5)

ANS=[15, -85 , 225 , -274 , 120 ;
1 , 0, 0, 0, 0 ;
0   1  0  0  0;0   0  1  0  0;
0   0  0  1  0]


precision=5e-8;
desplazamiento=0.001;
nmaxit=100;

[vp,V,nite,control_vect] = QRPropios (ANS,nmaxit)

[V,D]=eig(ANS)



% matriz aleatoria
BNS=10*rand(5,5)-5*ones(5,5);
precision=5e-4;
nmaxit=300;
[vp,V,nite,control_vect] = QRPropios (BNS,nmaxit)

[V,D]=eig(BNS)





rmpath('../Matrices')