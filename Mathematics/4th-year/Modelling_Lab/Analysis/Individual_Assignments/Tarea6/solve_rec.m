function sol = solve_rec(coef, indep, cond_ini, var)

syms x(n) z;
assume(n >= 0 & in(n, 'integer'));

k = length(coef) - 1;


f = 0;
for m = 0 : k
    f = f + coef(m + 1)*x(n + m);
end
f = f - subs(indep, var, n);

fZT = ztrans(f, n, z);

syms xZT;
fZT = subs(fZT, ztrans(x(n), n, z), xZT);

xZT = solve(fZT, xZT);

sol = iztrans(xZT, z, n);
sol = rewrite(sol,'exp');
sol = simplify(sol, 'Steps', 80);
sol = simplify(sol, 'IgnoreAnalyticConstraints', true);

for m = 0 : k - 1
    sol = subs(sol, x(m), cond_ini(m+1));
end
sol = subs(sol, n, var);
