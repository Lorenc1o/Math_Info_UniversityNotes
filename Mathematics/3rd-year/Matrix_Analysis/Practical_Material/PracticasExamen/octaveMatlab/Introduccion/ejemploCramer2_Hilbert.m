clear
clc

n=8

  %probamos con distintos valores de n=4, 6, 8

addpath('./Matrices')

# Consulta en la documentacion de Octave/Matlab las definiciones 
# de las matrices de Hilbert  hilb(n) y sus inversas invhilb(n)

H=hilb(n);
Hinv=invhilb(n);


printf('|| Id - H(n)* H^(-1)(n) || = %d \n', norm(eye(n)- H*Hinv));





x=ones(n,1); % vector columna con unos en sus elementos

b= H*x;




printf('\n Solucion Cramer \n \n');
try
  tic;
  x=solveCramer(H,b);
  toc;

  residual=b- H*x;
  printf('norma residual || b-Hx|| = %d \n',norm(residual));

  catch E
    warning(E.message);
end 


printf('\n Solucion Octave/Matlab \n \n');
try
  tic;
  xC= H\b;
  toc;
  residual=b- H*xC;
  printf('norma residual || b-Hx|| = %d \n',norm(residual));
  catch E
     printf(' Error en solve A\\b \n')
end 

