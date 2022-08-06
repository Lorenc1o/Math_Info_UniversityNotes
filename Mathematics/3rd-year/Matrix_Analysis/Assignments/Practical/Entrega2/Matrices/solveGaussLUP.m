function X = solveGaussLUP(L, U, P, b)
  X = solveU(U, solveL(L, P*b));
endfunction
