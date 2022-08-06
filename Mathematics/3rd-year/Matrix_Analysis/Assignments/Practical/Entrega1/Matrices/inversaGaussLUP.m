function X = inversaGaussLUP(L, U, P)
  X = solveU(U, solveL(L, P*eye(length(L))));
endfunction
