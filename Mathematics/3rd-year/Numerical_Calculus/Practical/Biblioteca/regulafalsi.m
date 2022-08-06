function x=regulafalsi(f,a,b,errorParada,tol,maxIteraciones)
% Algoritmo para la determinacion de ceros de funciones por 
% el metodo de regula falsi.
%
%  Entrada:    - f es la funcion a la cual le buscamos un cero.
%
%              - a y b son los extremos del intervalo en que se encuentra el cero.
%                Si f(a)*f(b)>0, el programa da un mensaje de error y se detiene.
%
%              - errorParada es el error que debe satisfacer la solucion. 
%                Se toma como error abs(x_n-x_(n-1)).
%
%              - tol es la tolerancia que le permitimos. El algoritmo terminara
%                cuando |f(x)| sea menor que esa tolerancia.
%             
%              - maxIteraciones es el numero maximo de iteraciones.
% 
%  Salida:     - x es el valor encontrado que satisface alguno 
%                de los criterios de terminacion.
%

disp(' ');
disp('Calculo de ceros mediante el Metodo de regula falsi');
disp(' ');

if f(a)*f(b)>0
    disp('La funcion no cambia de signo en el intervalo especificado');
    error('La funcion no cambia de signo en el intervalo especificado');
end
for i=1:maxIteraciones    
    x=b-f(b)*(b-a)/(f(b)-f(a));
    errabs=max(abs(x-a),abs(x-b));
    if f(x)==0,
        return
    end
        disp(['x' int2str(i) ' = ' mat2str(x) '    error abs= '  mat2str(eval(num2str(errabs,2))) '        tol= '  mat2str(eval(num2str(abs(f(x)),2)))]);
        if errabs<errorParada
            return
        end
        if abs(f(x))<=tol
            return
        end
    if f(b)*f(x)>0
        b=x;
    else
        a=x;
    end
end
disp(['La iteracion de la regulafalsi no converge en ' mat2str(maxIteraciones) ' iteraciones ']);

error('La iteracion de la regulafalsi no converge ');