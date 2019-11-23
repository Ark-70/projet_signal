function [sig_bruit] = bruitage(signal,rsb)

%%TO DO : trouver le lien entre la varincedu bruit et le rapport
%%signal/bruit

var_n = 1;
moyenne = 0;

%Genreation d'un bruit blanc
bruit = (randn(1,length(signal))*var_n)+moyenne;

sig_bruit=bruit+signal;
    
end

