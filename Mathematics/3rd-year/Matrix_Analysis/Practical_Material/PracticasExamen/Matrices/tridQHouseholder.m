
%% [Q,T]=tridQHouseholder(double[][] A), A simetrica
function [Q,T]=tridQHouseholder(A)
[m,n]=size(A);
  if(m ~= n)
    error('matriz no cuadrada');
  end
Q=eye(m);
T=A;
  t=n-2;
  for k=1:t
    a=T(k+1:n,k);
    e=zeros(n-k,1);
    e(1)=norm(a);
    v=a-sign(a(1))*e;
    normv2=v'*v;
    if abs(normv2)< 100*eps
      continue
    end
    H=eye(n);
    H(k+1:n,k+1:n)=eye(n-k)-2/normv2*(v*v');
    Q=Q*H';
    T=H*T*H';
  end 
   T=diag(diag(T))+diag(diag(T,-1),-1)+diag(diag(T,1),1);
endfunction