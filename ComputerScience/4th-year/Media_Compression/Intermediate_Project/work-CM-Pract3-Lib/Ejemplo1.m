% Lee senal
[y,Fs] = audioread('hceste.wav');

% Visualiza canal 1
[lon canales]=size(y);
n=(0:lon-1)'; t=n/Fs;
plot(t,y(:,1));
xlabel('t (s)'); ylabel('y (V)');
set(gca,'XGrid','on', 'YGrid','on','GridLineStyle',':');
title('Senal Audio hceste.wav x(t)');

% Reproduce 5 segundos
numdatos=Fs*5;
y5=y(1:numdatos,:);
sound(y5,Fs)
pause(5); % Pausa la ejecución 5 segundos
audiowrite('hceste5.wav', y5,Fs)
