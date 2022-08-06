function [ Q,R ] = GramSchmidt0( A )
%GramSchimidt Summary of this function goes here
%   Devuelve Q y R con Q'*Q=ID y Q*R=A


[m,n] = size(A);  % m filas de A y n columnas de A
tolerancia=100*eps;
%%
%% Para jugar con la tolerancia
ne=0;  % número de pruebas de ortogonalización
  while (ne<15)
      nq = 0;
      tolerancia=10*tolerancia;
      ne=ne+1;

      Q = zeros(m,n);
      R= zeros(m,n);
      for j=1:n
          aux=A(:,j); % La columna j
          for k=1:nq
              R(k,j)=dot(A(:,j),Q(:,k));
              aux = aux - R(k,j)*Q(:,k);
          end
          norma=norm(aux);
          if (norma>tolerancia) 
               nq = nq+1;
               Q(:,nq) = 1/norma*aux;
               R(nq,j)= norma;
          end
      end
      nq;
      % Redimenionamos Q y R
      if nq<n
          Q(:,nq+1:n) = [];
      end
      if nq<m
          R(nq+1:m,:) = [];
      end
      if (norm(Q'*Q-eye(nq)) > tolerancia)
        if ne==15
          tolerancia
          norm(Q'*Q-eye(nq))
          warning('AVISO: Q no es ortogonal/unitaria')
        end
      else 
        numero_etapas_QR=ne
        break
      end
  end    
end
