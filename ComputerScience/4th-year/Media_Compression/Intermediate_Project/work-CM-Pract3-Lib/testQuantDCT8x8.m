% Imagen de 8x8 valores
p=[00,10,20,30,30,20,10,00; ...
   10,20,30,40,40,30,20,10; ...
   20,30,40,50,50,40,30,20; ... 
   30,40,50,60,60,50,40,30; ...
   30,40,50,60,60,50,40,30; ...
   20,30,40,50,50,40,30,20; ... 
   10,20,30,40,40,30,12,10; ...
   00,10,20,30,30,20,10,00];


% Renombra q. Sustituye q por p. Lee el guión.
p=[00,10,00,00,00,00,00,10; ...
   00,00,10,00,00,00,10,00; ...
   00,00,00,10,00,10,00,00; ... 
   00,00,00,00,10,00,00,00; ...
   00,00,00,00,10,00,00,00; ...
   00,00,00,00,10,00,00,00; ... 
   00,00,00,00,10,00,00,00; ...
   00,00,00,00,10,00,00,00];

p=[60,40,20,00,00,20,40,60; ...
   60,40,20,00,00,20,40,60; ...
   60,40,20,00,00,20,40,60; ... 
   60,40,20,00,00,20,40,60; ...
   60,40,20,00,00,20,40,60; ...
   60,40,20,00,00,20,40,60; ... 
   60,40,20,00,00,20,40,60; ...
   60,40,20,00,00,20,40,60];

p=[60,00,00,00,00,00,00,60; ...
   00,60,00,00,00,00,60,00; ...
   00,00,60,00,00,60,60,00; ... 
   00,00,00,60,60,00,60,00; ...
   00,00,00,60,60,00,60,00; ...
   00,00,60,00,00,60,60,00; ... 
   00,60,00,00,00,00,60,00; ...
   60,00,00,00,00,00,00,60];

p3=[60,40,20,00,00,20,40,60; ...
   40,60,40,20,20,40,60,40; ...
   20,40,60,40,40,60,60,40; ... 
   00,20,40,60,60,40,60,40; ...
   00,20,40,60,60,40,60,40; ...
   20,40,60,40,40,60,60,40; ... 
   40,60,40,20,20,40,60,40; ...
   60,40,20,00,00,20,40,60];

% Calcular la DCT para 8 valores.
n=8; 
dct=zeros(n,n);
for j=0:7
    for i=0:7 
        for x=0:7
            for y=0:7 
                dct(i+1,j+1)=dct(i+1,j+1)+p(x+1,y+1)*cos((2*y+1)*j*pi/(2*n))*cos((2*x+1)*i*pi/(2*n));
            end; 
        end;
    end; 
end;
dct=dct/4; dct(1,:)=dct(1,:)*0.7071; dct(:,1)=dct(:,1)*0.7071;

% Mostrar la DCT
dct

% Define el escalón de la cuantización seleccionando una magnitud umbral
maximo = max(max(abs(dct)));
minimo = min(min(abs(dct)));
normalizados = dct/(maximo-minimo);  % Todos los valores están entre 0 y 1

umbral = 0.01; % Analiza con los valores 0.5, 0.3, 0.2, 0.1, 0.05, 0.01

k=find(abs(normalizados) > umbral);  % Localizar índices que superan el umbral

seleccionados = dct(k);   % Valores transformados seleccionados
seleccionados'            % Mostrar seleccionados (truncamiento)
escMin = min(min(abs(seleccionados))); % El escalon lo determina el mínimo.

escalon = escMin  % Estudia los escalones 1, 2, 0.5, 5 ... y escMin. Lee el guión.

% Calcular valores con codificación umbral y cuantización.
quant = round(dct/escalon)  % Mostrar los valores cuantizados.

% En este punto se haría 
% 1- la codificación de los datos.
% 2- el envío de los códigos por el canal.
% 3- La recepción de los datos.

% Recibidos los datos, ahora hay que realizar el proceso inverso.

% Primero descuantizamos.
desquant = quant * escalon

% Calcular la iDCT para 8 valores sobre quant.
idct=zeros(n,n);
for x=0:7 
    for y=0:7
        for i=0:7
            if i==0 
                ci=0.7071; 
            else
                ci=1;
            end; 
            
            for j=0:7
                if j==0 
                    cj=0.7071; 
                else
                    cj=1; 
                end;
                
                idct(x+1,y+1)=idct(x+1,y+1)+ ci*cj*desquant(i+1,j+1)*cos((2*y+1)*j*pi/(2*n))*cos((2*x+1)*i*pi/(2*n));
            end; 
        end;
    end; 
end;
idct=idct/4;

% La inversa de la transformada recuperará una aproximación de la imagen original.


%%% Mostraremos los resultados.

% Mostrar los valores original y recuperados en terminal
originales = p
recuperados = idct 

% Mostrar la imagen original y recuperada
figure(1), imagesc(p), colormap(gray), axis square, axis off
figure(2), imagesc(recuperados), colormap(gray), axis square, axis off


% Completa el script para mostrar el error cuadrático medio entre la imagen original y la imagen recuperada. 

% Te toca completar algunas líneas ....

% Calculo de MSE 
mse=(sum(sum((double(recuperados)-double(originales)).^2)))/(8*8)

% Test de valor de diferencias double 
ddifer=abs(double(recuperados)-double(originales)); 
dmaxdifer=max(max(ddifer))

% Fin de script