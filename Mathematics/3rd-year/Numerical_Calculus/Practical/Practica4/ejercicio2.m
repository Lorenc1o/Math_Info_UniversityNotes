%ejercicio 2

clc 
clear all
clf 

%datos 

f=@(x) 1./(1+x.^2);

n=[2,5,15,20];
nuPuntosGrafica=181;
tx=linspace(-5,5,nuPuntosGrafica);

%a
figure(1)

xx_1=linspace(-5,5,2);
a_1=f(xx_1);
[b1,c1,d1]=splineNatural(xx_1,a_1);

err1=abs(f(tx)-splineEval(xx_1,a_1,b1,c1,d1,tx));

plot(xx_1,a_1,'*',tx,f(tx),tx,splineEval(xx_1,a_1,b1,c1,d1,tx))

ylim([-0.5,1.5])
hold on 

xx_2=linspace(-5,5,5);
a_2=f(xx_2);
[b2,c2,d2]=splineNatural(xx_2,a_2);

err2=abs(f(tx)-splineEval(xx_2,a_2,b2,c2,d2,tx));

plot(xx_2,a_2,'*',tx,splineEval(xx_2,a_2,b2,c2,d2,tx))

hold on

xx_3=linspace(-5,5,15);
a_3=f(xx_3);
[b3,c3,d3]=splineNatural(xx_3,a_3);

err3=abs(f(tx)-splineEval(xx_3,a_3,b3,c3,d3,tx));

plot(xx_3,a_3,'*',tx,splineEval(xx_3,a_3,b3,c3,d3,tx))

hold on

xx_4=linspace(-5,5,20);
a_4=f(xx_4);
[b4,c4,d4]=splineNatural(xx_4,a_4);

err4=abs(f(tx)-splineEval(xx_4,a_4,b4,c4,d4,tx));

plot(xx_4,a_4,'*',tx,splineEval(xx_4,a_4,b4,c4,d4,tx))

hold on

legend('x_1','f','s_1','x_2','s_2','x_3','s_3','x_4','s_4')
title('Splines Naturales')

%b

figure(2)

tan_ini=0;
tan_fin=0;

xx_1=linspace(-5,5,2);
a_1=f(xx_1);

[b1,c1,d1]=splineSujeto(xx_1,a_1,tan_ini,tan_fin);

err11=abs(f(tx)-splineEval(xx_1,a_1,b1,c1,d1,tx));

plot(xx_1,a_1,'*',tx,f(tx),tx,splineEval(xx_1,a_1,b1,c1,d1,tx))

ylim([-0.5,1.5])
hold on 

xx_2=linspace(-5,5,5);
a_2=f(xx_2);
[b2,c2,d2]=splineSujeto(xx_2,a_2,tan_ini,tan_fin);

err22=abs(f(tx)-splineEval(xx_2,a_2,b2,c2,d2,tx));

plot(xx_2,a_2,'*',tx,splineEval(xx_2,a_2,b2,c2,d2,tx))

hold on

xx_3=linspace(-5,5,15);
a_3=f(xx_3);
[b3,c3,d3]=splineSujeto(xx_3,a_3,tan_ini,tan_fin);

err33=abs(f(tx)-splineEval(xx_3,a_3,b3,c3,d3,tx));

plot(xx_3,a_3,'*',tx,splineEval(xx_3,a_3,b3,c3,d3,tx))

hold on

xx_4=linspace(-5,5,20);
a_4=f(xx_4);
[b4,c4,d4]=splineSujeto(xx_4,a_4,tan_ini,tan_fin);

err44=abs(f(tx)-splineEval(xx_4,a_4,b4,c4,d4,tx));

plot(xx_4,a_4,'*',tx,splineEval(xx_4,a_4,b4,c4,d4,tx))

hold on

legend('x_1','f','s_1','x_2','s_2','x_3','s_3','x_4','s_4')
title('Splines Sujetos')

%c
figure(3)


plot(xx_1,zeros(1,n(1)),'*',tx,err1);
ylim([-0.05,0.05])
hold on
plot(xx_2,zeros(1,n(2)),'*',tx,err2);
hold on
plot(xx_3,zeros(1,n(3)),'*',tx,err3);
hold on
plot(xx_4,zeros(1,n(4)),'*',tx,err4);
hold on

figure(4)


plot(xx_1,zeros(1,n(1)),'*',tx,err11);
ylim([-0.05,0.05])
hold on
plot(xx_2,zeros(1,n(2)),'*',tx,err22);
hold on
plot(xx_3,zeros(1,n(3)),'*',tx,err33);
hold on
plot(xx_4,zeros(1,n(4)),'*',tx,err44);
hold on