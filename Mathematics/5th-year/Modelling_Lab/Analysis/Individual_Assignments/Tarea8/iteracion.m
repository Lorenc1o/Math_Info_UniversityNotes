function vector = iteracion(funcion, cond_ini, num_iter)

vector = zeros(1, num_iter + 1);

vector = cond_ini;
for n = 1 : num_iter
    vector(n + 1) = funcion(vector(n));
end

