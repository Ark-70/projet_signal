function [trames] = SignalToTrames(signal,glissiere_len,mode)

    trames=[];

    %% Mode 0 si pas de recouvrement
    if(mode==0)
        for ii = 1:glissiere_len:(length(signal)-glissiere_len+1)
            trames = [trames ; signal(ii:ii+glissiere_len-1)];
        end
    end

    %% Mode 1 si 50% de recouvrememnt
    if(mode==1)
        for ii = 1:round(glissiere_len/2):(length(signal)-glissiere_len+1)
            trames = [trames ; signal(ii:ii+glissiere_len-1)];
        end
    end

    LastTrame=signal(ii+glissiere_len:end);
    [ii,l]=size(LastTrame);
    LastTrame=[LastTrame zeros(1,glissiere_len-l)];

    trames = [trames ; LastTrame];

end
