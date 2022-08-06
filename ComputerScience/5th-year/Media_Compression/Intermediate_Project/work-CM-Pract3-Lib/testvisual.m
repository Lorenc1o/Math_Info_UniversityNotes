function testvisual(X, Xrec)
[m,n,p] = size(X); 
XX=X-Xrec;
figure('Units','pixels','Position',[100 100 n m]); 
set(gca,'Position',[0 0 1 1]); 
image(XX);  