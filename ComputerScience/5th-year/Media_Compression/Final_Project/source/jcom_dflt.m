function RC = jcom_dflt(fname, caliQ, extension)

% jcom_dflt: Compresion con tablas Huffman por defecto

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
%  caliQ: Factor de calidad (entero positivo >= 1)
%         100: calidad estandar
%         >100: menor calidad
%         <100: mayor calidad
%  extension: String que indica la extensión del archivo, en mi caso bmp o
%  png
% Salidas:
%  RC: Relación de compresión

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion jcom_dflt:');
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

% Codifica los tres scans, usando Huffman por defecto
[CodedY,CodedCb,CodedCr]=EncodeScans_dflt(XScan); 

%Generamos el nombre del archivo comprimido
[pathstr,nomb,ext] = fileparts(fname);
nombrecomp = strcat('Images/EncodedDflt/',extension,'/',nomb,'_cali', int2str(caliQ), '.hud');

% Creamos el archivo
fid = fopen(nombrecomp,'w');

% Transformamos las tablas obtenidas a B
% (con bits2bytes) y las codificamos:

% CodedY
[SBYTES_Y, ULTL_Y]=bits2bytes(CodedY);
U_LENS_Y=uint32(length(SBYTES_Y));
U_ULTL_Y=uint32(ULTL_Y); 
U_SBYTES_Y=uint32(SBYTES_Y);

% CodedCB
[SBYTES_CB, ULTL_CB]=bits2bytes(CodedCb);
U_LENS_CB=uint32(length(SBYTES_CB));
U_ULTL_CB=uint32(ULTL_CB); 
U_SBYTES_CB=uint32(SBYTES_CB);

% CodedCR
[SBYTES_CR, ULTL_CR]=bits2bytes(CodedCr);
U_LENS_CR=uint32(length(SBYTES_CR));
U_ULTL_CR=uint32(ULTL_CR); 
U_SBYTES_CR=uint32(SBYTES_CR);

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
% CodedY
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
%c'est fini
fclose(fid);

% Calculamos RC
TAM_CAB=length(U_CALQ)+ length(U_MAMP)+length(U_NAMP)+length(U_M)+length(U_N);
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
   disp('Terminado EncodeScans_custom');
end
