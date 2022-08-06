% ejercicio4 fenomeno Runge

clear all
clc
%clf

addpath('../Matrices')


f=@ (x) 1./(1+25.*x.^2);

x=linspace(-1,+1,22);
y=f(x);

n=[1,5,7,9,21]

figure(1)

plot([-1.5,1.5],[0,0],x,y,'b*')
ylim([-3,4])
hold on


tx=linspace(-1,+1,127);
for i=1:length(n)
  pi=polinomioFit2(x,y,n(i));
  plot(tx,polyval(pi,tx))
  
end 
legend('OX','puntos','p_1','p5','p7','p9','p21')
hold off











rmpath('../Matrices')