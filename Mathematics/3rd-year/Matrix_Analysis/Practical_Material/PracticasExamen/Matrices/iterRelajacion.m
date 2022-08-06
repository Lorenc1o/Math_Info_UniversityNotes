
function x = iterRelajacion (A,b,w,xn,nmaxit,prec)
  d=diag(A); D=diag(d);
  invD=inv(D);
  nb=norm(b);
  x=xn;
  dim=length(xn);
  if (min(abs(d))<10*eps)
    error('0 en diagonal, Relajacion no aplicable');
  end
  k=1;
  res=A*x-b;
  while k<nmaxit
    e=norm(res)/nb;
    if  e < prec
      fprintf('Relajacion converge en %d iteraciones con precision %d en el residual \n', k, e);
      break
    end 
    for i=1:dim  
      res(i) = A(i,:)*x-b(i);
      x(i)=x(i)-w/d(i)*res(i);
    end 
    k=k+1;
  end
  if k==nmaxit
    fprintf('no hay convergencia en %d iteraciones con precision %d \n',nmaxit,prec);
    error('Error en Relajacion');
  end
end
