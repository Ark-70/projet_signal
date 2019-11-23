function [trames] = TramesToSignal(trames,mode)

    signal=[];
    [nb_trames , glissiere_len] = size(trames);
    %% Mode 0 si 50% de recouvrememnt
    if(mode==0)
        for ii = 1:nb_trames
            signal = [signal  trames(ii,:)];
        end
    end
    

    %% Mode 1 si pas de recouvrement
    if(mode==1)
        signal = [signal trames(1,round(glissiere_len)/2)];
        for ii = 1:nb_trames
            signal = [signal (trames(ii,ii+round(glissiere_len)/2)+trames(ii,ii+round(glissiere_len)/2))/2 ];
        end
    end

end