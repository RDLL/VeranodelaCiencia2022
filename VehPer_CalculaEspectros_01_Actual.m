clc
load('Vector_Tiempo_FieldFox_Nuevo.mat')
%load('Vector_Tiempo_FieldFox_Viejo.mat')
Tiempo = [];
for n=1:length(Tiempo_Final)
    Tiempo = [Tiempo; convertStringsToChars(Tiempo_Final(n))];
    if str2num(Tiempo(n,1:2)) == 12
        Tiempo(n,1:2) = ['00'];
    end
end
TiempoVideo = str2num( Tiempo(:,1:2) )*3600 ...
                + str2num( Tiempo(:,4:5) )*60 ...
                + str2num( Tiempo(:,7:8) ) ...
                + str2num( Tiempo(:,10:12) )/1000;
TiempoVideo = TiempoVideo - TiempoVideo(1);

 load('FieldFox_Nuevo.mat')
%load('FieldFox_viejo.mat')

T = length(Tiempo_FieldFox);
Df=3e3/1001;
f = -1.5e3 + (0:1000)*Df;
v = VideoWriter('/home/rdll/Documentos/vrnoci2022/videos/Muestras_Nuevo.avi');
v.FrameRate = 8;
open(v);
for n = 1:T
    SS = data(n,:);
    fbias = f(  SS == max(SS)  );
    plot(f -fbias, SS);
    xlabel( ['Tiempo en video: min.seg = ' num2str( floor(TiempoVideo(n)/60) ) ...
            ':' num2str( TiempoVideo(n) - 60*floor(TiempoVideo(n)/60) ) ',N =' num2str(n) ] )
    grid on
    axis([-1500 1500 -140 -40])
    %pause(0.05);
    frame = getframe(gcf);
    writeVideo(v,frame);
end
close(v);

figure(2)
surf(f, 1:T, data); shading interp; view(90,90)