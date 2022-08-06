function X = solveLU (L, U, B)
  [m,n]=size(L);
  [p,c]=size(B);
  if p~=n           %Numero de columnas de L debe ser igual al numero de filas de B
    error('Dimensiones incompatibles de L y B.');
  end
  X = solveU(U, solveL(L,B));

end
