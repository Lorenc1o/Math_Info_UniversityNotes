%Ejercicio 3
clear
clc
clf
addpath('../Biblioteca')

x2=linspace(-5,5,3);
x5=linspace(-5,5,6);
x15=linspace(-5,5,16);
x20=linspace(-5,5,21);

y2=zeros(1,2);
y5=zeros(1,5);
y15=zeros(1,15);
y20=zeros(1,20);

f=@(x)1./(1+x.^2);

y2=f(x2);
y5=f(x5);
y15=f(x15);
y20=f(x20);

p2=coef_polinomio_interpolador(diferencias_divididas(x2,y2),x2);
p5=coef_polinomio_interpolador(diferencias_divididas(x5,y5),x5);
p15=coef_polinomio_interpolador(diferencias_divididas(x15,y15),x15);
p20=coef_polinomio_interpolador(diferencias_divididas(x20,y20),x20);

xx=linspace(-5,5);
z2=polyval(p2, xx);
z5=polyval(p5,xx);
z15=polyval(p15,xx);
z20=polyval(p20,xx);


figure(1);

plot(x20,y20,'o',xx,z2,'r',xx,z5,xx,z15,xx,z20);
legend('fx', 'p2', 'p5', 'p15', 'p20');

#b
xx2=linspace(-5,5);
zz2=polyval(p2,xx2);
fx=f(xx2);
error=abs(fx-zz2);
max2=max(error);

zz5=polyval(p5,xx2);
error=abs(fx-zz5);
max5=max(error);

zz15=polyval(p15,xx2);
error=abs(fx-zz15);
max15=max(error);

zz20=polyval(p20,xx2);
error=abs(fx-zz20)
max20=max(error);

n=[2,5,15,20];
er=[max2,max5,max15,max20];
printf('Los máximos son: \n');
printf('P2: %d, P5: %d, P15: %d, P20: %d',max2,max5,max15,max20);

figure(2);

plot(n,er,'o',n,er);

#c
posible=4.8;
fp=[polyval(p2,posible),polyval(p5,posible),polyval(p15,posible),polyval(p20,posible)];
fr=f(posible);
freal=[fr,fr,fr,fr];
figure(3);

plot(n, fp, 'o', n, freal); 
legend('Pn(4.8)', 'f(4.8)');

#d

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

xx=linspace(-5,5,200);
pi2=pi_n(xx, x2)
pi5=pi_n(xx,x5)
pi15=pi_n(xx,x15)
pi20=pi_n(xx,x20)

figure(4);

plot(xx,pi2,xx,pi5);
legend('pi2', 'pi5');
