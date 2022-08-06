% Funcion que calcula el spline 
% Entradas:   
%            - x       = vector que contiene las abscisas de los puntos a interpolar (nodos)
%            - a,b,c,d = coeficientes del spline
%            
% Salida: 
%            - Tabla con los intervalos y el spline en cada intervalo
%   
function S=splineTabla(x,a,b,c,d)
n=length(x);
disp('  Intervalo                    Spline ')
disp('-------------------------------------------------------------------------------------------------')  
for i=1:n-1
S=[num2str(a(i)) '+' num2str(b(i)) '*(x-' num2str(x(i)) ')+' num2str(c(i)) '*(x-' num2str(x(i)) ')^2+ ' num2str(d(i)) '*(x-' num2str(x(i)) ')^3'];
A=[x(i),x(i+1)];
fprintf('[%+5.2e %+5.2e]\t %s\n\n',A,S)
end
disp('-------------------------------------------------------------------------------------------------')   
