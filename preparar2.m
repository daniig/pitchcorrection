% preparar 2
%% Inicialización
clear all; close all;
[aEntero, Fs] = wavread('cancion.wav');
a = aEntero(floor(4.7*Fs):floor(6.55*Fs));
numS = size(a, 1);  % número de muestras
l = 1024; ss = floor(l/3);
e = aloc(a,1,numS,l,ss,0,0);
c = aloc(a,1,numS,l,ss,2,1);
% v = aloc(a,1,numS,l,ss,3,0);
[f centros] = frecuencias(c,e,Fs,70,500,0.9,ss);
%% Búsqueda de frecuencias deseadas
fDeseadas = zeros(size(f,1),1);
for i = 1:size(f,1)
    fDeseadas(i) = fAdjust(f(i));
end
figure(4)
%plot(centros, f, '*g', centros, fDeseadas, 'ob');
plot(1:size(f,1), f, '*g', 1:size(f,1), fDeseadas, 'ob');

%% Pintado
figure(2)
[AX,H1,H2] = plotyy(1:numS,a,centros,f,'plot');
set(H2,'LineStyle',':','Marker','*')

% figure(1)
% subplot(3,1,1);
% plot(1:numS, a);
% hold on
% plot(centros, f/1000, '*g');
% hold off
% subplot(3,1,2);
% plot(1:size(e,1), e, 'or'); axis tight;
% subplot(3,1,3);
% plot(1:size(f,1), f, '*g'); axis tight;
%% Búsqueda de ventanas contiguas con la misma freq. fund.
vSpans = findFreqSpans(fDeseadas);
%% Búsqueda de picos (periodos fundamentales)
% El valor 100 para MINPEAKDISTANCE parece funcionar bien. Si dejara de ser
% así, se puede ayudar de la frecuencia fundamental detectada
[picosTemp indsTemp] = findpeaks(a, 'MINPEAKDISTANCE', 100);
nPicos = size(picosTemp,1);
picos = [];
inds = [];
% Cogemos solo los picos que estén en zonas con periodicidad y que estén
% por encima de cero
for i = 1:nPicos
    nVent = floor(indsTemp(i)/ss);
    if nVent > 0 && f(nVent) > 0 && picosTemp(i) > 0
        picos = [picos picosTemp(i)];
        inds = [inds indsTemp(i)];
    end
end       
nPicos = size(picos,2);
        
figure(3)
plot(a,'g.-');
hold on
plot(inds, picos, 'ob');
%% Separación y suavizado de los bordes de los spans
nSpans = size(vSpans,1);
spans = cell(nSpans,1);
vFade = hann((l-ss)*2,'symmetric');
lFade = floor(length(vFade)/2);
iniFade = vFade(1:lFade);
finFade = vFade(end-lFade+1:end);
for i = 1:nSpans
    vIni = vSpans(i,1);     % Ventanas inicial y final
    vFin = vSpans(i,2);
    sIni = 1+(vIni-1)*ss;   % Samples inicial y final
    sFin = (vFin-1)*ss+l;
    if sFin > length(a)
        sFin = length(a);
    end
    spans{i} = a(sIni:sFin);
    % fprintf('Ventana %i: de %i a %i\n\r', i, sIni, sFin);
end
%% Fades en los bordes
for i = 1:nSpans
    spans{i}(1:lFade) = spans{i}(1:lFade).*iniFade;
    spans{i}(end-lFade+1:end) = spans{i}(end-lFade+1:end).*finFade;
end
%% Reconstrucción
aR = zeros(length(a),1);
for i = 1:nSpans
    vIni = vSpans(i,1);     % Ventanas inicial y final
    vFin = vSpans(i,2);
    sIni = 1+(vIni-1)*ss;   % Samples inicial y final
    sFin = (vFin-1)*ss+l;
    if sFin > length(a)
        sFin = length(a);
    end
    aR(sIni:sFin) = aR(sIni:sFin)+spans{i};
end

    


