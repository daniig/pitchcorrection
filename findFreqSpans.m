function spans = findFreqSpans(freqs)

spans = [];
vIni = 1;       % ventana inicial del span actual
f = freqs(1);   % freq. del span actual
for i = 2:length(freqs)
    if f ~= freqs(i)
        % Fin del span
        spans = [spans ; vIni i-1];
        vIni = i;
        f = freqs(i);
    end
end
spans = [spans ; vIni length(freqs)];
    
