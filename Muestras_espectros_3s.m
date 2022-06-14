clc
load('Vector_Tiempo_FieldFox_Nuevo.mat')
%load('Vector_Tiempo_FieldFox_Viejo.mat')
Tiempo = [];
for n=1:length(Tiempo_FieldFox)
    Tiempo = [Tiempo; convertStringsToChars(Tiempo_FieldFox(n))];
    if str2num(Tiempo(n,1:2)) == 12
        Tiempo(n,1:2) = ['00'];
    end
end

T = zeros(length(Tiempo),1);
for n=1:length(Tiempo_FieldFox)
    T(n) = str2num(Tiempo(n,[7:12]));
end



 load('FieldFox_Nuevo.mat')
%load('FieldFox_viejo.mat')
i = 1;
for n=1:length(T)
    figure(1)
    surf(data(n:n+25,:));shading interp; view (90,90);
end
