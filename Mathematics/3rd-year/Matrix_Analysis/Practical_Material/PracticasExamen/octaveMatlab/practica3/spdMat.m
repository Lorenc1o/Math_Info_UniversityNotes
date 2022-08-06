function SPD = spdMat (n)
  A = symmetricMat(n);
  [P,D]=eig(A);
  D=abs(D);
  D=D+norm(D)*eye(size(D));
  SPD= P*D*P';
endfunction
