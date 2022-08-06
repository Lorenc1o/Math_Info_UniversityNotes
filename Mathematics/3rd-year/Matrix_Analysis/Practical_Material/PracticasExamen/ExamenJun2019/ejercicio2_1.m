addpath("../Matrices")
N=31;

x=zeros(1,N+1);
y=zeros(1,N+1);

for i=1:(N+1)
  x(i)=-1+2*(i-1)/(N);
  y(i)=cosh(x(i));
endfor 

n=2
p=polinomioFit2(x,y,n)

figure 1


plot(x,y,'o')
hold on
z=linspace(-1,1);
plot(z,polyval(p,z))

n=4
p=polinomioFit2(x,y,n)
plot(z,polyval(p,z))

n=8
p=polinomioFit2(x,y,n)
plot(z,polyval(p,z))

n=10
p=polinomioFit2(x,y,n)
plot(z,polyval(p,z))

legend("f(x)","p2", "p4", "p8", "p10")

hold off


#como podemos ver los polinomios aproximan bastante bien, y son muy parecidos
# (en este intervalo)

for i=1:(N+1)
  y(i)=1/cosh(x(i));
endfor 

n=2
p=polinomioFit2(x,y,n)

figure 2

plot(x,y,'o')
hold on
z=linspace(-1,1);
plot(z,polyval(p,z))

n=4
p=polinomioFit2(x,y,n)
plot(z,polyval(p,z))


n=8
p=polinomioFit2(x,y,n)
plot(z,polyval(p,z))


n=10
p=polinomioFit2(x,y,n)
plot(z,polyval(p,z))

legend("f(x)","p2", "p4", "p8", "p10")

hold off


