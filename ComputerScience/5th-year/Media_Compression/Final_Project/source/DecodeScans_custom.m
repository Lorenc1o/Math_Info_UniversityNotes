function XScanrec=DecodeScans_custom(CodedY, CodedCb, CodedCr, TAM,BITS_Y_DC, HUFFVAL_Y_DC, BITS_Y_AC,HUFFVAL_Y_AC, BITS_C_DC,HUFFVAL_C_DC, BITS_C_AC, HUFFVAL_C_AC)

% DecodeScans_custom: Decodifica los tres scans binarios usando las tablas de
% huffman obtenidas en EncodeScans_custom


% Entradas:
%   CodedY: String binario con scan Y codificado
%   CodedCb: String binario con scan Cb codificado
%   CodedCr: String binario con scan Cr codificado
%   TAM: Tamaño del scan a devolver con forma de [mamp namp]
%   HUFFVAL_Y_DC: símbolos de la fuente, ordenados por longitudes crecientes de la palabra
%   código que les corresponderá.
%   BITS_Y_AC: Lista que contiene el número de palabras de cada codigo
%   HUFFVAL_Y_AC: símbolos de la fuente, ordenados por longitudes crecientes de la palabra
%   código que les corresponderá.
%   BITS_Y_DC: Lista que contiene el número de palabras de cada codigo
%   HUFFVAL_C_AC: símbolos de la fuente, ordenados por longitudes crecientes de la palabra
%   código que les corresponderá.
%   BITS_C_AC: Lista que contiene el número de palabras de cada codigo
%   HUFFVAL_C_DC: símbolos de la fuente, ordenados por longitudes crecientes de la palabra
%   código que les corresponderá.
%   BITS_C_DC: Lista que contiene el num. de palabras de cada codigo

% Salidas:
%  XScanrec: Scans reconstruidos de luminancia Y y crominancia Cb y Cr: Matriz mamp x namp X 3

disptext=1; % Flag de verbosidad
if disptext
    disp('--------------------------------------------------');
    disp('Funcion DecodeScans_custom:');
end

% Instante inicial
tc=cputime;

% Construir tablas Huffman para Luminancia y Crominancia
% Tablas de luminancia
% Tabla Y_DC e Y_AC
% Primero la tabla del Codigo Huffman y luego la de decodificacion.
[HUFFSIZE_Y_DC, HUFFCODE_Y_DC] = HCodeTables(BITS_Y_DC, HUFFVAL_Y_DC);
[MINCO_Y_DC,MAXCO_Y_DC,VALPTR_Y_DC]=HDecodingTables(BITS_Y_DC, HUFFCODE_Y_DC);

[HUFFSIZE_Y_AC, HUFFCODE_Y_AC] = HCodeTables(BITS_Y_AC, HUFFVAL_Y_AC);
[MINCO_Y_AC,MAXCO_Y_AC,VALPTR_Y_AC]=HDecodingTables(BITS_Y_AC, HUFFCODE_Y_AC);
% Decodificamos la tabla de luminancia
YRec=DecodeSingleScan(CodedY,MINCO_Y_DC,MAXCO_Y_DC,VALPTR_Y_DC,HUFFVAL_Y_DC,MINCO_Y_AC,MAXCO_Y_AC,VALPTR_Y_AC,HUFFVAL_Y_AC,TAM);

% Tablas de crominancia
% Tabla C_DC y C_AC
% Primero la tabla del Codigo Huffman y luego la de decodificacion.
[HUFFSIZE_C_DC, HUFFCODE_C_DC] = HCodeTables(BITS_C_DC, HUFFVAL_C_DC);
[MINCO_C_DC,MAXCO_C_DC,VALPTR_C_DC]=HDecodingTables(BITS_C_DC, HUFFCODE_C_DC);

[HUFFSIZE_C_AC, HUFFCODE_C_AC] = HCodeTables(BITS_C_AC, HUFFVAL_C_AC);
[MINCO_C_AC,MAXCO_C_AC,VALPTR_C_AC]=HDecodingTables(BITS_C_AC, HUFFCODE_C_AC);
% Decodificamos la tabla de crominancia
CBRec=DecodeSingleScan(CodedCb,MINCO_C_DC,MAXCO_C_DC,VALPTR_C_DC,HUFFVAL_C_DC,MINCO_C_AC,MAXCO_C_AC,VALPTR_C_AC,HUFFVAL_C_AC,TAM);
CRRec=DecodeSingleScan(CodedCr,MINCO_C_DC,MAXCO_C_DC,VALPTR_C_DC,HUFFVAL_C_DC,MINCO_C_AC,MAXCO_C_AC,VALPTR_C_AC,HUFFVAL_C_AC,TAM);

% Reconstruye matriz 3-D
XScanrec=cat(3,YRec,CBRec,CRRec);

% Tiempo de ejecucion
e=cputime-tc;

if disptext
    disp('Scans decodificados');
    disp(sprintf('%s %1.6f', 'Tiempo de CPU:', e));
    disp('Terminado DecodeScans_dflt');
end