function [Xrec, nombrecomp]=imescribe(Xamprec,m,n, fname)

% Escribe archivo de imagen BMP <fname>
% Convierte de espacio de color YCbCr a RGB 
% Reduce a dimensiones originales
% Devuelve matriz reconstruida en RGB

% Entradas:
%  Xamprec: Matriz de imagen en espacio YCbCr y dimensiones ampliadas
%  m: Alto original de la imagen (nº de filas)
%  n: Ancho original de la imagen (nº de columnas)
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
% Salidas:
%  Xrec: Matriz de imagen original reconstruida en RGB en formato truecolor (uint8)
%  nombrecomp: Nombre del archivo guardado

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion imescribe:');
end

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
Xrec=uint8(Xrecrd);

% Repone el tamaño original
Xrec=Xrec(1:m,1:n, 1:3);

% Genera nombre archivo descomprimido <nombre>_des.bmp
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'_des','.bmp');

% Guarda archivo descomprimido
imwrite(Xrec,nombrecomp,'bmp')

if disptext
    disp(sprintf('%s %1.0f %s %1.0f', 'Imagen reducida a tamaño original:', n,'x',m));
    disp('Imagen convertida a Espacio de Color RGB');
    disp(sprintf('%s %s', 'Archivo guardado:', nombrecomp));
    disp('Terminado imescribe');    
    disp('--------------------------------------------------');
end
