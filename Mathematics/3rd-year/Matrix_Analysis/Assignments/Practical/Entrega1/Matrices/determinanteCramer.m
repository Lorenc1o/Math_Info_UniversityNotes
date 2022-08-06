%% Funcion recursiva para calcular el determinante de la matriz A
%% desarrollandolo con los elementos de la primera fila y los menores asociados. 
%% devuelve
%% determinate de A  o  lanza un error si la matriz no es cuadrada


function det=determinanteCramer(A)
  [m,n]=size(A);  % m es el numero de filas y n el numero de columnas
  if (m~=n)
    error('Matriz A no cuadrada');
  end
  if (m==1)
    det=A(1,1);
  else 
    det=0;
    B=A;
    signo = 1;
    B(1,:)=[]; % eliminamos la primera fila de B igualandola a una fila vacia
    for j=1:m
     C=B;
     C(:,j)=[]; % eliminamos la columna j de C igualandola a una columna vacia
                % C es el menor que resulta al eleminar en A 
                % la fila 1 y la columna j
     det=det + A(1,j)* signo * determinanteCramer(C);
     signo = -signo;
    end
  end
end
