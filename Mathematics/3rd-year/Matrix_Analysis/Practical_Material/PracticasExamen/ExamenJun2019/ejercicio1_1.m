addpath("../Matrices")

n=100
format long

A=6*eye(n);

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

A

b=zeros(n,1);

for i=1:n
  b(i)=n/2-abs(n/2-i);
endfor

#a Método directo

X1=solveGaussParcial(A,b);

e=norm(A*X1-b)/norm(b)

#b Método de relajación peso óptimo

#Decomponemos A, sacamos TJ 
D=diag(diag(A));

L=zeros(n);

for i=2:n
  for j=1:i-1
    L(i,j)=A(i,j);
  endfor 
endfor

U=A-D-L;

TJ=inv(D)*(-(L+U));

#sacamos el peso

y=eig(TJ);

y=norm(y,inf)**2;

w=2/(1+sqrt(y-1));

xn=ones(n,1);

X2=iterRelajacion(A,b,w,xn,inf, 1e-12);
e=norm(A*X1-b)/norm(b) 
# n=10 -> 164 it obteniendo un error relativo ~ 8e-16
# n=100 -> 13359 it obteniendo un error relativo ~ 8e-14

#c Gradiente conjugado
 
X3=gradienteConjugado(A,b,xn,1e-12);
e=norm(A*X1-b)/norm(b)
# n=10 -> 10 it obteniendo un error relativo ~ 8e-16
# n=100 -> 65 it obteniendo un error relativo ~ 8e-14
