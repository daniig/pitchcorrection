% FUNTION y=aloc(x,m1,m2,l,ss,itipoa,itipov);
% Short-time analysis of Energy, Zero Crossing Rate and Autocorrelation over an input speech signal %  
% OUTPUT:
%     y: vector of short-time energies, ZRC or matrix of autocorrelations
%
%INPUT:
%     x: input vector with the speech signal
%     m1: starting point on x.
%     m2: end point on x.
%     Short time analysis will be applied from m1 to m2
%     l: window size (length)
%     ss: non overlapped samples
%     itipoa: Type of short-time analysis
%          0.Energy                  1.ZCR
%          2.Autocorrelation.        3.Array of windows
%     itipov: Type of window
%          0. Rectangular. 
%          1. Hanning.

function y = aloc(x,m1,m2,l,ss,itipoa,itipov)
dibujar = 0;

% TODO comprobar la validez de los parámetros

% Recortamos el vector de entrada
s = x(m1:m2);
% Eliminamos la continua
s = s-mean(s);

% Dividimos en ventanas -> acceder vs(num_ventana, datos)
% Además, agregamos padding con ceros al final de s para facilitar el
% enventanado
vs = zeros(ceil(size(s,1)/ss), l);
s = [s; zeros(l,1)];
for i=1:size(vs,1)
    inicio = 1+(i-1)*ss;
    fin = (i-1)*ss+l;
    vs(i,:) = s(inicio:fin);
end
% Si la ventana elegida es Hanning, aplicamos la ponderación adecuada
if itipov == 1
    for i=1:size(vs,1)
        vs(i,:) = vs(i,:).*hanning(l)';
    end
end
% Calculamos lo que pida el usuario
switch itipoa
    case 0
        y = sum(vs(:,:).^2,2);
    case 1
        y = zeros(size(vs,1), 1);
        for i=1:size(vs,1)
            cc = 0; % Cuenta de ceros
            for j=1:l-1
                if vs(i,j)*vs(i,j+1) < 0
                    cc = cc+1;
                end
            end
            y(i,1) = cc;
        end
    case 2
        y = zeros(size(vs,1),l);
        for i=1:size(vs,1)
            c = xcorr(vs(i,:));
            y(i,:) = c(l:2*l-1);
        end
    case 3
        y = vs;
end

if dibujar == 1
    % Forma de onda en el tiempo
    subplot(3,1,1)
    plot(s)
    axis([0 length(s) min(s) max(s)])
    % ZCR o energía
    if itipoa ~= 2 && itipoa ~= 3
        subplot(3,1,2)
        plot(y, 'or')
        axis([0 length(y) min(y) max(y)])
    end
    % Espectrograma
    subplot(3,1,3)
    if itipov == 1
        vent = hamming(l);
    else
        vent = ones(1,l);
    end
%     [S,F,T,P] = spectrogram(s,vent,ss,l,8000); % Cuidado con el 8000!
%     surf(T,F,10*log10(abs(S).^2),'edgecolor','none'); axis tight; 
%     view(0,90);
%     xlabel('Time (Seconds)'); ylabel('Hz');
end

end




