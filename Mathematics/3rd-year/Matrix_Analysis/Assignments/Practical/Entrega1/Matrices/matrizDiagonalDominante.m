function A = matrizDiagonalDominante (n)
  A = 10* rand(n, n) - 5* ones(n, n);
  for i=1:n
    d = sum(abs(A(i,:))) - abs(A(i, i));
    if abs(A(i, i)) < d - 100*eps
      A(i, i) = d + abs(A(i, i));
    end
  end
endfunction
