function [L,D,R] = LDR (A)
  [L, U] = LUdootlittle(A);
  D = diag(diag(U));
  R = diag(1./diag(D)) * U;

endfunction
