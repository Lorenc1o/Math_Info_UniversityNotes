addpath("../Matrices")

n=100

A=11*eye(n);

A(1,2)=-1;
for i=2:n-1
  A(i,i+1)=-1;
  A(i,i-1)=-1;
endfor
A(n,n-1)=-1;

A(1,3)=-2;
A(2,4)=-2;
for i=3:n-2
  A(i,i+2)=-2;
  A(i,i-2)=-2;
endfor
A(n-1,n-3)=-2;
A(n,n-2)=-2;

[V,v] = eig(A);

vb=v;
for i=1:n
  vb(i,i)=v(i,i)**(1/3);  
endfor

B=V*vb*inv(V);

norm(A-B*B*B)
% n=4   -> 1e-14
% n=10  -> 1e-14
% n=100 -> 1e-13


  