%GECP calculate Gauss elimination with complete pivoting
%
% (G)aussian (E)limination (C)omplete (P)ivoting
% Input : A nxn matrix
% Output
% L = Lower triangular matrix with ones as diagonals 
% U = Upper triangular matrix
% P and Q permutations matrices so that P*A*Q = L*U 
% 
% See also LU
%
% written by : Cheilakos Nick 
function [L,U,P,Q]=LUPQGauss(A)
    [n, n] = size(A);
    fila = 1:n; %puntero para filas
    columna = 1:n; %puntero para columnas
  for k = 1:n-1
      [maximos_en_columnas, filas_max_columnas] = max( abs(A(k:n, k:n)) );
                   % maximos_en_columnas=lista de los m�ximos en cada columna y 
                   % filas_max_columnas=lista de las filas en las que est�n esos m�ximos
      [maximo, col_max] = max(maximos_en_columnas);
                   % maximo=valor m�ximo (puntero) en A(k+1:n,k+1:n)
                   % col_max= posici�n del m�ximo en la lista maximos_en_columnas
      p = filas_max_columnas(col_max)+k-1;      % fila del m�ximo en A
      q = col_max+k-1;                          % columna del m�ximo en A
      A( [k, p], : ) = A( [p, k], : );
      A( :, [k, q] ) = A( :, [q, k] );
      fila( [k, p] ) = fila( [p, k] ); columna( [k, q] ) = columna( [q, k] );
        if abs(A(k,k))<100*eps
          error('Matriz singular');
        end
      l = k+1:n;  % multiplicadores en columna k  
      A(l,k) = A(l,k)/A(k,k);
      % Eliminaci�n en filas k+1 hasta n
      A(l,l) = A(l,l) - A(l,k) * A(k,l);
  end
    L = tril(A,-1) + eye(n);
    U = triu(A);
    P = eye(n);
    P = P(fila,:); %matriz permutacion filas
    Q = eye(n);
    Q = Q(:,columna); %matriz permutacion columnas

endfunction