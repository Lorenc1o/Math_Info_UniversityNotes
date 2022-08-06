function sol=solve3dconstsyme(D,b)
  n=length(b);
  ti=b;
  diagonal=D*ones(n,1);
  for i=2:n
    % por seguridad se puede enviar un error si diagonal(i-1) aprox 0.
    diagonal(i)=diagonal(i)-1./diagonal(i-1);
    ti(i)=ti(i)+ti(i-1)/diagonal(i-1);
  end
  sol=zeros(n,1);
  % por seguridad se puede enviar un error si diagonal(n) aprox 0.
  sol(n)=ti(n)/diagonal(n);
  for i=n-1:-1:1
    sol(i)=(ti(i)+sol(i+1))/diagonal(i);
  end
end