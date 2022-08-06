%Funcion solveU(U,B) 
%Devuelve la solución del sistema U*x=B o un mensaje de error
function x=solveU(U,B)
  [m,n]=size(U);
  if m~=n           %Vemos si m es distinto de n
    error('Matriz no cuadrada.');
  endif
  [p,c]=size(B);
  if p~=n           %Numero de columnas de U debe ser igual al numero de filas de B
    error('Dimensiones incompatibles de U y B.');
  endif
  x= zeros(n,c);
  x(n,:)=B(n,:)/U(n,n);
  for k=n-1:-1:1
    x(k,:)= (B(k,:)-U(k,k+1:n)*x(k+1:n,:))/U(k,k);
  end
end
