function [sig_bruit] = bruitage(signal,rsb)

%On cherche la variance du bruit par rapport au rsb : 

Psig = sum(abs(signal).^2)/(length(signal));
Pbruitg = 1; %Je ne suis pas sur : P d'un bbgaucien centré
var_n = sqrt((Psig/Pbruitg)*10^(-rsb/10));


%Genreation d'un bruit blanc
bruit = (randn(1,length(signal)).*var_n);
sig_bruit=bruit+signal;
    
end

