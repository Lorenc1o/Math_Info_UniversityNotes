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
function [L,U,P,Q,r]=LUPQGeneral(B)
    A=B;
    [m, n] = size(A);
    fila = 1:m; %puntero para filas
    columna = 1:n; %puntero para columnas
    npasos = min(m,n) - (m<=n); %restamos 1 si m<=n
    r=0;
  for k = 1:npasos
      [maximos_en_columnas, filas_max_columnas] = max( abs(A(k:m, k:n)) );
                   % maximos_en_columnas=lista de los mï¿½ximos en cada columna y 
                   % filas_max_columnas=lista de las filas en las que estï¿½n esos mï¿½ximos
      [maximo, col_max] = max(maximos_en_columnas);
                   % maximo=valor mï¿½ximo (puntero) en A(k+1:n,k+1:n)
                   % col_max= posiciï¿½n del mï¿½ximo en la lista maximos_en_columnas
      p = filas_max_columnas(col_max)+k-1;      % fila del mï¿½ximo en A
      q = col_max+k-1;                          % columna del mï¿½ximo en A
      A( [k, p], : ) = A( [p, k], : );
      A( :, [k, q] ) = A( :, [q, k] );
      fila( [k, p] ) = fila( [p, k] ); columna( [k, q] ) = columna( [q, k] );
        if abs(A(k,k))<100*eps
          break;
        end
      r=r+1;
      l = k+1:m;  % multiplicadores en columna k  
      A(l,k) = A(l,k)/A(k,k);
      % Eliminaciï¿½n en filas k+1 hasta n
      c = k+1:n;
      A(l,c) = A(l,c) - A(l,k) * A(k,c);
  end
    if m<=n
      if abs(A(m,m))>=100*eps
        r=r+1;
      endif
    endif
    L = zeros(m,m);
    L(1:m,1:n) = tril(A,-1);
    %% ultima correccion despues de la sesion de practicas
    %% si n>m en la linea anterior L se redimensiona y se vuelve m x n
    %% antes de añadir unos en la diagonal la volvemos a redimensionar 
    %% eliminando las n-m ultimas columnas (de ceros)
    if n>m
      L(:,m+1:n)=[];
    end
    %%%%% fin de la correccion
    L = L +eye(m);
    U = triu(A);
    P = eye(m);
    P = P(fila,:); %matriz permutacion filas
    Q = eye(n);
    Q = Q(:,columna); %matriz permutacion columnas

endfunction