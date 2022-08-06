function s=simpson(f,a,b,N)
%
%  Entrada:    - f es la funcion a integrar, introducida como una 
%                cadena de caracteres.
%
%              - a y b son los extremos del intervalo de integracion.
%
%              - N es el numero par maximo de subintervalos en que 
%                se divide el intervalo original.
%
%
%  Salida:     - s es el valor de la integral encontrado.
%              
%              
%
disp(' ');
disp('Calculo de la integral mediante el Metodo de Simpson compuesto');
disp(' ');
disp(['Funcion que se integra :  f(x) = ' f ]); 
disp(['Intervalo de integracion : [' mat2str(a) ',' mat2str(b) ']']);
disp(['Numeros de subintervalos: ' mat2str(N) ]);
disp(' ');

% Calculo de la integral por el metodo de Simpson compuesto
x=a;
fa=eval(f);
x=b;
fb=eval(f);

h=(b-a)/N;
s1=0; 
for i=1:(N/2);
   x=a+(2*i-1)*h;
   s1= s1 + eval(f);
end
s2=0;
for i=1:(N/2-1);
   x=a+(2*i)*h;
   s2= s2+eval(f)
end
s=(h/3)*(fa+4*s1+2*s2+fb);
disp(['La integral de ' f  ' entre ' mat2str(a) ' y ' mat2str(b) ' es: ' mat2str(s)])