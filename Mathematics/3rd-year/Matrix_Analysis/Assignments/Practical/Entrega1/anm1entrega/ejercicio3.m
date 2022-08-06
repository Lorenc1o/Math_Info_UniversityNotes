clc
clear 
addpath("../Matrices")

A=[3,1,0;1,3,1;0,1,3] %uso esta matriz para probar ya que es la del 
                      %ejemplo del pdf y todo OK
[Q,R]=QRTrid(A)
R*Q

A=RandTriDiagSim(6, 3) %matriz tridiagonal simétrica n=3

[Q,R]=QRTrid(A)
R*Q

A=RandTriDiagSim(6, 5) %matriz tridiagonal simétrica n=6

[Q,R]=QRTrid(A)
R*Q

A=RandTriDiagSim(8, 5) %matriz tridiagonal simétrica n=8

[Q,R]=QRTrid(A)
R*Q

%las matrices que nos salen tienen la forma correcta y el programa parecer 
%funcionar correctamente