function varargout = frecuencias(c, e, Fs, ufmin, ufmax, ue, ss)
% ufmin, ufmax: umbrales de frecuencias mínimas y máximas válidas
% ue: umbral de energía para detección de actividad

nv = size(c,1);     % Num ventanas
l = size(c,2);      % Longitud de las ventanas
y = zeros(nv,1);
centros = zeros(nv,1);
m = ones(1,l);      % Máscara para descartar frecuencias altas
m(1:floor(Fs/ufmax)) = 0;
m(floor(Fs/ufmin):end) = 0;


for i = 2:nv-1
    if e(i) > ue && e(i-1) > ue && e(i+1) > ue
        [v p] = max((c(i,:).*(sign(c(i,:))+1)/2).*m);
        f = Fs/p;
        if f > ufmin && f < ufmax
            y(i) = f;
        else
            y(i) = 0;
        end
    else
        y(i) = 0;
    end
    centros(i) = 1+(i-1)*ss+ss;
end

if nargout == 1         % solo devolvemos las frecuencias
    varargout = y;
elseif nargout == 2    % devolvemos frecuencias y centros de las ventanas
    varargout{1} = y;
    varargout{2} = centros;
end
    