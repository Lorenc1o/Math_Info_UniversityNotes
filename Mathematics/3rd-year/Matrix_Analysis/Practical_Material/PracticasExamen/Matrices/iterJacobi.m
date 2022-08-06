
function x = iterJacobi (A,b,xn,nmaxit,prec)
  d=diag(A); D=diag(d);
  invD=inv(D);
  nb=norm(b);
  x=xn;
  if (min(abs(d))<10*eps)
    error('0 en diagonal, Jacobi no aplicable');
  end
  k=1;
  while k<nmaxit
    res=A*x-b;
    e=norm(res)/nb;
    if  e < prec
      fprintf('Jacobi converge en %d iteraciones con precision %d en el residual \n', k, e);
      break
    end    
    x=x-invD*res;
    k=k+1;
  end
  if k==nmaxit
    fprintf('no hay convergencia en %d iteraciones con precision %d \n',nmaxit,prec);
    error('Error en Jacobi');
  end
end
