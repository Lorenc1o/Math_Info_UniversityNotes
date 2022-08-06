%% Funcion para resolver el sistema As=b con la Regla de Cramer
%% argumentos:
%% A matriz nxn
%% b vector columna
%% devuelve:
%% s solucion del sistema o mensaje de error
function s=solveCramer(A,b)
  [m,n]=size(A);
  if (m~=n)
    error('Matriz A no cuadrada');
  elseif (n~=length(b))
    error('dimensiones incompatibles');
  end
  s=zeros(n,1);
  denom=determinanteCramer(A);
%%  if (abs(denom)< 10*eps)
%%    error("Matriz singular");
%%  end
  for j=1:n
    B=A;
    B(:,j)=b;
    s(j)=determinanteCramer(B)/denom;
  end
end
