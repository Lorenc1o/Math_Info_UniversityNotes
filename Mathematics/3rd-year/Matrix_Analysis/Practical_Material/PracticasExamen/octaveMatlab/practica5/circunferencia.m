% circunferencias
clear all
clc 


x=[0,0,-1,1]%,2]
y=[1,-1,0,1]%,0]
n=length(x);

%% centro (a,b) y radio r   (incognitas)
%% (x-a)^2+(y-b)^2= r^2  (no lineal) <->  A x + B y + C = x^2+y^2 (lineal en A, B, y C)
%%  a=A/2; b=B/2 ; r^2 = C + a^2+b^2
%% Ax_i+ By_i + C = (x_i^2+y_i^2)


M=ones(n,n);
N=ones(n,1);
for i=1:n
  M(i,1)=x(i);
  M(i,2)=y(i);
  M(i,3)=1;
  N(i)=x(i)^2+y(i)^2;
end

sol=(M'*M)\(M'*N)

norm(M*sol-N)

A=sol(1); B=sol(2); C=sol(3);

a=A/2;
b=B/2;
ra=sqrt(C+a^2+b^2)


t = linspace(0,2*pi,53);
circsx =a+ ra.*cos(t) ;
circsy = b+ ra.*sin(t) ;
%axis square;
plot(x,y,"*","linewidth", 2,circsx,circsy, "linewidth", 2); 
lad=2.2
axis ([-lad,lad,-lad,lad]);
daspect ([4 4 1]);
