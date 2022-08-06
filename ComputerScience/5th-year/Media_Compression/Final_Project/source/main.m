% En este script vamos a obtener los resultados experimentales
pathOrig = "Images/Original/";
pathDflt = "Images/EncodedDflt/";
pathCustom = "Images/EncodedCustom/";

bmps = ["captura.bmp","blackbuck.bmp","bmp_24.bmp","dots.bmp",...
    "leon.bmp","ejemploMulticolor.bmp","windows.bmp",...
    "greenland_grid_velo.bmp","lena.bmp","snail.bmp"];
pngs = ["captura.png","blackbuck.png","bmp_24.png","dots.png",...
    "leon.png","ejemploMulticolor.png","windows.png",...
    "greenland_grid_velo.png","lena.png","snail.png"];

caliQ = [1,25,50,100,250,500,1000];

% Los datos de las bmp

RCDfltbmp = [];
MSEDfltbmp = [];
SNRDfltbmp = []; 

RCCustombmp = [];
MSECustombmp = [];
SNRCustombmp = [];

% Los datos de las png

RCDfltpng = [];
MSEDfltpng = [];
SNRDfltpng = []; 

RCCustompng = [];
MSECustompng = [];
SNRCustompng = [];

% Obtención de datos: primero comprimimos y después descomprimimos cada
% imagen de ambas formas

for q = caliQ
    RCdflt = [];
    MSEdflt = [];
    SNRdflt = [];
    
    RCCustom = [];
    MSECustom = [];
    SNRCustom = [];
    
    for bmp = bmps
        fname = strcat(pathOrig, bmp);
        
        % Compresión default
        jcom_dflt(fname, q, 'bmp');    
        [pathstr,nomb,ext] = fileparts(fname);
        fname = strcat(pathDflt,'bmp/',nomb,'_cali',int2str(q),'.hud');
        [MSE1, RC1, SNR1] = jdes_dflt(fname, "bmp", false);
        RCdflt = [RCdflt RC1];
        MSEdflt = [MSEdflt MSE1];
        SNRdflt = [SNRdflt SNR1];
        
        % Compresión Custom
        fname = strcat(pathOrig, bmp);
        jcom_custom(fname, q, 'bmp');    
        [pathstr,nomb,ext] = fileparts(fname);
        fname = strcat(pathCustom,'bmp/',nomb,'_cali',int2str(q),'.huc');
        [MSE2, RC2, SNR2] = jdes_custom(fname, "bmp", false);
        RCCustom = [RCCustom RC2];
        MSECustom = [MSECustom MSE2];
        SNRCustom = [SNRCustom SNR2];
    end
    RCDfltbmp = [RCDfltbmp; RCdflt];
    MSEDfltbmp = [MSEDfltbmp; MSEdflt];
    SNRDfltbmp = [SNRDfltbmp; SNRdflt];
    
    RCCustombmp = [RCCustombmp; RCCustom];
    MSECustombmp = [MSECustombmp; MSECustom];
    SNRCustombmp = [SNRCustombmp; SNRCustom];
    
    RCdflt = [];
    MSEdflt = [];
    SNRdflt = [];
    
    RCCustom = [];
    MSECustom = [];
    SNRCustom = [];
    
    for png = pngs
        fname = strcat(pathOrig, png);
        disp(fname);
        
        % Compresión default
        jcom_dflt(fname, q, 'png');    
        [pathstr,nomb,ext] = fileparts(fname);
        fname = strcat(pathDflt,'png/',nomb,'_cali',int2str(q),'.hud');
        [MSE1, RC1, SNR1] = jdes_dflt(fname, "png", false);
        RCdflt = [RCdflt RC2];
        MSEdflt = [MSEdflt MSE2];
        SNRdflt = [SNRdflt SNR2];
        
        % Compresión Custom
        fname = strcat(pathOrig, png);
        jcom_custom(fname, q, 'png');    
        [pathstr,nomb,ext] = fileparts(fname);
        fname = strcat(pathCustom,'png/',nomb,'_cali',int2str(q),'.huc');
        [MSE2, RC2, SNR2] = jdes_custom(fname, "png", false);
        RCCustom = [RCCustom RC2];
        MSECustom = [MSECustom MSE2];
        SNRCustom = [SNRCustom SNR2];
    end
    RCDfltpng = [RCDfltpng; RCdflt];
    MSEDfltpng = [MSEDfltpng; MSEdflt];
    SNRDfltpng = [SNRDfltpng; SNRdflt];
    
    RCCustompng = [RCCustompng; RCCustom];
    MSECustompng = [MSECustompng; MSECustom];
    SNRCustompng = [SNRCustompng; SNRCustom];
end

% Escribimos los datos
writematrix(RCDfltbmp, 'Data/RCDfltbmp.xls');
writematrix(MSEDfltbmp, 'Data/MSEDfltbmp.xls');
writematrix(SNRDfltbmp, 'Data/SNRDfltbmp.xls');

writematrix(RCCustombmp, 'Data/RCCustombmp.xls');
writematrix(MSECustombmp, 'Data/MSECustombmp.xls');
writematrix(SNRCustombmp, 'Data/SNRCustombmp.xls');

writematrix(RCDfltpng, 'Data/RCDfltpng.xls');
writematrix(MSEDfltpng, 'Data/MSEDfltpng.xls');
writematrix(SNRDfltpng, 'Data/SNRDfltpng.xls');

writematrix(RCCustompng, 'Data/RCCustompng.xls');
writematrix(MSECustompng, 'Data/MSECustompng.xls');
writematrix(SNRCustompng, 'Data/SNRCustompng.xls');