function [Q,R]=QRTrid(T)
  [n,m]=size(T);
  if(n!=m)
    error("La matriz no es cuadrada");
  endif
  A=T;
  j=0;
  
  P=eye(n);
  for i=1:n-1
    Pi=eye(n);
    ai=A(i,i);
    bi=A(i+1,i);
    mi=sqrt(ai*ai+bi*bi);
    Pi(i,i)=ai/mi; %cos
    Pi(i+1,i)=-bi/mi; %-sen
    Pi(i,i+1)=bi/mi; %sen
    Pi(i+1,i+1)=ai/mi; %cos
    P=Pi*P;
    A=Pi*A;
  endfor
  
  R=A;
  Q=P';
  
endfunction