%Funcion solveQR(Q,R,B) 
%Devuelve la solución del sistema Q*R*x=B o un mensaje de error
function x=solveQR(Q,R,B)
  [m,n]=size(R);
  if m~=n           %Vemos si m es distinto de n
    error('Matriz no cuadrada.');
  endif
  [p,c]=size(B);
  if p~=n           %Numero de columnas de R debe ser igual al numero de filas de B
    error('Dimensiones incompatibles de R y B.');
  endif
  x= solveU(R,Q'*B);
end
