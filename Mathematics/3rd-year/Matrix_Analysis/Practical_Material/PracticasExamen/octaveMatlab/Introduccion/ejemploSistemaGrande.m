clear
clc

addpath('../Matrices')

n=100; %% prueba con n=1000, 1000000, ...

D=2;
fprintf('\n Tiempo de construccion termino independiente \n \n');
tic
b=zeros(n,1);
for i=1:n
  b(i)=3*sin((i-1)*2*pi/(n-1));
endfor
toc


fprintf('\n Tiempo de solucion solve3dconstsyme \n \n');
tic
x=solve3dconstsyme(D,b);
toc


norm_res=residuo3dconstsyme(D,x,b);
printf('norma residual || b-Ax|| = %d \n', norm_res );

printf(' \n\n');

%% printf('Tiempo de construccion de matriz de coeficientes \n');
%% tic
%% A=zeros(n,n);
%% A(1,2)=-1;
%% A(1,1)=D;
%% for i=2:n-1 
%%   A(i,i)=D;
%%   A(i,i+1)=-1;
%%   A(i,i-1)=-1;
%% endfor
%% A(n,n)=D;
%% A(n,n-1)=-1;
%% toc

%% %% Otra forma de construccion
%% printf('Tiempo de construccion de matriz de coeficientes \n');
%% tic
%%  A=diag(2*ones(n,1))-diag(ones(n-1,1),1)-diag(ones(n-1,1),-1);
%% toc  
%% 
%% 
%% 
%% printf(' \n\n');
%% printf('\n Tiempo de solucion Octave/Matlab \n \n');
%% tic;
%% xC= A\b;
%% toc;
%% 
%% 
%% residual=b- A*xC;
%% 
%% printf('norma residual || b-A xC|| = %d \n\n',norm(residual));
%% printf('||x-xC||= %d \n', norm(x-xC));