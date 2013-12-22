function fOut = fAdjust(fIn)
fCentrales = [195.998 207.652 220 233.082 246.942 261.626 277.183 293.665 311.127 329.628 369.994 391.995 415.305];
if fIn == 0
    fOut = 0;
else
    distancias = abs(fCentrales-fIn);
    [d i] = min(distancias);
    fOut = fCentrales(i);
end