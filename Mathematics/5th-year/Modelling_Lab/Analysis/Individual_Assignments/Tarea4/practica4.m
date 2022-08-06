%PR�CTICA 4

disp("Tarea 1") %Tarea 1
disp(" ")

pob = [63, 147, 285, 345, 361, 405, 471, 420, 430, 420, 475, 435];
long = length(pob);
quincena = 0 : long - 1;

figure(1)
hold on
plot(quincena, pob, 'o--b')
title('Evoluci�n quincenal de la carcoma dentada en laboratorio')
xlabel('quincena')
ylabel('individuos')
hold off

% La gr�fica sugiere una estabilizaci�n de la poblaci�n en torno a 400-500
% individuos, con peque�as oscilaciones alrededor de esa cantidad.


disp("Tarea 2") %Tarea 2
disp(" ")

% Aproximamos c_n = -r/K P_n + r + 1 = m P_n + s por regresi�n lineal:

pini = pob(1 : long - 1);
pfin = pob(2 : long);
c = pfin./pini;
coef = polyfit(pini, c, 1);
disp(coef)

% Como coef = [m, s] y m = -r/K, r + 1 = s, se tiene:
%   r = s - 1 = coef(2) - 1
%   K = -r/m = (1 - coef(2))/coef(1)

r = coef(2) - 1;
disp(r)
K = (1 - coef(2))/coef(1);
disp(K)

% Los valores de mejor aproximaci�n son por tanto:
%   r = 1.3953
%   K = 423.3975


disp("Tarea 3") %Tarea 3
disp(" ")

syms P;
r = 1.3953;
K = 423.3975;
L(P) = P*(1 + r*(1 - P/K));

% Comparamos los datos experimentales con los pronosticados por el modelo:

figure(2)
hold on
plot(quincena, pob, 'o--b')
plot(quincena, iteracion(L, 63, 11), 'o--r')
legend('datos experimentales', 'modelo', 'Location', 'south')
title('Datos experimentales vs. modelo')
xlabel('quincena')
ylabel('individuos')
hold off

% Presentaci�n alternativa de los datos anteriores con los diagramas de
% telara�a partiendo de P_0 = 63 y de un punto aleatoriamente elegido:

T = telarana(L, 63, 11);
Trand = telarana(L, 600*rand, 11);

figure(3)
hold on
plot(pini, pfin, 'ob')
fplot(L, [0, 600], 'r')
plot(T(1, :), T(2, :), 'k')
plot(Trand(1, :), Trand(2, :), 'g')
fplot(P, [0, 600], '--k')
legend('datos experimentales', 'modelo', 'telara�a para P_0 = 63', ...
    'telara�a para P_0 aleatorio', 'Location', 'northwest')
title('El modelo log�stico discreto de poblaciones')
xlabel('P')
ylabel('L(P) = P(1 + r(1 - P/K))')
hold off

% El modelo pronostica por tanto convergencia hacia el punto fijo positivo
% de L, es decir, a K = 423.3975, en consonancia con nuestra conjetura.

disp("Tarea 4") %Tarea 4
disp(" ")

% Supongamos que a < u, f(u) = u, y x < f(x) <= u para todo x en (a, u). 
% Sea x_0 en (a, u] y probemos que la soluci�n (x_n)_n con condici�n 
% inicial x_0 converge a u. Observemos que 
%   a< x_0 <= f(x_0) = x_1 <= u
% y en general, razonando por inducci�n, deducimos que la soluci�n es
% creciente y est� contenida en (a, u]. Por ser una sucesi�n creciente y
% acotada superiormente tendr� l�mite v, que pertenecer� a (a, u] y ser� un
% punto fijo de f por lo comentado en el p�rrafo anterior. Ahora bien, la
% condici�n x < f(x) impide la existencia de puntos fijos en (a, u). Por
% tanto, v = u como quer�amos demostrar.

% El enunciado alternativo, de demostraci�n similar, ser�a: si u < b, 
% f(u) = u, y u <= f(x) < x para todo x en (u, b), entonces todas las
% soluciones con condiciones iniciales en [u, b) convergen a u.


disp("Tarea 5") %Tarea 5
disp(" ")

syms P r K;
L(P) = P*(1 + r*(1 - P/K));

% Calculamos M y L(M/2) en funci�n de r y k:

assume (P > 0 & r > 0 & K > 0);
M = solve(L(P) == 0, P);
disp(M)
disp(simplify(L(M/2)))

% Debe tenerse 
%   K(r + 1)^2/(4r) <= K(r + 1)/r,
% o lo que es lo mismo
%   (r + 1)/4 <= 1,
% de donde 
%   r <= 3 = rmax
% que no depende de K.

% A continuaci�n verificamos las tres condiciones del teorema de
% Allwright-Singer. 

% La condici�n (AS1) es inmediata porque K es el �nico punto fijo positivo
% de L y L'(0) > 1:

DL = diff(L);
disp(DL(0))

% La condici�n (AS2) es obvia porque $L$ es una par�bola. Comprobamos que
% (AS3) tambi�n se cumple calculando la derivada schwarziana:

disp(simplify(diff(L, 3)/diff(L) - (3/2)*(diff(L, 2)/diff(L))^2))

% Finalmente calculamos L'(K) para caracterizar la estabilidad:

disp(DL(K))

% Como DL(K) = 1 - r y r > 0, tendemos estabilidad si 0 < r < 2. En
% particular es lo que ocurrira para nuestro modelo ya que r = 1.3953.


disp("Tarea 6") %Tarea 6
disp(" ")

% Como antes, la condici�n (AS1) es inmediata porque K es el �nico punto 
% fijo positivo de C y C'(0) > 1:

syms P rho K;
C(P) = P*exp(rho*(1 - P/K));
DC = diff(C);
disp(DC(0))

% (AS2) tambi�n se cumple porque f' tiene un �nico cero, que es un maximo
% porque f(0)=0 y f(P)-> 0 cuando P -> +infinito: 

assume(rho > 0 & K > 0);
disp(solve(DC(P) == 0, P))

% Finalmente la derivada schwarziana es negativa porque 
%   6K^2 - 4KP rho + P^2 rho^2 > 4K^2 - 4KP rho + P^2 rho^2 
%       = (2K - P rho)^2 >= 0,
% lo que proporciona (AS3):

disp(simplify(diff(C, 3)/diff(C) - (3/2)*(diff(C, 2)/diff(C))^2))

% Finalmente calculamos C'(K) para caracterizar la estabilidad:

disp(DC(K))

% Como DC(K) = 1 - rho y rho > 0, tendemos estabilidad (y atracci�n 
% global) si 0 < rho < 2. Al igual que ocurre con el modelo log�stico, el 
% valor de K no influye en la estabilidad.
