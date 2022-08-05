[X,map] = imread('Img11.bmp');
[m,n] = size(X);

% Crear una nueva ventana figura
figure('Units','pixels','Position',[100 100 n m]);
set(gca,'Position',[0 0 1 1]);

% Mostrar los datos de un array como imagen
image(X); 
% Establece el mapa de colores de la figura actual
colormap(map);

imwrite(X,map,'Imagen7.jpg','jpeg');