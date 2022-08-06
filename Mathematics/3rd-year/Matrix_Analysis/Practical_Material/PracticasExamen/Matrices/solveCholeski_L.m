function X = solveCholeski_L(L, b)
  X = solveU(L', solveL(L, b));
endfunction