function matriz = telarana(funcion, cond_ini, num_iter)

matriz = zeros(2, 2*num_iter + 1);

matriz(1, 1) = cond_ini;
matriz(2, 1) = 0;
for n = 1 : num_iter
    matriz(1, 2*n) = matriz(1, 2*n - 1);
    matriz(2, 2*n) = funcion(matriz(1, 2*n - 1));
    matriz(1, 2*n + 1) = matriz(2, 2*n);
    matriz(2, 2*n + 1) = matriz(2, 2*n);
end
