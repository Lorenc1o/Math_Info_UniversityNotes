function difdiv=diferencias_divididas_Hermite(xx,ff,difdiv_2)
% Funcion para calcular las diferencias divididas a partir de las de orden 2 
%usando la formula recursiva para las diferencias divididas.
% Entrada:   
%            - xx = vector que contiene los n+1 nodos de interpolacion
%            - ff = valores de las diferencias divididas de orden 2
%                   en los n+1 nodos de interpolacion
% El n� de nodos de interpolacion (n+1), lo obtiene a partir de la longitud de xx.

n=size(xx,2)-1;
disp(' ');
disp(['n� de nodos de interpolacion= ' mat2str(n+1)]);
disp('Nodos de interpolacion: ');
disp(xx);
disp(' ');
disp('Valores de la funcion en los nodos de interpolacion:');
disp(ff);
disp('Valores de las diferencias divididas de orden 2:');
disp(difdiv_2);
%xx=zeros(1,2*n)

for i=1:n+1
    difdiv(i,1)=ff(i);
end

for i=2:n+1
    difdiv(i,2)=difdiv_2(i-1);
end

for i=3:n+1
    for j=3:i
        difdiv(i,j)=(difdiv(i,j-1)-difdiv(i-1,j-1))/(xx(i)-xx(i-j+1));
    end
end

disp(' ');
disp('La tabla de diferencias divididas es:');
disp(difdiv);




