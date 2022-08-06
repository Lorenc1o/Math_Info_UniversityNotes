clc 
clf 
clear all 
addpath('../Biblioteca');

f=@(x) log(x.^2+1)-exp(0.4*x).*cos(pi*x);
errorParada = 0.5e-6;
maxIteraciones = 100;
h=0.001;

df=@(x) (f(x+h)-f(x-h))/(2*h);

aa=-10;
bb=10;

tx=linspace(aa,bb,187);

plot([aa,bb],[0,0],tx,f(tx));
hold on;

%aproximaciones para ceros
px=-0.5:1:bb;
npx=length(px);
cerosy=zeros(1,npx);
plot(px,cerosy,'*');

%apartado c los nodos px son buenas aproximaciones iniciales para newton

%apartado a, cero negativo

x0_a =-0.5;

x_neg = newton(f,df,x0_a,errorParada,maxIteraciones)

%apartado b y c, ceros positivos
bb=25;
px=0.5:1:bb;
npx=length(px);
cerosy=zeros(1,npx);
x0_pos=zeros(1,npx);

for i=1:npx
  x0_pos(i)=newton(f,df,px(i),errorParada,maxIteraciones);
endfor

x0_pos