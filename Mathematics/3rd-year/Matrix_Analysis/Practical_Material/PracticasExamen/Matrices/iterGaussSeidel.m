
function x = iterGaussSeidel (A,b,xn,nmaxit,prec)
  d=diag(A); D=diag(d);
  invD=inv(D);
  nb=norm(b);
  x=xn;
  dim=length(xn);
  if (min(abs(d))<10*eps)
    error('0 en diagonal, GaussSeidel no aplicable');
  end
  k=1;
  res=A*x-b;
  while k<nmaxit
    e=norm(res)/nb;
    if  e < prec
      fprintf('Gauss Seidel converge en %d iteraciones con precision %d en el residual \n', k, e);
      break
    end 
    for i=1:dim  
      res(i) = A(i,:)*x-b(i);
      x(i)=x(i)-1/d(i)*res(i);
    end 
    k=k+1;
  end
  if k==nmaxit
    fprintf('no hay convergencia en %d iteraciones con precision %d \n',nmaxit,prec);
    error('Error en GaussSeidel');
  end
end
