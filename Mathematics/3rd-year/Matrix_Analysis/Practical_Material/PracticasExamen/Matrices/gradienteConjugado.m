
function x = gradienteConjugado (A,b,xn,prec)
  nb=norm(b);
  n=length(b);
  x=xn;
  res=b-A*x;
  e=norm(res)/nb;
    if  e < prec
      fprintf('Gradiente converge en 0 iteraciones con precion %d en el residual \n', e);
      return
    end
  z=res; 
  v=z;
  gamma=dot(res,z);
  for i=1:n
    y=A*v;
    nAv=dot(v,y);
    nt=gamma/nAv;
    x=x+nt*v;
    res=res-nt*y;
    e=norm(res)/nb;
    if  e < prec
      fprintf('Gradiente converge en %d iteraciones con precion %d en el residual \n', i, e);
      break
    end 
    z=res;
    beta=dot(res,z);
    ns=beta/gamma;
    gamma=beta;
    v=z+ns*v;
  end
  if e > prec
    warning('warning en Gradiente');
  end
end
