%Simpson usando funciones internas

function int = simpson_fi (f,a,b,N)
  %N par 
  x=linspace(a,b,N+1);
  w=ones(1,N+1);
  w(2:2:N)=4;
  w(3:2:N)=2;
  
  int=(b-a)/(3*N)*sum(w.*f(x));
  
endfunction