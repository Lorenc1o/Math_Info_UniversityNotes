function X = solveCholeski(A, b)
  L = factorLdeCholeski(A);
  X = solveU(L', solveL(L, b));
endfunction