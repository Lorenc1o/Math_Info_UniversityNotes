%Ejercicio 4
clear
clc 
clf 
addpath('../Biblioteca');

%a)
x2=zeros(1,3);
x5=zeros(1,6);
x15=zeros(1,16);
x20=zeros(1,21);

C=@(k,n) 5*cos(((2*k+1)*pi)/(2*(n+1)));
f=@(x)1./(1+x.^2);

for i=[0:2]
  x2(i+1)=C(i,2);
end
x2

for i=[0:5]
  x5(i+1)=C(i,5);
end
x5 

for i=[0:15]
  x15(i+1)=C(i,15);
end
x15

for i=[0:20]
  x20(i+1)=C(i,20);
end
x20


y2=f(x2);
y5=f(x5);
y15=f(x15);
y20=f(x20);

p2=coef_polinomio_interpolador(diferencias_divididas(x2,y2),x2);
p5=coef_polinomio_interpolador(diferencias_divididas(x5,y5),x5);
p15=coef_polinomio_interpolador(diferencias_divididas(x15,y15),x15);
p20=coef_polinomio_interpolador(diferencias_divididas(x20,y20),x20);

xx=linspace(-5,5);
zf=f(xx);
z2=polyval(p2, xx);
z5=polyval(p5,xx);
z15=polyval(p15,xx);
z20=polyval(p20,xx);

set(gca, 'YScale', 'linear');
figure(1);

plot(xx,zf,'o',xx,z2,'r',xx,z5,xx,z15,xx,z20);
legend('fx', 'p2', 'p5', 'p15', 'p20');

%b
function ret = pi_n (x,y)
  ret=ones(1,length(x));
  cont=1;
  for i=x
    for j=y
      ret(cont)=ret(cont)*(i-j);
    end 
    cont=cont+1;
  end
end 

xx=linspace(-5,5);
pi2Cheb=pi_n(xx, x2)
pi5Cheb=pi_n(xx,x5)
pi15Cheb=pi_n(xx,x15)
pi20Cheb=pi_n(xx,x20)

x2=linspace(-5,5,3);
x5=linspace(-5,5,6);
x15=linspace(-5,5,16);
x20=linspace(-5,5,21);

pi2Eq=pi_n(xx, x2)
pi5Eq=pi_n(xx,x5)
pi15Eq=pi_n(xx,x15)
pi20Eq=pi_n(xx,x20)

figure(2);

plot(xx,pi2Cheb,xx,pi2Eq);
legend('pi2 Chebychev', 'pi2 equiespaciado');

figure(3);

plot(xx,pi5Cheb,xx,pi5Eq);
legend('pi5 Chebychev','pi5 equiespaciado');

figure(4);

plot(xx,pi15Cheb,xx,pi15Eq);
legend('pi15 Chebychev','pi15 equiespaciado');

figure(5);

plot(xx,pi20Cheb,xx,pi20Eq);
legend('pi20 Chebychev', 'pi20 equiespaciado');

plot(xx,pi20Cheb);
legend('pi20 Chebychev');