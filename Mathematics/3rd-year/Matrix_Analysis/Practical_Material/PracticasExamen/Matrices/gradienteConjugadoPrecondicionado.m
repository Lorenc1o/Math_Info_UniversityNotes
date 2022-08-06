
function x = gradienteConjugadoPrecondicionado (A,b,xn,C,prec)
  P=C*C';
  invP=inv(C);
  invP=invP'*invP;
  nb=norm(b);
  x=xn;
  n=length(b);
  res=b-A*x;
  e=norm(res)/nb;
    if  e < prec
      return
    end
  z=invP*res; 
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
      fprintf('Gradiente precondicionado converge en %d iteraciones con precion %d en el residual \n', i, e);
      break
    end 
    z=invP*res;
    beta=dot(res,z);
    ns=beta/gamma;
    gamma=beta;
    v=z+ns*v;
  end
  if e > prec
     warning('Gradiente Conjugado: error en solución.');
  end
end
