%Función que calcula la inversa 
function x=inversaU(U)
  [m,n]=size(U);
  if m~=n           %Vemos si m es distinto de n
    error('Matriz no cuadrada.');
  endif
  x=solveU(U,eye(n));
endfunction
