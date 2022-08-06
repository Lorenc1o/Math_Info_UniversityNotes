function X = inversaGauss(A)
  [L,U,P] = LUPGauss(A);
  X = solveU(U, solveL(L, P*eye(length(L))));
endfunction
