function [L, U] = LUdootlittle (A)
  %Comprobar que A es una matriz cuadrada
  [m,n]=size(A);
  if(m ~= n)
    error('matriznocuadrada');
  end
  %Constuir L y U usando la matriz Aux
  Aux=zeros(n,n);
  %Vamos a ir rellenando Aux por filas y columnas de forma alternada
  %Primera fila:
  Aux(1,1)=A(1,1); %L(1,1)=1 y U(1,1)=aux(1,1)
  if abs(Aux(1,1))<100*eps 
    error('ceroendiagonaldeU');
  end
  Aux(1,2:n)=A(1,2:n); %Coincide con la de U
  %Primera columna:
  Aux(2:n,1)=A(2:n,1)/Aux(1,1); %Coincide con la de L
  for k=2:n 
    Aux(k,k)=A(k,k)-Aux(k,1:k-1)*Aux(1:k-1,k); %U(k,k)=Aux(k,k)
    if abs(Aux(k,k))<100*eps
      error('ceroendiagonaldeU');
    end
    %fila k desde columna k+1(para U),y columna k desde fila k+1(para L):
    for r=k+1:n
      Aux(k,r)=A(k,r)-Aux(k,1:k-1)*Aux(1:k-1,r); %U(k,r)=Aux(k,r)
      Aux(r,k)=(A(r,k)-Aux(r,1:k-1)*Aux(1:k-1,k))/Aux(k,k); %L(r,k)=Aux(r,k)
    end
  end
  U=triu(Aux);%U(i,j)=Aux(i,j) si i<=j
  L=tril(Aux,-1)+eye(n);%L(r,r)=1 y L(i,j)=Aux(i,j) si i>j  
    
endfunction
