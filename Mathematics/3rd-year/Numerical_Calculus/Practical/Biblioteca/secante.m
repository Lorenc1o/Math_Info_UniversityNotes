function x=secante(f,x0,x1,errorParada,maxIteraciones)
% Algoritmo para la determinacion de ceros de funciones por 
% el metodo de la secante.
%
%  Entrada:    - f es la funcion a la cual le buscamos un cero.
%
%              - x0 y x1 son las aproximaciones iniciales del cero.
%
%              - errorParada es el error maximo que debe satisfacer la solucion. 
%                Se toma como error abs(x_n-x_(n-1)).
%             
%              - maxIteraciones es el numero maximo de iteraciones.
% 
%  Salida:     - x es el valor encontrado que satisface alguno 
%                de los criterios de terminacion.
%

disp(' ');
disp('Calculo de ceros mediante el Metodo de la Secante');
disp(' ');

for i=1:maxIteraciones 
    x=x1-f(x1)*(x1-x0)/(f(x1)-f(x0));
        errabs=abs(x-x1);
    disp(['x' int2str(i) ' = ' mat2str(x) '    error absoluto= '  mat2str(eval(num2str(errabs,2)))]);
    if errabs<errorParada
       return
    end
    x0=x1;
    x1=x;
end
disp(['La iteracion de la secante no converge en ' mat2str(maxIteraciones) ' iteraciones ']);

error('La iteracion de la secante no converge ');