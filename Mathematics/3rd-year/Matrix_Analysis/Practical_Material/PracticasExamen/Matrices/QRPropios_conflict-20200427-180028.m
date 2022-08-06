% Metodo para encontrar los valores y vectores propios
% de una matriz simetrica
% devuelve un vector con los valores propios y una 
% matriz con aproximaciones a los vectores propios

function [vp,V,iter,control]= QRPropios (A,nmaxit)
  global precision;
  n=length(A);
  desplazamiento=0.001;
  U=A; % para las etapas A_k
  V=eye(n);
  iter=Inf;
  control=Inf;
  for k=1:nmaxit
    [Q,R]=QRhouseholder(U);
    U=R*Q;
    V=V*Q;
    control=norm(tril(U,-1));
    if control < precision
      display(' Matriz triangular ');
      iter=k;
      break;
    end
  
  end
  vp=diag(U);
  

  %% para matrices no simetricas
  for i=1:n
    [vp(i),V(:,i)]=potenciaInvDesplazada(A,vp(i)+desplazamiento,V(:,i),nmaxit,precision);
  endfor

  
  
%%%%     control=0;
%%%%     for i=1:n
%%%%       ncontrol=norm(A*V(:,i)-vp(i)*V(:,i));
%%%%       control=control + ncontrol;
%%%%     end
%%%%     iter=k;
%%%%     %display(['Jacobi converge, en ' mat2str(k) ' iteraciones']);
%%%%     %display(['control v propios = ' mat2str(control)]);
%%%%     % B  % solo para clase
%%%%     return
 
  
endfunction
