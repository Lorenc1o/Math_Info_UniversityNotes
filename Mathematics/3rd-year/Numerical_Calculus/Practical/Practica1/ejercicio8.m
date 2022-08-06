disp('Ejercicio 8')
clear all 
clc 

epsilon_double=eps 

% menor positivo tal que 1+x > 1

%primera opcion: el siguiente número al 1:  
% tiene por mantisa (1.) 51 ceros y un 1 en base 2

x=2^(-52)

1+x>1

%segunda opcion: como lo calcula octave/matlab 

x=1;
seguir=true;
while seguir
  if(1+x>1)
    x=x/2;
  else 
    x=2*x;
    seguir=false;
  end
end
x
  