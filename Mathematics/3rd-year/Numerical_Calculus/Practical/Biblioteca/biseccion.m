function x=biseccion(f,a,b,errorParada)
% Algoritmo para la determinacion de ceros de funciones por el metodo de la biseccion.
%
%  Entrada:    - f es la funcion a la cual le buscamos un cero.
%
%              - a y b son los extremos del intervalo en que se encuentra el cero.
%                Si f(a)*f(b)>0, el programa da un mensaje de error y se detiene.
%
%              - errorParada es el error absoluto maximo que debe satisfacer 
%                la solucion.
% 
%  Salida:     - x es el valor encontrado del cero.
%

disp(' ');
disp('Calculo de ceros mediante el Metodo de la Biseccion');
disp(' ');
if f(a)*f(b)>0
    error('La funcion no cambia de signo en el intervalo especificado');
    return
end
max1=ceil((log(b-a)-log(errorParada))/log(2));
for i=1:max1
    x=(a+b)/2;
    errabs=abs(x-a);
    if f(x)==0 
        return
    end
        disp(['x' int2str(i) ' = ' mat2str(x) '    errorParada abs= ' mat2str(eval(mat2str(errabs,3)))]);
        if errabs<errorParada
            return
        end
    if f(x)*f(a)<0
        b=x;
    else
        a=x;
    end
end
error('La iteracion no converge');



