%  polinomioFit2( x , y, n)
% datos de entrada dos listas (vectores fila) x e y con las abscisas y ordenadas de los puntos 
% a ajustar por un polinomio de grado <=n
function p=polinomioFit2(x,y,n)
 m=length(x);
 if (length(y)~=m || m<n+1)
     error('longitudes incompatibles')
 end
 % matriz de coeficientes de las ecuaciones sobredeterminado 
 % es la matriz de vandermonde de las abscisas de x,
 %  x_i^n, x_i^(n-1),...,x_i,1
 
 A=vander(x,n+1);
 
 % el sistema sobredeterminado es A p = y
 
 p=fitMinimosCuadradosQR(A,y')';
  
  
end
