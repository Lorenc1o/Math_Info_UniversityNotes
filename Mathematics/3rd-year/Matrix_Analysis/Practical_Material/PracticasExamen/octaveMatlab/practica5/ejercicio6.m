% ejercicio 6
clc
clear all
addpath('../Matrices')
display('ejercicio6')

x=linspace(-1,+1,17)

y=[0,-ones(1,7),0,ones(1,7),0]

n=6 ; % n=3
%% ecuaciones son 
%% a_0+ sum_(k=1:n) a_k cos(k*pi*x_i) + sum_(k=1:n) b_k sin(k*pi*x) =y_i

A=zeros(17,2*n+1)
for i=1:17
  A(i,1)=1;
  for j=1:n
    A(i,j+1)=cos(pi*j*x(i));
    A(i,n+j+1)=sin(pi*j*x(i));
  end
end

pt=fitMinimosCuadradosCholeski(A,y')'
plot([-1.5,1.5],[0,0],x,y,'b*')
ylim([-3,4])
hold on

function y=poliTrig(pt,n,x)
  y=pt(1);
  for j=1:n
    y=y+pt(j+1)* cos(pi*j*x);
    y=y+pt(n+j+1)* sin(pi*j*x);
  end 
end
tx=linspace(-1,+1,127);

plot(tx,poliTrig(pt,n,tx))

rmpath('../Matrices')