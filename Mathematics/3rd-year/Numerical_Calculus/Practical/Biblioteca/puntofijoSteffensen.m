function x=puntofijoSteffensen(f,x0,errorParada,maxIteraciones)
% Algoritmo para la determinacion de puntos fijos.
%
%  Entrada:    - f es la funcion a la cual le buscamos un punto fijo.
%
%              - x0 es el punto inicial de la iteracion a punto fijo.
%
%              - errorParada es el error maximo que debe satisfacer la solucion, 
%                que puede ser relativo o absoluto, segun venga especificado
%                por la variable global "tipoerror", que puede ser 'relativo' 
%                o 'absoluto' (por defecto se toma 'relativo').
%
%              - maxIteraciones es el numero maximo de iteraciones.
% 
%  Salida:     - x es el valor encontrado que satisface alguno de los criterios
%                de terminacion.
%
global tipoerror 

disp(' ');
disp('Metodo iterativo a Punto Fijo de Steffensen');
disp(' ');

x=x0;
for i=1:maxIteraciones    
    x=f(x);
    errabs=abs(x-x0);
    errrel=errabs/(abs(x)+eps);  % Se suma EPS para no dividir por cero cuando x=0
    if strcmp(tipoerror,'absoluto')
        disp(['x' int2str(i) ' = ' mat2str(x) '    error abs= ' mat2str(eval(num2str(errabs,2)))]);
        if errabs<=errorParada
            return
        end
    else
    disp(['x' int2str(i) ' = ' mat2str(x) '    error rel=  ' mat2str(eval(num2str(errrel,2)))]);
    if errrel<=errorParada
        return
    end
  end
  x1=f(x); %f(f(x0))
    x= x0 - (x0 - x)^2/(x1-2*x+x0);
    x0=x;
end
disp(['La iteracion de puntofijo no converge en ' mat2str(maxIteraciones) ' iteraciones ']);

error('La iteracion de puntofijo no converge ');
