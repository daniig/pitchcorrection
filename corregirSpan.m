function spanOut = corregirSpan(span, fTarget, Fs)

[picosTemp indsTemp] = findpeaks(span, 'MINPEAKDISTANCE', 100);
picos = [];
inds = [];
% Cogemos solo los picos que estén en zonas con periodicidad y que estén
% por encima de cero
for i = 1:size(picosTemp, 1)
    if picosTemp(i) > 0.01
        picos = [picos picosTemp(i)];
        inds = [inds indsTemp(i)];
    end
end  
% Cogemos trozos de un pico a otro
nPicos = size(picos,2);
% fragments = cell(nPicos,1);
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
    finPicoAct = ipAct+d-1;
    if finPicoAct > length(span)
        finPicoAct = length(span);
    end
    % fprintf('ipAct-d+1=%d, finPicoAct=%d\n\r', ipAct-d+1, finPicoAct);
    % fragments{i,1} = span(ipAct-d+1:finPicoAct);
    fragmentsV{i-1,1} = span(ipAct-d+1:finPicoAct).*hann(long,'symmetric');
end

spanOut = zeros(size(span,1),1);
ptoIns = 1;         % Punto de inserción del siguiente fragmento
pDes = Fs/fTarget*2;  % Periodo deseado
targetCyc = ceil(length(span)/pDes);
for i=1:targetCyc*2
    picoElegido = ceil(i*size(fragmentsV,1)/(targetCyc*2));
    frag = fragmentsV{picoElegido,1}; % fragmento actual
    long = size(frag,1);
    % fprintf('ptoIns=%d, ptoIns+long-1=%d\n\r', ptoIns, ptoIns+long-1);
    finalIns = ptoIns+long-1;
    if finalIns > length(spanOut)
        finalIns = length(spanOut);
    end
    spanOut(ptoIns:finalIns) = spanOut(ptoIns:finalIns)+frag(1:finalIns-ptoIns+1);
    ptoIns = ptoIns + floor(pDes/2);
end

% figure(47)
% plot(span,'g.-');
% hold on
% plot(inds, picos, 'ob');

end