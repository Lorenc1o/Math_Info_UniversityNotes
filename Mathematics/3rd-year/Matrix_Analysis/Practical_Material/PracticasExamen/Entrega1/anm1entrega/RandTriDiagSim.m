%esta función construye una matriz tridiagonal simétrica con números aleatorios
%de dimensión n y con valores entre -escalar y escalar
function A=RandTriDiagSim(n, escalar)
  A=zeros(n,n); 
  escalar=2*escalar;
  A(1,1)=(rand()-0.5)*escalar;
  A(2,1)=(rand()-0.5)*escalar;
  for i=2:n-1
    A(i-1,i)=A(i,i-1);
    A(i,i)=(rand()-0.5)*escalar;
    A(i+1,i)=(rand()-0.5)*escalar;
  endfor 
  A(n-1,n)=A(n,n-1);
  A(n,n)=(rand()-0.5)*escalar;
endfunction