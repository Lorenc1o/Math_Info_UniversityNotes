%% Resolver el sistema sobredeterminado Ax=b usando R=Rhouseholder(A)

function x=fitMinimosCuadradosQR(A,b)
  [m,n]=size(A);
  [t,s]=size(b);
  if or(m<n,m~=t)
    error('Sistema no sobredeterminado o dimensiones incompatibles')
  end
  %% A' A x= A'b <-> R' R x= A'b
  R=Rhouseholder(A);
  x=solveU(R,solveL(R',A'*b)); 
end
