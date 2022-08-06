function det = determinanteLUP (L, U, P)
  det = prod(diag(L))*prod(diag(U))*determinantePerm(P);
endfunction
