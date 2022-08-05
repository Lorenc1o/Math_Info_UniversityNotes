function [MSE, RC, SNR] = jdes_dflt(fname, extension, show)

% jdes_dflt: Compresion con tablas Huffman por defecto

% Entradas:
%  fname: Un string con nombre de archivo, incluido sufijo
%         Admite .huf
%   extension: Un string con la extensión del archivo original, "png" o "bmp" en mi caso
%   show: Valor Booleano que indica si enseñamos las imágenes por pantalla
%   al terminar (true) o no (false)
% Salidas:
%  MSE: error cuadrático medio
%  RC: relación de compresión
%  SNR : Tasa de señal a ruido

% Abrimos el fichero comprimido,
% Generamos el nombre para el archivo descomprimido <nombre>_des_def.bmp y
% obtenemos los datos comprimidos
[pathstr,nomb,ext] = fileparts(fname);
nomb = strsplit(nomb, "_cali");
nombrecomp=strcat('Images/DecodedDflt/',extension,'/',nomb(1), '_cali', nomb(2),'_des_def.',extension);
fid = fopen(fname,'r');
archivoOrig = strcat('Images/Original/', nomb(1), '.', extension);
[XOR, ~, ~, ~, ~, ~, ~, TO] = imlee(archivoOrig);

% Leemos los parámetros de la imagen original
n= double(fread(fid, 1, 'uint32'));    
namp= double(fread(fid, 1, 'uint32'));  
m= double(fread(fid, 1, 'uint32'));    
mamp= double(fread(fid, 1, 'uint32'));   
caliQ= double(fread(fid, 1, 'uint32')); 

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
% Obtenemos CodedCR original 
CodedCr=bytes2bits(SBYTES_CR, ULTL_CR); 

%C'est fini
fclose(fid);

% Decodifica los tres Scans a partir de strings binarios
XScanrec=DecodeScans_dflt(CodedY,CodedCb,CodedCr,[mamp namp]);

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

% Genera nombre archivo descomprimido <nombre>_des.bmp
%[pathstr,name,ext] = fileparts(fname);
%nombrecomp=strcat(name,'_des_def','.bmp');

% Guarda archivo descomprimido
imwrite(Xrec,nombrecomp,extension);

%Ya que la cabecera est´s compuesta por los datos n,m,namp,mamp y caliQ
%ocupará 4 bytes para cada uno de ellos
TAM_CAB = 4*5;
TAM_DAT = length(U_SBYTES_Y)+ length(U_SBYTES_CB)+length(U_SBYTES_CR);
TC = TAM_CAB + TAM_DAT;

%Calculamos el MSE
MSE=(sum(sum(sum((double(Xrec)-double(XOR)).^2))))/(m*n*3);

%Calculamos RC
RC = 100*(TO-TAM_DAT)/TO;

%Calculamos SNR
SNR = sum(sum(sum(double(XOR).^2)))/(sum(sum(sum((double(Xrec)-double(XOR)).^2))));
SNR = 10*log10(SNR);

% Test visual
if show
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

