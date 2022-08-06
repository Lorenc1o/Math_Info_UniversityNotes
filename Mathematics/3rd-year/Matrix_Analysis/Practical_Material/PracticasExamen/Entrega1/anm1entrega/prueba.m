% prueba trid

clc

clear all

addpath('../Matrices')

n=6

dp=6*ones(1,n)
di=-ones(1,n-1)

T1=diag(dp)+diag(di,-1)+diag(di,+1)


[Q1,R1]=QRTrid(T1)

norm(T1-Q1*R1)

R1*Q1

rmpath('../Matrices')