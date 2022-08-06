clc
%clf
disp("Ejercicio 1.2");
%1.
disp("\nApartado 1")
A=[10,7,8,7;7,5,6,5;8,6,10,9;7,5,9,10]
[V,D]=eig(A)
%% En clase abrimos la página web https://es.mathworks.com/help/matlab/ref/eig.html
%% que se obtiene al preguntar a google por:  eig matlab
%% En la pagina esta la descripción de la funcion con ejemplos de uso
control_A=norm(A*V-V*D)          % para ver si A*V=V*D
control2_A=norm(V'*A*V-D)       % para ver si V'*A*V=D
control3_A=norm(V'*V-eye(4))   % para ver si V es ortogonal/unitaria
%2.
disp("\nApartado 2")
B=A;
B(3,2)=1000         % modificamos el termino de A que esta en la fila 3, columna 2 para que ya no sea
                              % simetica y probamos como actua eig
[V,D]=eig(B)
control_B=norm(B*V-V*D)         % sigue teniendose que A*V=V*D  (los vectores columna de V son vectores propios
control2_B=norm(V'*B*V-D)       % con el valor que hemos puesto en B(3,2) no se cumple
control3_B=norm(V'*V-eye(4))
%2'.
        % repetimos observando el comportamiento con una matriz con valores propios complejos
disp("\nApartado 2'")
C=[0,1;-1,0]
[V,D]=eig(C)
control_C=norm(C*V-V*D)        
control2_C=norm(V'*C*V-D)
control3_C=norm(V'*V-eye(2))       % esta matriz es normal = diagonalizable con base ortogonal de vectores propios

%3.
disp("\nApartado 3")
[U,S,V]=svd(B);
%% En clase abrimos la página web https://es.mathworks.com/help/matlab/ref/double.svd.html
%% que se obtiene al preguntar a google por:  svd matlab
%% En la pagina esta la descripción de la funcion con ejemplos de uso
control_S=norm(B*V-U*S)      % para ver si B*V=U*S
control2_D=norm(U'*B*V-S)   % para ver si U'*B*V=S
control3_D=norm(V'*V-eye(4))  % para ver si V es ortogonal/unitaria
control4_D=norm(U'*U-eye(4))  % para ver si U es ortogonal/unitaria

%%% Comprobad el funcionamiento de svd con matrices rectangulares....
 