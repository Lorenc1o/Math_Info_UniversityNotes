function det = determinanteGauss (A)
  [L,U,P] = LUPGauss(A);
  det = prod(diag(L))*prod(diag(U))*determinantePerm(P);
endfunction
