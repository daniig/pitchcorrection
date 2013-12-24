clear all
close all
[a, Fs] = wavread('cancion.wav');
pl = audioplayer(a,Fs);
L = 1024;   % Longitud de las ventanas
SS = 512;   % Solapamiento de las ventanas
e = aloc(a, 1, length(a), L, SS, 0, 0);
c = aloc(a, 1, length(a), L, SS, 2, 0);
v = aloc(a, 1, length(a), L, SS, 3, 0);
f = frecuencias(c,e,Fs);

%ventana = v(180,:);  % Ej: vocal en ventana 180
%%
vocal = a(86259:94374);
% pvocal = audioplayer(vocal,Fs);
% % Muestra una ventana normal y los picos iniciales de los periodos
% close all
% figure(1)
% plot(vocal,'g.-');
% hold
[picos inds] = findpeaks(vocal, 'MINPEAKDISTANCE', 100);
% plot(inds, picos, 'ob')
nPicos = size(picos,1);

% *   ___*___   *    * := picos
%    /   |   \
%   /    |    \
% _/     |     \_
%|<--d-->|


% Cogemos trozos de un pico a otro
fragments = cell(nPicos-2,1);
fragmentsV = cell(nPicos-2,1);  % Fragmentos tras pasar por la ventana
distancias = zeros(nPicos,1);
for i=2:nPicos-1
    ipAct = inds(i);
    ipAnt = inds(i-1);    % Índices de los picos anteriores y posteriores
    ipPost = inds(i+1);
    d1 = ipAct-ipAnt+1;   % Distancias a los picos ant. y post.
    d2 = ipPost-ipAct+1;
    if d1 < d2            % El tam. de la ventana dependerá de la menor distancia a un pico contiguo
        d = d1;
    else
        d = d2;
    end
    distancias(i) = d;
    long = 2*d-1;
    fragments{i,1} = vocal(ipAct-d+1:ipAct+d-1);
    fragmentsV{i,1} = vocal(ipAct-d+1:ipAct+d-1).*hann(long,'symmetric');
    % fprintf('Fragmento %d de %d a %d\n', ipAct-d+1, ipAct+d-1);
end

% %Reconstrucción de la vocal
% vreconst = zeros(size(vocal,1)*2,1);
% for i=2:nPicos-1
%     frag = fragmentsV{i,1}; % fragmento actual
%     ipAct = floor(inds(i)*0.8);
%     if ipAct == 0
%         ipAct = 1;
%     end
%     d = distancias(i);
%     vreconst(ipAct-d+1:ipAct+d-1) = vreconst(ipAct-d+1:ipAct+d-1)+fragmentsV{i,1};
% end

% vreconst = zeros(size(vocal,1)*2,1);
% ptoIns = 1; % Punto de inserción del siguiente fragmento
% pDes = 300; % Periodo deseado
% for i=2:nPicos-1
%     frag = fragmentsV{i,1}; % fragmento actual
%     long = size(frag,1);
%     ptoIns = ptoIns + floor(pDes/2);
%     vreconst(ptoIns:ptoIns+long-1) = vreconst(ptoIns:ptoIns+long-1)+frag;
% end


% figure(1)
% plot(fragments{25,1})
% figure(2)
% plot(fragmentsV{25,1})


%%

vreconst = zeros(size(vocal,1)*10,1);
ptoIns = 1; % Punto de inserción del siguiente fragmento
pDes = 290; % Periodo deseado
nBucles = 1;
for j=1:nBucles
    for i=2:nPicos-1
        frag = fragmentsV{i,1}; % fragmento actual
        long = size(frag,1);
        ptoIns = ptoIns + floor(pDes/2);
        vreconst(ptoIns:ptoIns+long-1) = vreconst(ptoIns:ptoIns+long-1)+frag;
    end
    
end

pl1 = audioplayer(vocal,Fs);
pl2 = audioplayer(vreconst,Fs);
play(pl1);
pause
play(pl2);
