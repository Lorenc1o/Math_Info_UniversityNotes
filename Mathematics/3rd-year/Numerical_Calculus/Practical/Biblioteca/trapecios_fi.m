%trapecios usando funciones internas

function int = trapecios_fi (f,a,b,N)
  x=linspace(a,b,N+1);
  w=2*ones(1,N-1);
  w=[1 w 1];
  int = (b-a)/(2*N) * sum(w.*f(x));
endfunction 