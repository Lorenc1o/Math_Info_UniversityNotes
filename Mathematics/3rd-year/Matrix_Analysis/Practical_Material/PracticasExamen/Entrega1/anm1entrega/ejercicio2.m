clear 
clc 
addpath("../Matrices")

%apartado 1

d=[2,3,1,5];
%d=[2,3,2.5,2.5];
D=diag(d);

U=[1,-1,0,1;
  1,1,-1,0;
  0,1,1,1;
  1,0,1,-1];
U=1/sqrt(3)*U;
A=U'*D*U

%apartado 2

x0=[1,0,0,0]'; %por ejemplo
maxiter=1000;
prec=10e-16;

[valorMax,vectorMax]=potencia(A,x0,maxiter,prec)

vaprox=0; %para que no haga desplazamiento, así obtenemos el menor 
                  %de los valores propios

[valorMin,vectorMin]=potenciaInvDesplazada(A,vaprox,x0,maxiter,prec)

%d es el vector de valores propios, si lo cambiamos podemos cambiar lo que nos
%devuelven los métodos de la potencia y la potencia inversa
%por ejemplo, si hacemos d=[2,3,2.5,2.5], ahora nos darán, respectivamente, 
%los valores 3 y 2

%apartado 3

% l4=-l1<l3=-l2<0<l2<l1
% -l1<l3=-l2<0 implica l1>-l3>l2>0
% como l4=-l1, entonces l1=-l4, y tenemos que el mayor de los valores propios 
% es l1=-l4 
% el menor en valor absoluto es l2=-l3 
% por tanto, podemos obtener l1 y l4 con el método de la potencia, obtendremos
% también v1 y v4
% l2,l3 y v2,v3 con el método de la potencia inversa

A=[-2,0,1,1;
  -5,-5,4,5;
  16,14,-8,-12;
  -19,-15,11,15];

x0=[1,0,0,0]'; %por ejemplo
maxiter=10000;
prec=10e-16;

%[l1,v1]=potencia(A,x0,maxiter,prec)
%Resulta que el método de la potencia no converge, ni siquiera para mayor 
%cantidad de iteraciones ni rebajando la precisión, vamos a calcular primero
%l2 y l3

x0=[1,0,0,0]';
maxiter=1000;
prec=10e-16;
vaprox=1; %con vaprox=1 no converge, pero así sí, el problema es que no podemos 
          %estar completamente seguros de que nos dé el menor valor propio

[l2,v2]=potenciaInvDesplazada(A, vaprox, x0, maxiter, prec)

%como los valores propios son opuestos dos a dos, si encontramos otro valor 
%propio podremos asegurar cuáles son los menores en valor absoluto 
%Voy a probar con vaprox=2
vaprox=2;

[l1,v1]=potenciaInvDesplazada(A, vaprox, x0, maxiter, prec) 

%Efectivamente, obtenemos otro valor, además, l1>l2 
%Para sacar los otros dos hacemos lo siguiente:

l3=-l2
l4=-l1

% A*v3=l3*v3 sii (A-l3*Id)*v3=0
% igual con v4 
B=[1,1,1,1];
B=l3*diag(B);
C=A-B;

V3 = nucleo(C);
v3 = V3(:,1)

controlv3 = norm(C*v3) %para ver que vamos bien: OK

%ya tenemos v3, el único vector no nulo de nucleo(C)
%repetimos para hallar v4

B=[1,1,1,1];
B=l4*diag(B);
C=A-B;

V4 = nucleo(C);
v4 = V4(:,1)

controlv4 = norm(C*v4) %para ver que vamos bien: OK

%La base de R4 buscada es {v1,v2,v3,v4}, para comprobarlo:

B=zeros(4);
B(1:4,1)=v1;
B(1:4,2)=v2;
B(1:4,3)=v3;
B(1:4,4)=v4;
controlfinal=norm(nucleo(B)) %Si es 0, la imagen es todo el espacio: OK

rmpath("../Matrices")