function wavtest(fname, vel)
    %Función que reproduce el archivo de audio fname a velocidad vel
    % también muestra los distintos canales de audio
    %Entradas
    %   fname: nombre del archivo .wav
    %   vel: velocidad de reproducción
    % Lee senal 
    [y,Fs] = audioread(fname);

    [lon, canales]=size(y);
    n=(0:lon-1)'; t=n/Fs; 
    
    %muestra los canales
    tiledlayout(canales,1)
    for i=1:canales
        nexttile;
        plot(t,y(:,i)); 
        xlabel('t (s)'); ylabel('y (V)'); 
        set(gca,'XGrid','on', 'YGrid','on','GridLineStyle',':'); 
        title('Señal Audio ' + fname + ' x(t) para el canal ' + int2str(i)); 
    end
    
    sound(y,Fs*vel); %reproduce la canción a velocidad vel
    
    %lo convierte a monoaural
    ymono = zeros(lon, 1);
    for i=1:lon
        ymono(i) = sum(y(i,:))/canales;
    end
    
    %tomamos 5 segundos y los guardamos en un nuevo archivo
    numdatos=Fs*5; 
    y5=ymono(1:numdatos,:); 
    [~,nomb,~] = fileparts(fname);
    audiowrite(nomb + "short.wav", y5,Fs);
end