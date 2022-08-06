clc
clear all
clf
addpath('../Biblioteca');

%% resolver x+logx=0 con iteraciones de punto fijo

f=@(x) x+log(x);

aa=0.05;
bb=1;
tx=linspace(aa,bb,187);
figure(1);
plot([aa,bb],[0,0],tx,f(tx));
xlim([aa,bb]);

aa=0.4;
bb=0.8;


figure(2);
%% ecuacion punto fijo I1
f1=@(x) -log(x);

subplot(1,3,1)
plot([aa,bb],[aa,bb],[aa,bb],[bb,aa],tx,f1(tx))
xlim([aa,bb])
ylim([aa,bb])
legend('dy=1','dy=-1','y=f1')

%% ecuacion punto fijo I2
f2=@(x) exp(-x);

subplot(1,3,2)
plot([aa,bb],[aa,bb],[aa,bb],[bb,aa],tx,f2(tx))
xlim([aa,bb])
ylim([aa,bb])
legend('dy=1','dy=-1','y=f2')

%%la derivada en el punto fijo |f'(punto)|<1, se pueden usar iteraciones de punto fijo
errorParada=0.5e-8;
xiniPfijo=0.5;
maxIteraciones=100;

h=0.001;

x = puntofijo(f2,xiniPfijo,errorParada,maxIteraciones)

dfx=(f2(x+h)-f2(x-h))/(2*h)

x = puntofijoSteffensen(f2,xiniPfijo,errorParada,maxIteraciones)

%% ecuacion punto fijo I3
f3=@(x) (x+exp(-x))/2;

subplot(1,3,3)
plot([aa,bb],[aa,bb],[aa,bb],[bb,aa],tx,f3(tx))
xlim([aa,bb])
ylim([aa,bb])
legend('dy=1','dy=-1','y=f3')

x = puntofijo(f3,xiniPfijo,errorParada,maxIteraciones)

dfx=(f3(x+h)-f3(x-h))/(2*h)

x = puntofijoSteffensen(f3,xiniPfijo,errorParada,maxIteraciones)

