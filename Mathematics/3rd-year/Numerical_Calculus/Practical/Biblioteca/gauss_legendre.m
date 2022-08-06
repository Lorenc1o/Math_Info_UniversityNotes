%Cuadratura de gauss-legendre n=2, n=3

function int=gauss_legendre(f,a,b,n)
 
 g=@(t) a+(b-a)./2*(1+t);
 dg=(b-a)/2;
  
 %La función peso es cte=1
  if(n==2)
    %Los nodos para n=2
    x=[-sqrt(3/5),0,sqrt(3/5)];
    %Los pesos
    w=[5/9, 8/9, 5/9];
  elseif(n==3)
    %Los nodos para n=3
    x=[sqrt((3-2*sqrt(6/5))/7), -sqrt((3-2*sqrt(6/5))/7), sqrt((3+2*sqrt(6/5))/7), -sqrt((3+2*sqrt(6/5))/7)];
    %Y los pesos
    w=[(18+sqrt(30))/36, (18+sqrt(30))/36, (18-sqrt(30))/36, (18-sqrt(30))/36];
  else 
    error('n debe ser 3 o 4')  
  endif 
    int = sum(w.*f(g(x)))*dg;
endfunction 