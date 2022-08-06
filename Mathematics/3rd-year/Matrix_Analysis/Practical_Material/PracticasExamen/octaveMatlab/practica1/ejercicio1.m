clc
%clf
disp("Ejercicio 1.1");
%1.
n=8;
a=eye(n); %identidad de dimension n
for i=1:n
  u=a(:,i);
endfor
%2.
k=rand(n,1);  %vector columna aleatorio con componentes en (0,1)
v=rand(n,1);
w=v-(dot(v,k)/norm(k)^2)*k % el vector proyeccion de v en la dirección de k
comprobando_b=dot(w,k)  %comprobación de que el producto <w,k>=0
%3.
%% Igual que el apartado 2 pero con vectores fila
k1=rand(1,n);  % vector fila aleatorio con componentes en (0,1)
v1=rand(1,n);
w1=v1-(dot(v1,k1)/norm(k1)^2)*k1
comprobando_c=dot(w1,k1)
%4.
A=rand(n)  %matriz cuadrada n x n con elementos en (0.1)
B=0.5*(A+A');  %A' es la matriz transpuesta/adjunta
C=0.5*(A-A');
x=rand(n,1)
producto_A=dot(A*x,x)
producto_B=dot(B*x,x)
producto_C=dot(C*x,x)
  %% Para matrices reales el producto_A=producto_B independientemente de la matriz y 
  %% el vector, observa que A=B+C y  que <Cx,x>=0.5(<Ax,x>-<x,Ax>)=0 para cualquier x.
