function [MSE,RC]=jdes_custom(fname) 

% jdes_custom: Descompresion de imagenes basada en tablas Huffman
% customizadas

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite BMP y JPEG, indexado y truecolor
% Salidas:
%  RC: Relacion de compresion
%  MSE : Error de compresion

disptext = 1;% Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('jdes_custom:');
end

% Abrimos el fichero comprimido,
% Generamos el nombre para el archivo descomprimido <nombre>_des_def.bmp y
% obtenemos los datos comprimidos
[pathstr,nomb,ext] = fileparts(fname);
nombrecomp=strcat(nomb,'_des_cus','.bmp');
fid = fopen(fname,'r');
archivoOrig = strcat(nomb, '.bmp');
[XOR, ~, ~, ~, ~, ~, ~, TO] = imlee(archivoOrig);

% Leemos los parámetros de la imagen original
n= double(fread(fid, 1, 'uint32'));    
namp= double(fread(fid, 1, 'uint32'));  
m= double(fread(fid, 1, 'uint32'));    
mamp= double(fread(fid, 1, 'uint32'));   
caliQ= double(fread(fid, 1, 'uint32')); 

% BITS y HUFFMAN
LEN_BITS_Y_DC = double(fread(fid,1,'uint32'));
BITS_Y_DC = double(fread(fid, LEN_BITS_Y_DC, 'uint32'));
LEN_HUFFVAL_Y_DC = double(fread(fid, 1, 'uint32'));
HUFFVAL_Y_DC = double(fread(fid, LEN_HUFFVAL_Y_DC, 'uint32'));

LEN_BITS_Y_AC = double(fread(fid,1,'uint32'));
BITS_Y_AC = double(fread(fid, LEN_BITS_Y_AC, 'uint32'));
LEN_HUFFVAL_Y_AC = double(fread(fid, 1, 'uint32'));
HUFFVAL_Y_AC = double(fread(fid, LEN_HUFFVAL_Y_AC, 'uint32'));

LEN_BITS_C_DC = double(fread(fid,1,'uint32'));
BITS_C_DC = double(fread(fid, LEN_BITS_C_DC, 'uint32'));
LEN_HUFFVAL_C_DC = double(fread(fid, 1, 'uint32'));
HUFFVAL_C_DC = double(fread(fid, LEN_HUFFVAL_C_DC, 'uint32'));

LEN_BITS_C_AC = double(fread(fid,1,'uint32'));
BITS_C_AC = double(fread(fid, LEN_BITS_C_AC, 'uint32'));
LEN_HUFFVAL_C_AC = double(fread(fid, 1, 'uint32'));
HUFFVAL_C_AC = double(fread(fid, LEN_HUFFVAL_C_AC, 'uint32'));

% CodedY
LENS_Y = double(fread(fid, 1, 'uint32'));
ULTL_Y = double(fread(fid, 1, 'uint32'));
U_SBYTES_Y = fread(fid, LENS_Y, 'uint32');
SBYTES_Y = double(U_SBYTES_Y);
% Obtenemos CodedY original
CodedY=bytes2bits(SBYTES_Y, ULTL_Y);   

% CodedCb
LENS_CB = double(fread(fid, 1, 'uint32'));
ULTL_CB = double(fread(fid, 1, 'uint32'));
U_SBYTES_CB = fread(fid, LENS_CB, 'uint32');
SBYTES_CB = double(U_SBYTES_CB);
% Obtenemos CodedCb original
CodedCb=bytes2bits(SBYTES_CB, ULTL_CB); 

% CodedCr
LENS_CR = double(fread(fid, 1, 'uint32'));
ULTL_CR = double(fread(fid, 1, 'uint32'));
U_SBYTES_CR = fread(fid, LENS_CR, 'uint32');
SBYTES_CR = double(U_SBYTES_CR);
% Obtenemos CodedCr original 
CodedCr=bytes2bits(SBYTES_CR, ULTL_CR); 

% C'est fini
fclose(fid);


% Decodifica los tres Scans a partir de strings binarios
XScanrec=DecodeScans_custom(CodedY,CodedCb,CodedCr,[mamp namp],BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC,HUFFVAL_Y_AC, BITS_C_DC,HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC);

% Recupera matrices de etiquetas en orden natural
%  a partir de orden zigzag
Xlabrec=invscan(XScanrec);

% Descuantizacion de etiquetas
Xtransrec=desquantmat(Xlabrec, caliQ);

% Calcula iDCT bidimensional en bloques de 8 x 8 pixeles
% Como resultado, reconstruye una imagen YCbCr con tamaño ampliado
Xamprec = imidct(Xtransrec,m, n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd=round(ycbcr2rgb(Xamprec/255)*255);
Xrec=uint8(Xrecrd);

% Repone el tamaño original
Xrec=Xrec(1:m,1:n, 1:3);

% Guarda archivo descomprimido
imwrite(Xrec, nombrecomp, 'bmp');

%Ya que la cabecera está compuesta por los datos n,m,namp,mamp y caliQ
%ocupará 4 bytes para cada uno de ellos
TAM_CAB = 4*5+(1+LEN_BITS_Y_DC)*4+(1+LEN_HUFFVAL_Y_DC)*4+(1+LEN_BITS_Y_AC)*4+(1+LEN_HUFFVAL_Y_AC)*4;
TAM_CAB = TAM_CAB+(1+LEN_BITS_C_DC)*4+(1+LEN_HUFFVAL_C_DC)*4+(1+LEN_BITS_C_AC)*4+(1+LEN_HUFFVAL_C_AC)*4;
TAM_DAT = length(U_SBYTES_Y)+ length(U_SBYTES_CB)+length(U_SBYTES_CR);
TC = TAM_CAB + TAM_DAT;

%Calculamos el error medio de la misma manera que indicaba la practica 4
MSE=(sum(sum(sum((double(Xrec)-double(XOR)).^2))))/(m*n*3);

%Calculamos RC
RC = 100*(TO-TC)/TO;

% Test visual
if disptext
    [m,n,p] = size(XOR);
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(XOR); 
    set(gcf,'Name','Imagen original X');
    figure('Units','pixels','Position',[100 100 n m]);
    set(gca,'Position',[0 0 1 1]);
    image(Xrec);
    set(gcf,'Name','Imagen reconstruida Xrec');

end


end

