function L = factorLdeCholeski(A)
  %Comprobar que A es una matriz cuadrada
  [m,n]=size(A);
  if(m ~= n)
    error('matriz no cuadrada');
  end
  %Constuir L y U usando la matriz Aux
  Aux=zeros(n,n);
  %Vamos a ir rellenando Aux por filas y columnas de forma alternada
  %Primera fila:
  Aux(1,1)=A(1,1); %L(1,1)=1 y U(1,1)=aux(1,1)
  if Aux(1,1)<100*eps 
    error('matriz no definida positiva');
  end
  % Aux(1,2:n)=A(1,2:n); %Coincide con la de U
  % Primera columna:
  Aux(1, 1) = sqrt(Aux(1, 1));
  Aux(2:n,1)=A(2:n,1)/Aux(1,1); %Coincide con la de L
  for k=2:n 
    Aux(k,k)=A(k,k)-Aux(k,1:k-1)*Aux(k, 1:k-1)'; %U(k,k)=Aux(k,k)
    if Aux(k,k)<100*eps
      error('matriz no definida positiva');
    end
    %fila k desde columna k+1(para U),y columna k desde fila k+1(para L):
    Aux(k,k) = sqrt(Aux(k,k));
    for r=k+1:n
      % Aux(k,r)=A(k,r)-Aux(k,1:k-1)*Aux(1:k-1,r); %U(k,r)=Aux(k,r)
      Aux(r,k)=(A(r,k)-Aux(r,1:k-1)*Aux(k, 1:k-1)')/Aux(k,k); %L(r,k)=Aux(r,k)
    end
  end
  % U=triu(Aux);%U(i,j)=Aux(i,j) si i<=j
  L=tril(Aux);%L(r,r)=1 y L(i,j)=Aux(i,j) si i>j  
    
endfunction
