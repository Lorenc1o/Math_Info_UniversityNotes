%Ejercicio 1
clear all
clc 

n=5;

r=zeros(1,50);
p=zeros(1,50);
q=p;
error=1e-7;
r(1)=1+error;
r(2)=1/3+error;
%r(1)=1;
%r(2)=1/3;

p(1)=r(1);
p(2)=r(2);

q(1)=r(1);
q(2)=r(2);

for k=3:50
  r(k)=1/3*r(k-1);
  p(k)=4/3*p(k-1)-1/3*p(k-2);
  q(k)=10/3*q(k-1)-q(k-2);
end


printf('k\tr(k)\tp(k)\tq(k)\n');
for k=1:50
  fprintf('%5d\t%5e\t%5e\t%5e\n', k, r(k), p(k), q(k));
end



e_a_p=r;
e_a_q=r;

for k=1:50
  e_a_p(k)=abs(p(k)-r(k));
  e_a_q(k)=abs(q(k)-r(k));
end 

k=1:50;

plot(k, r, k, p, k, q); 

%figure(2);

%plot(k,log(e_a_p),k,log(e_a_q));
%legend('r,p','r,q');
