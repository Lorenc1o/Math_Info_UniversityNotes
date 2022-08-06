function S = symmetricMat (n)
  A = 10* rand(n, n) - 5* ones(n, n);
  L = tril(A);
  S = L + L';
endfunction
