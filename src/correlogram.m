function [psignal] = correlogram(signal)

    
    glissiere_len = 50;
    psignal = zeros(1, length(signal));
    
    for i = 1:glissiere_len:(length(signal)-glissiere_len)
        segments_signal = fftshift(fft(signal(i:i+glissiere_len),1));
        psignal(i) = mean(segments_signal.^(2)/glissiere_len);
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BIBLIOGARPHIE %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% https://staffwww.dcs.shef.ac.uk/people/N.Ma/resources/correlogram/  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%