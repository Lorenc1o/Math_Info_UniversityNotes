function det = determinanteLU (L, U)
  det = prod(diag(L))*prod(diag(U));
endfunction
