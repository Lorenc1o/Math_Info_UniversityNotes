function [mse,dmaxdifer] = testdct(fname)
% Entradas: 
%  fname: Un string con nombre de archivo, incluido sufijo 
% Salidas: 
%  mse: Error cuadratico medio entre matrices original y reconstruida 
%  dmaxdifer: Maxima diferencia entre pixeles homologos

% Lee info de imagen
s=imfinfo(fname);
TO=s.FileSize; % Tamaño original

% Carga archivo, convierte a RGB y calcula tamaño
if strcmp(s.ColorType,'indexed') & s.BitDepth==8
    tipo=0;
    [Y,map]=imread(fname);
    X=uint8(round(ind2rgb(Y,map)*255));
elseif strcmp(s.ColorType,'truecolor') & s.BitDepth==24
    tipo=1;
    X=imread(fname);
else
    disp('Formato no reconocido. Terminado.');
    return;
end

% Convierte a espacio de color YCbCr
% Formato double para poder procesar con DCT
XYCbCr=double(rgb2ycbcr(X));

% Si tamaño no es multiplo de 8, replica ultimas filas y/o columnas
% Si no se amplia, al usar blkproc en DCT, ampliara e introducira ceros
% Los ceros provocarian mas error de borde que la replicacion
[m n plan]=size(X); % tamaño original
mpad = rem(m,8); if mpad>0, mpad = 8-mpad; end
npad = rem(n,8); if npad>0, npad = 8-npad; end
Xamp=cat(1, XYCbCr, repmat(XYCbCr(m,:,:),[mpad 1 1]));
Xamp=cat(2, Xamp, repmat(Xamp(:,n,:),[1 npad 1]));
mamp=m+mpad; % Alto ampliado de la imagen (nº de filas)
namp=n+npad; % Ancho ampliadode la imagen (nº de columnas)

% Calculamos la transformada DCT de la matriz ampliada 
% en bloques de 8x8
XampDCT = imdct(Xamp);

% Calculamos la transformada inversa
XampInvDCT = imidct(XampDCT,m,n);

% Convierte a espacio de color RGB
% Para ycbcr2rgb: % Intervalo [0,255]->[0,1]->[0,255]
Xrecrd=round(ycbcr2rgb(XampInvDCT/255)*255);
Xrec=uint8(Xrecrd);

% Repone el tamaño original
Xrec=Xrec(1:m,1:n, 1:3);

% Genera nombre archivo descomprimido <nombre>_des.bmp
[pathstr,name,ext] = fileparts(fname);
nombrecomp=strcat(name,'_des','.bmp');

% Guarda archivo descomprimido
imwrite(Xrec,nombrecomp,'bmp');

% Calculo de MSE 
mse=(sum(sum(sum((double(Xrec)-double(X)).^2))))/(m*n*3);

% Test de valor de diferencias double 
ddifer=abs(double(Xrec)-double(X)); 
dmaxdifer=max(max(max(ddifer)));

%Test visual
testvisual(X,Xrec);