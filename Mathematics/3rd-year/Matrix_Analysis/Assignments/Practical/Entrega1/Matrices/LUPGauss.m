%%  Funcion [L,U,P]=PLUfGauss(A) 
%%  que devuelve 
%%  L : matriz triangular inferior
%%  U : matriz triangular superior
%%  P : matriz permutacion de filas
%%  de manera que  "PA=LU" y "A=P'LU"

function [L,U,P]=LUPGauss(A)
  [m,n]=size(A);
  
  if m ~= n
    error('dimensiones incompatibles');
  end
 
  fila=[1:n]; % vector para apuntar a las filas permutadas
  
  for k=1:n-1
    % 1 eleccion pivote
    %  max aplicado a la columna k entre las filas k y n, devuelve
    %  el valor maximo y la fila de la matriz en la que está
    [maxColumn,c]=max(abs(A(k:n,k)));
    p=k+c-1; % c esta entre 1 y n-k+1, con p apuntamos entre k y n.
    % 2 intercambio de filas en A
    A([k,p],:)=A([p,k],:);
    % intercambio de filas en vector puntero
    fila([k,p])=fila([p,k]);
    % 3 eliminacion
    if abs(A(k,k))<100*eps
          warning('Matriz singular');
        end
    % calculo simultaneo de todos los multiplicadores 
    % se guardan en la misma matriz bajo la diagonal
%    i=k+1:n; %filas
    A(k+1:n,k) =A(k+1:n,k)/A(k,k);
    % eliminación simultanea en todas las filas entre las columnas k+1 y n
%    j=k+1:n; %columnas
    A(k+1:n,k+1:n) = A(k+1:n,k+1:n)-A(k+1:n,k)*A(k,k+1:n);
  end
  L=tril(A,-1)+eye(n); %se extrae la matriz triangular bajo la diagonal y
                       % se le suma la matriz identidad (1 en diagonal)
  U=triu(A); % se extrae la matriz triangular superior.
  P = eye(n); % matriz identidad
  P = P(fila,:); % se reordenan las columnas de P para tener la 
                 % matriz permutacion filas 

end 