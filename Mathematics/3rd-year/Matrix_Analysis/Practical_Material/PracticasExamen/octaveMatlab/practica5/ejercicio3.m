% ejercicio3

clear all
clc  %limpia la consola    c - consola
clf  %limpia los graficos  f - figure


% tenemos que hacer   polinomioFit2( x , y, n)

addpath('../Matrices')


x=1:9
y=[2.1,3.3,3.9,4.4,4.6,4.8,4.6,4.2,3.4]
n=3
%% en octave/matlab   polyfit

p_oct=polyfit(x,y,n)


%% A c = y   donde c son los coefici...

p=polinomioFit2(x,y,n)

figure(1)

plot([-1,11],[0,0],x,y,'b*')
ylim([-1,10])
hold on

g=[2,3,4,8]
tx=linspace(-1,10,127);

for i=1:4
  pi=polinomioFit2(x,y,g(i));
  plot(tx,polyval(pi,tx))
  
end
legend('OX','puntos','p_2','p3','p4','p8')
hold off





