% Calcula el polinomio interpolador en la forma de Newton de grado maximo a partir 
% de una tabla de diferencias divididas. 
% El polinomio interpolador viene expresado como una cadena de caracteres, y esta
% escrito en la forma de Horner.
% Funciona a partir de n=1.

function pol=polinomio_interpolador_Newton(difdiv,x)

n=size(difdiv,1);

% Calculamos el polinomio interpolador en la forma de Horner
% Lo construimos como una cadena de caracteres

pol=[mat2str(difdiv(1,1)) '+(x-' mat2str(x(1)) ')*('];

for i=2:n-1
    pol=[pol mat2str(difdiv(i,i)) '+(x-' mat2str(x(i)) ')*('];
end

% Necesitamos cerrar los parentesis. Construimos una cadena de caracteres con
% el simbolo ')' repetido n veces.
cierraparen=')';
for i=1:n-2
    cierraparen=[cierraparen ')'];
end
    
pol=[pol mat2str(difdiv(n,n)) cierraparen]

