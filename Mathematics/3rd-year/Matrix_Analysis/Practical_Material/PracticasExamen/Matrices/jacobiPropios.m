% Metodo para encontrar los valores y vectores propios
% de una matriz simetrica
% devuelve un vector con los valores propios y una 
% matriz con aproximaciones a los vectores propios

function [vp,V,iter,control]= jacobiPropios (A,nmaxit)
  global precision;
  n=length(A);
  B=A;
  resto=0; %Para condicion de parada
  vp=diag(A);
  V=eye(n);
  iter=Inf;
  for i=1:n
    for j=i+1:n
      resto=resto+2*A(i,j)^2;
    end
  end
  if sqrt(resto)<precision
    display('Matriz diagonal');
    return
  end
  
  for k=1:nmaxit
  %  k-1  % solo para clase
   % B     % solo para clase
    p=1;
    q=2;
    aux=0;
    for i=1:n-1
      for j=i+1:n
        if abs(B(i,j))>aux
          aux=abs(B(i,j));
          p=i;
          q=j;
        end
      end
    end
  %  B(p,q)
    if(abs(B(p,q))<100*eps)
     vp= diag(B);
     control=0;
     for i=1:n
       ncontrol=norm(A*V(:,i)-vp(i)*V(:,i));
       control=control + ncontrol;
     end
     iter=k;
     %display(['Jacobi converge, en ' mat2str(k) ' iteraciones']);
     %display(['control v propios = ' mat2str(control)]);
     % B  % solo para clase
     return
    end
    
   x=(B(q,q)-B(p,p))/(2*B(p,q));
   if x >= 0
     t=-x+sqrt(1+x^2);
   else
     t=-x-sqrt(1+x^2);
   end
   sq=sqrt(1+t^2);
   c=1/sq;
   s=t/sq;
   resto=resto - 2* B(p,q)^2;
   B(p,p)=B(p,p)-t*B(p,q);
   B(q,q)=B(q,q)+t*B(p,q);
   B(p,q)=0;
   B(q,p)=0;
   for i=1:n
     if and(i ~=p,i ~=q)
       ap=B(i,p);
       aq=B(i,q);
       B(i,p)=c*ap-s*aq;
       B(p,i)=B(i,p);
       B(i,q)=s*ap+c*aq;
       B(q,i)=B(i,q);
     end
       op=V(i,p);
       oq=V(i,q);
       V(i,p)=c*op-s*oq;
       V(i,q)=s*op+c*oq;
   end
    if  sqrt(resto) < precision,
     vp= diag(B);
     control=0;
     for i=1:n
       ncontrol=norm(A*V(:,i)-vp(i)*V(:,i));
       control=control + ncontrol;
     end
     iter=k;
     %display(['Jacobi converge, en ' mat2str(k) ' iteraciones']);
     %display(['control v propios = ' mat2str(control)]);
   % B  % solo para clase
     return
   end
  end

  error('Jacobi no converge');
  
  
endfunction
