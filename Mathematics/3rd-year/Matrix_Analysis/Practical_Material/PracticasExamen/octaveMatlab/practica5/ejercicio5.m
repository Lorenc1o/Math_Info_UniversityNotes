% ejercicio 5
clear all
clc

display('ejercicio 1')
addpath('../Matrices')


C=[1 , 2 , 5 ;
   2 , 1 , 3 ;
   5 , 3 , 0]


[QC,TC]=tridQHouseholder(C)  

control_C=norm(QC'*C*QC-TC)
   
%% matriz B
B=[ 18.0 , 6.0 , -3.0 , 4.0 , 5.0 ;
6.0 , 25.0 , -3.0 , -5.0 , -2.0 ;
-3.0 , -3.0 , 11.0 , -2.0 , 3.0 ;
4.0 , -5.0 , -2.0 , 11.0 , 5.0 ;
5.0 , -2.0 , 3.0 , 5.0 , 22.0 ]


[QB,TB]=tridQHouseholder(B)  

control_B=norm(QB'*B*QB-TB)


n=25

A=symmetricMat(n);
[QA,TA]=tridQHouseholder(A)  ;

control_A=norm(QA'*A*QA-TA)






rmpath('../Matrices')