% Funcion que calcula los coeficientes del spline natural
% Entradas:   
%            - x = vector que contiene las abscisas de los puntos a interpolar (nodos)
%            - a = ordenadas de los puntos
%            
% Salida: 
%          - vectores b,c,d con los coeficientes de los polinomios centrados
%                             a_i+b_i*(x-x_i)+c_i*(x-x_i)^2+d_i*(x-x_i)^3
%
function [b,c,d]= splineNatural(x,a)
  n=length(x);
  if length(a)~=n
    error('dimensiones incompatibles');
  end
  n=n-1;
  b = zeros(1,n + 1);
  c = zeros(1,n + 1);
  d = zeros(1,n + 1);
  h = zeros(1,n);
  ds = zeros(1,n);
  l = zeros(1,n + 1);
  u = zeros(1,n);
  z = zeros(1,n);
  for i=1:n
    h(i)=x(i+1)-x(i);
    ds(i)=a(i+1)-a(i);
  end
  l(1)=1;
  for i=2:n
    l(i)=2*(h(i)+h(i-1))-h(i-1)*u(i-1);
    u(i)=h(i)/l(i);
    z(i)=((3*ds(i)/h(i)-3*ds(i-1)/h(i-1))-h(i-1)*z(i-1))/l(i);
  end
  l(n+1)=1;
  for i=n:-1:1
    c(i) = z(i)- u(i) * c(i+1);
    b(i) = ds(i) / h(i) - h(i) * (c(i+1) + 2 * c(i)) / 3;
    d(i) = (c(i+1) - c(i)) / (3 * h(i));
  end
  
end