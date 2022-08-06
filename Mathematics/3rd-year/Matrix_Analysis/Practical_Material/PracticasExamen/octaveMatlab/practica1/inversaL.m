%Función que calcula la inversa 
function x=inversaL(L)
  [m,n]=size(L);
  if m~=n           %Vemos si m es distinto de n
    error('Matriz no cuadrada.');
  endif
  x=solveL(L,eye(n));
endfunction
