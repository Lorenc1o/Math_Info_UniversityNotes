% Calcula el polinomio interpolador en la forma de Newton de grado maximo 
% a partir de una tabla de diferencias divididas. 
% El polinomio interpolador viene expresado en la forma a_n*x^n+...+a_1*x+a_0
% La salida es el vector a_n a_n-1 ...a_1 a_0


function pol=coef_polinomio_interpolador(difdiv,x)
k=size(difdiv,1);
pol=difdiv(k,k)*poly(x(k-1));
for i=k-1:-1:2
    pol=conv((pol+[zeros(1,k-i) difdiv(i,i)]),poly(x(i-1)));
end
pol=pol+[zeros(1,k-1) difdiv(1,1)]