%% Resolver el sistema sobredeterminado Ax=b usando choleski en A'*A

function x=fitMinimosCuadradosCholeski(A,b)
  [m,n]=size(A);
  [t,s]=size(b);
  if or(m<n,m~=t)
    error('Sistema no sobredeterminado o dimensiones incompatibles')
  end
  %% A' A x= A'b <->  A'*A= L*L'
  L=factorLdeCholeski(A'*A);
  
  x=solveU(L',solveL(L,A'*b)); 
end
