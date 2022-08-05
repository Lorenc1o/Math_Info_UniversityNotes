function RC = jcom_custom(fname,caliQ)

% jcom_custom: Compresion de imágenes basada en las tablas customizadas

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
% Salidas:
%  RC: Relacion de compresion

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Función jcom_custom:');
end

% Instante inicial
tc=cputime;

% Lee archivo de imagen
% Convierte a espacio de color YCbCr
% Amplia dimensiones a multiplos de 8
%  X: Matriz original de la imagen en espacio RGB
%  Xamp: Matriz ampliada de la imagen en espacio YCbCr
[X, Xamp, tipo, m, n, mamp, namp, TO]=imlee(fname);

% Calcula DCT bidimensional en bloques de 8 x 8 pixeles
Xtrans = imdct(Xamp);

% Cuantizacion de coeficientes
Xlab=quantmat(Xtrans, caliQ);

% Genera un scan por cada componente de color
%  Cada scan es una matriz mamp x namp
%  Cada bloque se reordena en zigzag
XScan=scan(Xlab);

% Codifica los tres scans, usando Huffman custom
[CodedY, CodedCb, CodedCr,BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC, HUFFVAL_Y_AC, BITS_C_DC,HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC] = EncodeScans_custom(XScan);

%Generamos el nombre del archivo comprimido
[pathstr,nomb,ext] = fileparts(fname);
nombrecomp = strcat(nomb, '.huc');

% Creamos el archivo
fid = fopen(nombrecomp,'w');

% Transformamos las tablas obtenidas a B
% (con bits2bytes) y las codificamos:
%CodedY
[SBYTES_Y, ULTL_Y]=bits2bytes(CodedY);
U_LENS_Y=uint32(length(SBYTES_Y));
U_ULTL_Y=uint32(ULTL_Y); 
U_SBYTES_Y=uint32(SBYTES_Y);

%CodedCB
[SBYTES_CB, ULTL_CB]=bits2bytes(CodedCb);
U_LENS_CB=uint32(length(SBYTES_CB));
U_ULTL_CB=uint32(ULTL_CB); 
U_SBYTES_CB=uint32(SBYTES_CB);

%CodedCR
[SBYTES_CR, ULTL_CR]=bits2bytes(CodedCr);
U_LENS_CR=uint32(length(SBYTES_CR));
U_ULTL_CR=uint32(ULTL_CR); 
U_SBYTES_CR=uint32(SBYTES_CR);

% Para poder descomprimir correctamente debemos codificar las tablas de
% Bits y Huffval que hemos generado al aplicar el Huffman custom 

% Luminancia:
U_LEN_BITS_Y_DC=uint32(length(BITS_Y_DC)); 
U_BITS_Y_DC=uint32(BITS_Y_DC); 
U_LEN_HUFFVAL_Y_DC=uint32(length(HUFFVAL_Y_DC));
U_HUFFVAL_Y_DC=uint32(HUFFVAL_Y_DC); 

U_LEN_BITS_Y_AC=uint32(length(BITS_Y_AC)); 
U_BITS_Y_AC=uint32(BITS_Y_AC); 
U_LEN_HUFFVAL_Y_AC=uint32(length(HUFFVAL_Y_AC));
U_HUFFVAL_Y_AC=uint32(HUFFVAL_Y_AC); 

% Crominancia:
U_LEN_BITS_C_DC=uint32(length(BITS_C_DC)); 
U_BITS_C_DC=uint32(BITS_C_DC); 
U_LEN_HUFFVAL_C_DC=uint32(length(HUFFVAL_C_DC));
U_HUFFVAL_C_DC=uint32(HUFFVAL_C_DC); 

U_LEN_BITS_C_AC=uint32(length(BITS_C_AC)); 
U_BITS_C_AC=uint32(BITS_C_AC); 
U_LEN_HUFFVAL_C_AC=uint32(length(HUFFVAL_C_AC));
U_HUFFVAL_C_AC=uint32(HUFFVAL_C_AC); 

% Codificamos  m, n, mamp, namp y CaliQ
U_M=uint32(m);
U_MAMP=uint32(mamp);  
U_N=uint32(n); 
U_NAMP=uint32(namp); 
U_CALQ=uint32(caliQ);


% Escribimos una a una las variables en el archivo 
fwrite(fid,U_N,'uint32'); 
fwrite(fid,U_NAMP,'uint32'); 
fwrite(fid,U_M,'uint32'); 
fwrite(fid,U_MAMP,'uint32'); 
fwrite(fid,U_CALQ,'uint32');

%tablas de Bits y Huffval
fwrite(fid,U_LEN_BITS_Y_DC,'uint32'); 
fwrite(fid,U_BITS_Y_DC,'uint32'); 
fwrite(fid,U_LEN_HUFFVAL_Y_DC,'uint32'); 
fwrite(fid,U_HUFFVAL_Y_DC,'uint32');

fwrite(fid,U_LEN_BITS_Y_AC,'uint32'); 
fwrite(fid,U_BITS_Y_AC,'uint32'); 
fwrite(fid,U_LEN_HUFFVAL_Y_AC,'uint32'); 
fwrite(fid,U_HUFFVAL_Y_AC,'uint32');

fwrite(fid,U_LEN_BITS_C_DC,'uint32'); 
fwrite(fid,U_BITS_C_DC,'uint32'); 
fwrite(fid,U_LEN_HUFFVAL_C_DC,'uint32'); 
fwrite(fid,U_HUFFVAL_C_DC,'uint32');

fwrite(fid,U_LEN_BITS_C_AC,'uint32'); 
fwrite(fid,U_BITS_C_AC,'uint32'); 
fwrite(fid,U_LEN_HUFFVAL_C_AC,'uint32'); 
fwrite(fid,U_HUFFVAL_C_AC,'uint32');

%CodedY
fwrite(fid,U_LENS_Y,'uint32'); 
fwrite(fid,U_ULTL_Y,'uint32'); 
fwrite(fid,U_SBYTES_Y,'uint32'); 

% CodedCb
fwrite(fid,U_LENS_CB,'uint32'); 
fwrite(fid,U_ULTL_CB,'uint32'); 
fwrite(fid,U_SBYTES_CB,'uint32'); 

% CodedCr
fwrite(fid,U_LENS_CR,'uint32'); 
fwrite(fid,U_ULTL_CR,'uint32'); 
fwrite(fid,U_SBYTES_CR,'uint32'); 

fclose(fid);

% Calculamos ahora la relación de compresión
% Es la suma de los tamaños de los componentes de la imagen +1 byte por
% cada campo
%Tam_cabecera = suma de los datos requeridos para descompresion
TAM_CAB=length(U_CALQ)+ length(U_MAMP)+length(U_NAMP)+length(U_M)+length(U_N);
TAM_CAB= TAM_CAB + length(U_LEN_BITS_Y_DC)+length(U_BITS_Y_DC)+length(U_LEN_HUFFVAL_Y_DC)+length(U_HUFFVAL_Y_DC);
TAM_CAB= TAM_CAB + length(U_LEN_BITS_Y_AC)+length(U_BITS_Y_AC)+length(U_LEN_HUFFVAL_Y_AC)+length(U_HUFFVAL_Y_AC);
TAM_CAB= TAM_CAB + length(U_LEN_BITS_C_DC)+length(U_BITS_C_DC)+length(U_LEN_HUFFVAL_C_DC)+length(U_HUFFVAL_C_DC);
TAM_CAB= TAM_CAB + length(U_LEN_BITS_C_AC)+length(U_BITS_C_AC)+length(U_LEN_HUFFVAL_C_AC)+length(U_HUFFVAL_C_AC);
TAM_DAT=length(U_SBYTES_Y)+ length(U_SBYTES_CB)+length(U_SBYTES_CR);
TC = TAM_CAB + TAM_DAT;
RC = 100* ((TO-TC)/TO);

e=cputime-tc;

if disptext
   disp(sprintf('%s %s', 'Nombre del archivo comprimido:', nombrecomp));
   disp(sprintf('%s %d %s %d', 'Tamaño original de la imagen  =', TO, 'Tamaño comprimido de la imagen =', TC));
   disp(sprintf('%s %2.2f %s', 'RC imagen =', RC, '%.'));
   disp('Componentes codificadas en binario');
   disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
   disp(sprintf('%s %d %s %d','Longitud de BITS_Y_DC:', length(BITS_Y_DC), ', longitud de BITS_Y_AC:', length(BITS_Y_AC)));
   disp('Terminado EncodeScans_custom');
end




