% Funcion para calcular las diferencias divididas usando la formula recursiva
% para las diferencias divididas.
% Entrada:   
%            - x = vector que contiene las abscisas de los n+1 puntos a interpolar (nodos)
%
%            - y = valores de la funcion en los n+1 nodos de interpolacion
% Salida:   
%            - difdiv= tabla de las diferencias divididas
% El numero de nodos de interpolacion (n+1), lo obtiene a partir de la longitud de x.

function difdiv=diferencias_divididas(x,y)

n=size(x,2)-1;

if length(y) ~= n+1
   error('las dimensiones de x e y no coinciden');
   end

for i=1:n+1
    difdiv(i,1)=y(i);
end

for i=1:n+1
    for j=2:i
        difdiv(i,j)=(difdiv(i,j-1)-difdiv(i-1,j-1))/(x(i)-x(i-j+1));
    end
end

disp(['Numero de nodos de interpolacion= ' mat2str(n+1)]);
disp('Nodos de interpolacion: ');
disp(x);
disp('Valores de la funcion en los nodos de interpolacion:');
disp(y);
disp('La tabla de diferencias divididas es:');
fprintf('\t  f[.] \t \t  f[..] \t \t f[...]\n');
disp(difdiv)

