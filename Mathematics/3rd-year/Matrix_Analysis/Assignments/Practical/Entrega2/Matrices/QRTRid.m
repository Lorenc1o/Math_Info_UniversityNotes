% Factorización QR de una matriz tridiagonal
% Asumimos que T es una matriz cuadrada tridiagonal
function [Q,R]=QRTRid(T)
  n=length(T);
  Qt=eye(n);
  R=T;
  for i=1:n-1
    den2=sqrt(R(i+1,i)^2+R(i,i)^2);
    if den2< 1000*eps
      continue
    end
    seno=R(i+1,i)/den2;
    coseno=R(i,i)/den2;
    P=eye(n);
    P(i,i)=coseno; P(i+1,i+1)=coseno;
    P(i+1,i)=-seno; P(i,i+1)=seno;
    R=P*R; R(i+1,i)=0;
    Qt=P*Qt;
  end
  Q=Qt';
end
