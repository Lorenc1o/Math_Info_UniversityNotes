function s=trapecios(f,a,b,N)
%
%  Entrada:    - f es la funcion a integrar, introducida como una 
%                cadena de caracteres.
%
%              - a y b son los extremos del intervalo de integracion.
% 
%              - N es el numero de subintervalos en que se divide el
%                intervalo inicial.
%
%  Salida:     - S es el valor de la integral encontrado.
%              
%     
%

disp(' ');
disp('Calculo de la integral mediante el Metodo de los trapecios compuesto');
disp(' ');
disp(['Funcion que se integra :  f(x) = ' f ]); 
disp(['Intervalo de integracion : [' mat2str(a) ',' mat2str(b) ']']);
disp(['Numeros de subintervalos: ' mat2str(N) ]);
disp(' ');


% Calculo de la integral mediante el metodo de los trapecios compuesto.

x=a;
fa=eval(f);
x=b;
fb=eval(f);

h=(b-a)/N;
s=0; 
for i=1:(N-1);
    x=a+i*h;
    s=s+eval(f);
end
s=h/2*(fa+2*s+fb);


disp(['La integral de ' f  ' entre ' mat2str(a) ' y ' mat2str(b) ' es: ' mat2str(s)])