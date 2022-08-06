derivaprox3
--------------
> df = derivaprox3(f, x)
> global paso;
Aproxima f'(x) según la pendiente entre x-paso y x+paso.

descensoRapido
------------------
> [x, fx, steps] = descensoRapido(f, x0, max_iter)
> global precision, paso;
Aproxima la solución de f(x)=0 con el método del descenso rápido.

determinanteCramer
----------------------
> det = determinanteCramer(A)
Calcula el determinante de la matriz A desarrollando por menores.

determinanteGauss
---------------------
> det = determinanteGauss(A)
Calcula el determinante de la matriz A por su factorización LUP.

determinanteLU
-----------------
> det = determinanteLU(L, U)
Calcula el determinante de la matriz L*U, con L triangular inferior y U
triangular superior.

determinanteLUP
-------------------
> det = determinanteLUP(L, U, P)
Calcula el determinante de la matriz L\*U*P, con L triangular inferior, U
triangular superior y P permutación de filas/columnas.

determinanteP
----------------
> det = determinantePerm(P)
Calcula el determinante de una matriz P de permutación de filas/columnas.

difAproximada
----------------
> J = difAproximada(F, X)
> global paso;
Aproxima la matriz dF(X) según la pendiente entre x-paso\*e\_j y x+paso*e_j para
cada j.

factorLdeCholeski
---------------------
> L = factorLdeCholeski(A)
Calcula el factor L de Choleski de A.
<!-- TODO Buscar qué es el factor L de Choleski -->

fitMinimosCuadradosCholeski
----------------------------------
> x = fitMinimosCuadradosCholeski(A, b)
Calcula la solución de Ax=b con el método de los mínimos cuadrados de Choleski.
<!-- TODO Buscar qué es el método de los mínimos cuadrados de Choleski -->

fitMinimosCuadradosQR
--------------------------
> x = fitMinimosCuadradosQR(A, b)
Calcula la solución de Ax=b con el método QR y matrices de Householder.

gradienteApr
---------------
> gradiente = gradienteApr(F, X)
> global paso;
Calcula el gradiente de una función F : R^n -> R en X como en `difAproximada`.

gradienteConjugado
----------------------
> [x, iters, e] = gradienteConjugado(A, b, x0, prec)
Calcula la solución de Ax=b con el método del gradiente conjugado, partiendo de
la aproximación `x0` y con precisión máxima permitida `prec`, medida como
||b-Ax||/||b||. Devuelve también el número de iteraciones `iters` y la precisión
conseguida `e`.
<!-- NOTE En la versión original, solo devuelve x, y el resto lo imprime -->

gradienteConjugadoPrecondicionado
-----------------------------------------
> [x, iters, e] = gradienteConjugadoPrecondicionado(A, b, x0, C, prec)
Como `gradienteConjugado` pero con precondicionamiento dado por una matriz `C`.

GramSchmidt
--------------
> [Q, R] = GramSchmidt(A)
Obtiene una factorización QR de A po el método de Gram-Schmidt. También imprime
algo en ciertos casos...

inversaGauss
---------------
> X = inversaGauss(A)
Calcula la inversa de A por el método de Gauss (factorización LUP).

inversaGaussLUP
-------------------
> X = inversaGaussLUP(L, U, P)
Calcula la inversa de P^(-1)*L\*U, donde P es una permutación de filas, L es
triangular inferior y U es triangular superior.

inversaL
----------
> X = inversaL(L)
Calcula la inversa de una matriz triangular inferior.

inversaU
----------
> X = inversaU(U)
Calcula la inversa de una matriz triangular superior.

iter3dGaussSeidel
---------------------
> [x, k, e] = iter3dGaussSeidel(di, dp, ds, b, x0, max_iter, prec)
Si A es la matriz tridiagonal que tiene por diagonal principal el vector `dp` y
por diagonales superior e inferior `ds` y `di`, respectivamente, resuelve la
ecuación Ax=b por el método de Gauss-Seidel partiendo de una aproximación
inicial `x0`, en un máximo de `max_iter` iteraciones y buscando una precisión
`prec`, medida como ||Ax-b||/||b||. Devuelve también el número de iteraciones
`k` y la precisión obtenida `e`.

iter3dRelajacion
--------------------
> [x, k, e] = iter3dRelajacion(di, dp, ds, b, w, x0, max_iter, prec)
Como `iter3dGaussSeidel` pero con el método de relajación, con peso `w`.

iterGaussSeidel
-------------------
> [x, k, e] = iterGaussSeidel(A, b, x0, max_iter, prec)
Como `iter3dGaussSeidel` pero para matrices `A` arbitrarias.
<!-- NOTE En el original, no devuelve k y e, sino que los imprime -->

iterJacobi
------------
> [x, k, e] = iterJacobi(A, b, x0, max_iter, prec)
Como `iterGaussSeidel` pero con el método de Jacobi.

iterRelajacion
------------------
> [x, k, e] = iterRelajacion(A, b, w, x0, max_iter, prec)
Como `iterGaussSeidel` pero con el método de relajación, con peso `w`.


jacobiPropios
----------------
> [lambda, V, k, control] = jacobiPropios(A, max_iter)
> global precision;
Obtiene un vector `lambda` de aproximaciones a los valores propios y una matriz
`V` cuyas columnas son aproximaciones a los vectores propios correspondientes
con el método de Jacobi; `k` es el número de pasos, `control` es la suma de los
||A\*V(i) - lambda(i)*V(i)|| y `precision` es la máxima norma euclídea permitida
para los elementos fuera de la diagonal.

LDR
----
> [L, D, U] = LDR(A)
Obtiene la factorización LDU de la matriz no singular A.

LUdootlittle
---------------
> [L, U] = LUdootlittle(A)
Obtiene la factorización LU de Dootlittle de la matriz no singular A.

LUPGauss
----------
> [L, U, P] = LUPGauss(A)
Calcula la factorización LUP con el método de Gauss con permutaciones de filas
de la matriz A.

LUPQGauss
-----------
> [L, U, P, Q] = LUPQGauss(A)
Calcula la factorización LUPQ con el método de Gauss con permutaciones de filas
y columnas de la matriz A.

LUPQGeneral
--------------
> [L, U, P, Q, r] = LUPQGeneral(A)
Como `LUPQGauss`, pero contando el número de pasos `r`.

matrizDiagonalDominante
-----------------------------
> A = matrizDiagonalDominante(n)
Obtiene una matriz diagonal dominante de tamaño `n`, con alguna distribución.

newton
--------
> [x, fx, steps] = newton(f, df, x0, max_iter)
> global precision;
Obtiene la solución de f(x)=0 para f : R -> R por el método de Newton, donde
`df` es la derivada de `f` y `x0` es una aproximación inicial.

newtonAprox3
---------------
> [x, fx, steps] = newtonAprox3(f, x0, max_iter)
> global precision;
> global paso;
Como `newton`, pero aproxima la derivada con `derivaprox3`.

newtonV
---------
> [X, FX, steps] = newtonV(F, dF, X0, max_iter)
> global precision;
Como `newton`, para funciones vectoriales.
<!-- NOTE La original además imprime -->

newtonVop
-----------
> [X, FX, steps, ops] = newtonVop(F, dF, X0, max_iter, ev)
Como `newtonV`, pero estima el número de operaciones `ops`; `ev` es el número de
operaciones para calcular `F(X)`.

objetivo
----------
> obj = objetivo(F, X)
Calcula el valor de la función objetivo en `X` para el método del descenso
rápido con la ecuación F(X)=0.

polinomioFit2
----------------
> p = polinomioFit2(x, y, n)
Calcula un polinomio interpolador de grado `n` que a cada elemento del vector
`x` le asigna el correspondiente de `y`. El polinomio se expresa como un vector
con los coeficientes de mayor a menor grado.

potencia
----------
> [lambda, v] = potencia(A, x0, max_iter, prec)
Aproxima el valor propio de A de mayor valor absoluto y su correspondiente
vector propio por el método de la potencia, donde `prec` es el máximo
||A\*v - lambda*v|| permitido.

potenciaInvDesplazada
--------------------------
> [lambda, v] = potenciaInvDesplazada(A, lambda0, x0, max_iter, prec)
Aproxima el valor propio de A más cercano a `lambda0` y su correspondiente
vector propio por el método de la potencia.

puntofijo
-----------
> [x, steps] = puntofijo(f, x0, max_iter)
> global precision;
Usa iteración de punto fijo sobre f : R^n -> R^n partiendo de `x0` hasta que la
diferencia entre dos valores consecutivos tienen norma menor que `precision`.

puntofijoAitkenVV
---------------------
> [x, steps] = puntofijoAitkenVV(f, x0, max_iter)
> global precision;
Como `puntofijo` pero con aceleración de Aitken.

puntofijoSteffensen
------------------------
> [x, steps] = puntofijoSteffensen(f, x0, max_iter)
> global precision;
Como `puntofijo` pero con aceleración de Steffensen y para una variable.

puntofijoSteffensenVV
--------------------------
> [x, steps] = puntofijoSteffensen(f, x0, max_iter)
> global precision;
Como `puntofijo` pero con aceleración de Steffensen.

QRhouseholder
----------------
> [Q, R] = QRhouseholder(A)
Calcula la descomposición QR de `A` por el método de Householder.

QRPropios
-----------
> [lambda, V, steps, control] = QRPropios(A, max_iter)
> global precision, desplazamiento;
Aproxima los valores propios de `A` como elementos del vector `lambda` y sus
correspondientes vectores propios como las columnas de la matriz `V`, donde
`steps` es el número de iteraciones realizadas y `control` es la precisión
obtenida, que se mide por la norma de la parte bajo la diagonal de la matriz que
tiende a una triangular superior.

QRTRid
--------
> [Q, R] = QRTRid(T)
Obtiene la factorización QR de una matriz tridiagonal por el método de
Burden-Faires.

quasiNewtonBoyrenV
-----------------------
> [X, FX, steps] = quasiNewtonBoyrenV(F, dFX0, X0, max_iter)
Aproxima la solución de F(X)=0 con el método de Boyren, donde dfX0=dF(X0).

quasiNewtonBoyrenVop
-------------------------
> [X, FX, steps, ops] = quasiNewtonBoyrenVop(F, dFX0, X0, max_iter, ev)
Como `quasiNewtonBoyrenV` pero estimando el número de operaciones en `ops`,
siendo `ev` el número de operaciones para calcular `F(X)`.

residuo3dconstsyme
----------------------
> norm_res = residuo3dconstsyme(D, x, b)
<!-- TODO -->

Rhouseholder
---------------
> R = Rhouseholder(A)
Como `QRhouseholder` pero solo calcula `R`.

solve3dconstsyme
--------------------
> sol = solve3dconstsyme(D, b)
<!-- TODO -->

solveCholeski
----------------
> x = solveCholeski(A, b)
Calcula la solución de Ax=b por el método de Choleski.
<!-- TODO Buscar qué es el método de Choleski. -->

solveCholeski_L
-------------------
> x = solveCholeski(L, b)
Calcula la solución de LL'x=b.

solveCramer
--------------
> x = solveCramer(A, b)
Calcula la solución de Ax=b por la regla de Cramer.

solveGaussLUP
----------------
> x = solveGaussLUP(L, U, P, b)
Calcula la solución de LUx=Pb con `L` triangular inferior, `U` triangular
superior y `P` matriz de permutación de filas/columnas.

solveGaussParcial
---------------------
> x = solveGaussParcial(A, b)
Calcula la solución de Ax=b por la factorización LUP de Gauss.

solveL
-------
> x = solveL(L, b)
Calcula la solución de Lx=b con `L` triangular inferior.

solveLU
---------
> x = solveLU(L, U, b)
Calcula la solución de LUx=b con `L` triangular inferior y `U` triangular
superior.

solveQR
---------
> x = solveQR(Q, R, b)
Calcula la solución de QRx=b con `Q` ortogonal y `R` triangular superior.

solveU
--------
> x = solveU(U, b)
Calcula la solución de Ux=b con `U` triangular superior.

SPD
----
> SPD = spdMat(n)
Obtiene una matriz SPD aleatoria, con una cierta distribución.

symmetricMat
---------------
> S = symmetricMat(n)
Obtiene una matriz simétrica aleatoria, con una cierta distribución.

tridQHouseholder
--------------------
> [Q, T] = tridQHouseholder(A)
Calcula la factorización QR de una matriz `A` tridiagonal simétrica.
