function [psignal] = pnegru(signal)

    glissiere_len = 500;
    signal_f = fftshift(fft(signal, 512));
    signal_f_padd = [signal_f(end-glissiere_len/2:end) signal_f signal_f(1:glissiere_len/2)];

    psignal = zeros(1, length(signal_f));

    for i = 1:length(signal_f)
        glissiere_signal = signal_f_padd(i:i+glissiere_len);
        psignal(i) = mean(glissiere_signal);
    end
end