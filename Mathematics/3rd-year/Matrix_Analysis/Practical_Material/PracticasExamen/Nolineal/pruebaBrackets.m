% Ejemplo [Brakets]
clear all
clc    %cl_ear c_onsole
clf     %cl-ear f_igures

%f=@ (x)  x.^3+ 6* x.^2 -18*x -17;
f=@ (x) -17 .+x.*(-18 .+x.*(6 .+x));

xinf=-10;
xsup=5;
global precision;

precision=1.0e-8

display(' ');
display('Biseccion en [-10,6]');
[x1,fx1,npasos]=biseccion( f,-10,-6)

display(' ');
display('Regula Falsi en [-2,0]');
[x2,fx2,npasos]=regulaFalsi( f,-2,-0)


display(' ');
display('Regula Falsi Modificiado en [2,4]');
[x3,fx3,npasos]=regulaFalsiModificado( f,2,4)


display(' ');
display('Representacion Grafica de ceros y funcion');
figure (1,"name",'Ceros y funcion');
x=linspace(xinf,xsup,128);
plot([x1,x2,x3],[0,0,0],"*",[xinf,xsup],[0,0],x,f(x));
xlim ([xinf,xsup]);


