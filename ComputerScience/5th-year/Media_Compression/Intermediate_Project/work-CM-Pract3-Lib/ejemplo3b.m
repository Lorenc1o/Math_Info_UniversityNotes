X = imread('Img01.bmp');
[m,n,p] = size(X);
figure('Units','pixels','Position',[100 100 n m]);
image(X); colormap(map);
set(gca,'Position',[0 0 1 1]);
imwrite(X,map,'Imagen8.jpg','jpeg');

