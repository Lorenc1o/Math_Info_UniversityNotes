
function [x,k,e]=iter3dGaussSeidel(di,dp,ds,b,xn,nmaxit,prec)
  D=diag(dp);
  nb=norm(b);
  x=xn;
  dim=length(xn);
  if (min(abs(dp))<10*eps)
    error('0 en diagonal, GaussSeidel no aplicable');
  end
  A=D+diag(di,-1)+diag(ds,1);
  k=1;
  res=A*x-b;
  while k<nmaxit
    e=norm(res)/nb;
    if  e < prec
      fprintf('Gauss Seidel converge en %d iteraciones con precision %d en el residual \n', k, e);
      break
    end 
    res(1)= dp(1)*x(1)+ds(1)*x(2)-b(1);   %% A(1,:)=dp(1),ds(1),0,... 
    x(1)=x(1)-1/dp(1)*res(1);
    for i=2:dim-1 
      res(i) =di(i-1)*x(i-1)+dp(i)*x(i)+ds(i)*x(i+1)-b(i); %% A(i,:)=0,...,di(i-1),dp(i),ds(i),0,... si 
      x(i)=x(i)-1/dp(i)*res(i);
    end 
    res(dim) =di(dim-1)*x(dim-1)+dp(dim)*x(dim)-b(dim); %% A(dim,:)=0,...,di(dim-1),dp(dim)
      x(dim)=x(dim)-1/dp(dim)*res(dim);
    k=k+1;
  end
  if k==nmaxit
    fprintf('no hay convergencia en %d iteraciones con precision %d \n',nmaxit,prec);
    error('Error en GaussSeidel');
  end
end
