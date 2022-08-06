function [Q,R]=QRhouseholder(A)
[m,n]=size(A);

Q=eye(m);
R=A;
  t=min(m,n)-(m<=n);
  for k=1:t
    a=R(k:m,k);
    e=zeros(m-k+1,1);
    e(1)=norm(a);
    v=a-sign(a(1))*e;
    normv2=v'*v;
    if abs(normv2)< 100*eps
      continue
    end
    H=eye(m);
    H(k:m,k:m)=eye(m-k+1)-2/normv2*(v*v');
    Q=Q*H';
    R=H*R;
  end 
  R=triu(R);
endfunction