clc

%load('Vector_Tiempo_FieldFox_Nuevo.mat')
load('Vector_Tiempo_FieldFox_Viejo.mat')
Tiempo = [];
for n=1:length(Tiempo_Final) %Change Tiempo_Final with Tiempo_FieldFox to work with the data of the new FieldFox
    Tiempo = [Tiempo; convertStringsToChars(Tiempo_Final(n))];
    if str2num(Tiempo(n,1:2)) == 12
        Tiempo(n,1:2) = ['00'];
    end
end
Fv = linspace(-1500,1500,1001);
TiempoVideo = str2num( Tiempo(:,1:2) )*3600 ...
                + str2num( Tiempo(:,4:5) )*60 ...
                + str2num( Tiempo(:,7:8) ) ...
                + str2num( Tiempo(:,10:12) )/1000;
TiempoVideo = TiempoVideo - TiempoVideo(1);
ix = 10;
% T = zeros(length(Tiempo),1);
%  for n=1:length(Tiempo_FieldFox)
%      T(n) = str2num(Tiempo(n,[7:12]));
% end



 %load('FieldFox_Nuevo.mat')
load('FieldFox_viejo.mat')
v = VideoWriter('/home/rdll/Documentos/vrnoci2022/videos/Espectrograma_viejo.avi');
v.FrameRate = 8;
open(v);
    fig1 = figure('Units','inches','Position',[0 0.5 16 9]);
    ax1 = gca;
    ax1.Position = [0.09 0.15 0.88 0.84];
for n=1:length(Tiempo_Final)-ix
    Tv = linspace(TiempoVideo(n),TiempoVideo(n+ix),ix+1);
    surf(Fv,Tv,data(n:n+ix,:));shading interp; view (90,90);axis('tight');
    ylabel( ['Tiempo cuadro inicio: min.seg = ' num2str( floor(TiempoVideo(n)/60) ) ...
            ':' num2str( TiempoVideo(n) - 60*floor(TiempoVideo(n)/60) ) ',N =' num2str(n) ] )
    frame = getframe(gcf);
    writeVideo(v,frame);
end

close(v);
