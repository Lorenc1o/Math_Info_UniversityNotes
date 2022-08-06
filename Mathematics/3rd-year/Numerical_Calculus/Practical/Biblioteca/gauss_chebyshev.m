%Cuadratura de gauss-chebyshev para n=2,n=3

function int=gauss_chebyshev(f,a,b,n)
  
  g=@(t) a+(b-a)./2*(1+t);
  dg=(b-a)/2;

  %La función peso
  W=@(x) sqrt(1-x.^2);
  if(n==2)
    %Los nodos de Chebyshev para n=2
    x=[-sqrt(3)/2,0,sqrt(3)/2];
    %Y los pesos
    w=[pi/3, pi/3, pi/3];
  elseif(n==3)
    %Los nodos de Chebyshev para n=3
    x=[0.5*sqrt(2-sqrt(2)), -0.5*sqrt(2-sqrt(2)), 0.5*sqrt(2+sqrt(2)), -0.5*sqrt(2+sqrt(2))];
    %Y los pesos
    w=[pi/4, pi/4, pi/4, pi/4];
  else 
    error('n debe ser 3 o 4')  
  endif 
    int = dg*sum(W(x).*w.*f(g(x)));
endfunction 