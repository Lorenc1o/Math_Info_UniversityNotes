%PRÁCTICA 6

disp("Tarea 1") %Tarea 1
disp(" ")

pob1 = [49, 1045, 297, 1000, 265, 895, 412, 996, 231, 885, 656, 1256];
long1 = length(pob1);
tiempo1 = 0 : long1 - 1;

pob2 = [99, 1162, 179, 2364, 129, 1175, 451, 1724, 559, 4443, ...
    436, 2390, 333, 1705, 278, 1824, 1162, 1440, 352];
long2 = length(pob2);
tiempo2 = 0 : long2 - 1;

figure(1)

subplot(2, 1, 1)
hold on
plot(tiempo1, pob1, 'o-b')
title('gorgojo del frijol adsuki') 
xlabel('generaciones')
ylabel('individuos')
hold off

subplot(2, 1, 2) 
hold on
plot(1969 + tiempo2, pob2, 'o-r')
title('pulgón del sicomoro')
xlabel('años')
ylabel('individuos')
hold off

% En ambos casos se observa una oscilación de los datos, también vista en
% el experimento de la carcoma dentada, pero no parece que haya
% convergencia a un equilibrio.


disp("Tarea 2") %Tarea 2
disp(" ")

% Como P_(n + 1) = P_n e^(rho(1 - P_n/K), aproximamos por regresión lineal
%   c_n = log(P_(n + 1)/P_n) = -rho/K P_n + rho = m P_n + rho:

pini1 = pob1(1 : long1 - 1);
pfin1 = pob1(2 : long1);
c = log(pfin1./pini1);
coef = polyfit(pini1, c, 1);

% Como coef = [m, rho] y m = -rho/K,  se tiene:
%   rho = coef(2)
%   K = -rho/m = -coef(2)/coef(1)

rho0 = coef(2);
K0 = -coef(2)/coef(1);
disp(rho0)
disp(K0)
syms P;
C(P) = P*exp(rho0*(1 - P/K0));

% Comparamos los datos y el modelo, tomando [0, max(pob1)] como intervalo 
% donde representar la función. Se observa que la aproximación no es
% óptima.

figure(2)
hold on
plot(pini1, pfin1, 'ob')
fplot(C, [0, max(pob1)], 'r')
fplot(P, [0, max(pob1)], '--k')
legend('datos experimentales', 'modelo', 'Location', 'northeast')
title('El modelo de Ricker para el gorgojo del frijol adsuki (I)')
xlabel('P')
ylabel('C(P) = P e^{rho(1 - P/K)}')
hold off


disp("Tarea 3") %Tarea 3
disp(" ")

% Aplicamos mínimos cuadrados sin linealizar los datos y tomando como
% vector inicial para la función de minimización el formado por los
% parámetros de la tarea 2 y comprobamos que la aproximación es mejor que
% con los datos previos:

M = @(z) sum( (pini1.*exp(z(1)*(1 - pini1/z(2))) - pfin1).^2 );
zmin = fminsearch(M, [rho0, K0]);
disp(M([rho0, K0]))
disp(M(zmin))

% Volvemos a representar los datos para la función modelo mejor ajustada,
% añadiendo diagramas de telaraña (30 iteraciones) partiendo de P_0 = 49 
% y de un punto aleatoriamente elegido.

rho = zmin(1);
K = zmin(2);
disp(rho)
disp(K)
C(P) = P*exp(rho*(1 - P/K));

T = telarana(C, 49, 30);
Prand = max(pob1)*rand;
Trand = telarana(C, Prand, 30);

figure(3)
hold on
plot(pini1, pfin1, 'ob')
fplot(C, [0, max(pob1)], 'r')
plot(T(1, :), T(2, :), 'k')
plot(Trand(1, :), Trand(2, :), 'g')
fplot(P, [0, max(pob1)], '--k')
legend('datos experimentales', 'modelo', 'Location', 'northwest')
title('El modelo de Ricker para el gorgojo del frijol adsuki (II)')
xlabel('P')
ylabel('C(P) = P e^{rho(1 - P/K)}')
hold off

% El modelo pronostica un comportamiento cíclico a largo plazo. Nótese que 
% rho = 2.2412 y por tanto el punto fijo K = 708.0523 es inestable. Los  
% los dos puntos v, w hacia donde se produce la aproximación no dependen 
% del punto de inicio y forman una órbita 2-periódica, es decir, C(v) = w y
% C(w) = v. La órbita 2-periódica {v, w} es estable:

I = iteracion(C, 49, 30);
Irand = iteracion(C, Prand, 30);

v = I(30);
w = I(31);
vrand = Irand(30);
wrand = Irand(31);
DC = diff(C);

format shortG
disp(double(v))
disp(double(w))
disp(double(vrand))
disp(double(wrand))
disp(double(C(v)))
disp(double(C(w)))
disp(double(abs(DC(v)*DC(w))))


disp("Tarea 4") %Tarea 4
disp(" ")

% Reproducimos los cálculos de las tareas anteriores con los nuevos datos
% para obtener los parámetros rho y K que proporcionan el mejor ajuste.

pini2 = pob2(1 : long2 - 1);
pfin2 = pob2(2 : long2);
c = log(pfin2./pini2);
coef = polyfit(pini2, c, 1);
rho0 = coef(2);
K0 = -coef(2)/coef(1);
M = @(z) sum( (pini2.*exp(z(1)*(1 - pini2/z(2))) - pfin2).^2 );
zmin = fminsearch(M, [rho0, K0]);
disp(M([rho0, K0]))
disp(M(zmin))
rho = zmin(1);
disp(rho)
K = zmin(2);
disp(K)
s = exp(rho); % usaremos este índice de crecimiento en la tarea 5
disp(s)
% Ahora buscamos la órbita 2-periódica de la función:

C(P) = P*exp(rho*(1 - P/K));
C2(P) = C(C(P));
DC = diff(C);

% Dibujamos la gráfica de C^2(P) para hacernos una idea aproximada de la
% ubicación de la órbita 2-periódica:

figure(4)
hold on
fplot(C, [0, max(pob2)], 'r')
fplot(C2, [0, max(pob2)], 'm')
fplot(P, [0, max(pob2)], '--k')
legend('C', 'C2', 'Location', 'northeast')
title('El modelo de Ricker para el pulgón del sicomoro (I)')
xlabel('P')
ylabel('C(P) = P e^{rho(1 - P/K)} y C^2(P)')
hold off

% Calculamos la órbita numéricamente y verificamos su inestabiliad:

v = vpasolve(C2(P) == P, P, [200, 300]); %OJO: el intervalo [0, 500] no sirve
w = vpasolve(C2(P) == P, P, [2000, 2500]);
disp(double(v))
disp(double(w))
disp(double(C(v)))
disp(double(C(w)))
disp(double(abs(DC(v)*DC(w))))

% Finalmente evidenciamos la s.r.c.i. estudiando la dinámica a partir de
% una condición inicial elegida al azar y otra muy próxima a ella: 

Prand = 2500*rand;
epsilon = 0.1;
Trand = telarana(C, Prand, 30);
Teps = telarana(C, Prand + epsilon, 30);

figure(5)
hold on
plot(pini2, pfin2, 'ob')
fplot(C, [0, 2500], 'r')
plot(Trand(1, :), Trand(2, :), 'k')
plot(Teps(1, :), Teps(2, :), 'g')
fplot(P, [0, 2500], '--k')
axis([0, 2500, 0, 2500])
legend('datos experimentales', 'modelo', 'Location', 'north')
title('El modelo de Ricker para el pulgón del sicomoro (II)')
xlabel('P')
ylabel('C(P) = P e^{rho(1 - P/K)}')
hold off


disp("Tarea 5") %Tarea 5
disp(" ")

% Dibujamos el diagrama de bifurcaciones del modelo logístico, primero en
% general y luego cerca de s = 4:

logistica = @(x, s) s*x*(1 - x);
puntos = bifurcacion(logistica, [0, 1], [1, 4]);

figure(6)
hold on
plot(puntos(1, :), puntos(2, :),'.k', 'MarkerSize',1)
title('Diagrama de bifurcaciones del modelo logístico')
xlabel('parámetro s')
ylabel('intervalo I')
hold off

puntos = bifurcacion(logistica, [0, 1], [3.95, 4]);

figure(7)
hold on
plot(puntos(1, :), puntos(2, :),'k.', 'MarkerSize',1)
title('Diagrama de bifurcaciones del modelo logístico (cerca de s=4)')
xlabel('parámetro s')
ylabel('intervalo I')
hold off

% Ahora el del modelo de Ricker, primero en la zona de parámetros donde
% tiene lugar la cascada de bifurcaciones de doble periodo y luego desde
% del parámetro s = 15.752... correspondiente a los datos del pulgón del
% sicomoro:

ricker = @(x, s) s*x*exp(-x);
puntos = bifurcacion(ricker, [0, 1], [5, 20]);

figure(8)
hold on
plot(puntos(1, :), puntos(2, :),'k.', 'MarkerSize',1)
title('Diagrama de bifurcaciones del modelo de Ricker')
xlabel('parámetro s')
ylabel('intervalo I')
hold off

puntos = bifurcacion(ricker, [0, 1], [s - 0.05, s + 0.05]);

figure(9)
hold on
plot(puntos(1, :), puntos(2, :),'k.', 'MarkerSize',1)
title('Diagrama de bifurcaciones del modelo de Ricker (cerca de s=15.752...)')
xlabel('parámetro s')
ylabel('intervalo I')
hold off

