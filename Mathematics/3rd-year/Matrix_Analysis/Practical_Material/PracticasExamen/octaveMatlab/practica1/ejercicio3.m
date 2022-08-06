clc
clear all
%clf
disp("Ejercicio 1.3");
%1.
A=[10,7,8,7;7,5,6,5;8,6,10,9;7,5,9,10];
disp("\nApartado a");
%a.
[Q,R]=GramSchmidt0(A);
             % en la siguiente linea ->  size(Q)=[m,n]; n=size(Q)(2)=numero de columnas de Q
control_a=norm(Q'*Q-eye(size(Q)(2)))     % para ver si Q es ortogonal
control2_a=norm(Q*R-A)            % para ver si se tiene la factorizacion A=Q*R
%b.
disp("\nApartado b: Matices de Hilbert");
k=6
B=hilb(k);
[Q,R]=GramSchmidt0(B)
control_b=norm(Q'*Q-eye(size(Q)(2)))
control2_b=norm(Q*R-B)
%c.
disp("\nApartado c: Matices rectangulares aleatorias");
num_filas=floor(10*rand(1))+1        % numero natural entre 1 y 10
num_columnas=floor(10*rand(1))+1
C=rand(num_filas,num_columnas);      % matriz rectangular con elementos en (0,1)
[Q,R]=GramSchmidt0(C);
control_c=norm(Q'*Q-eye(size(Q)(2)))
control2_c=norm(Q*R-C)
dimension_Q=size(Q)
%d.
D=[1,3,-5,2,8,2; 5,-2,-1,8,1,-3; 4,3,-16,23,19,-4; 9,2,-1,-1,7,4];
[Q,R]=GramSchmidt0(D);

##control=norm(Q'*Q-eye(size(Q)(2)))
control2=norm(Q*R-D)

disp("\nApartado 2");
A=[A,1000*eps*rand(4,1)];
[Q,R]=GramSchmidt0(A);
control_d=norm(Q'*Q-eye(4))
control2_d=norm(Q*R-A)

%disp("Apartado 3");
control_3A=norm(A'*A-R'*R)

