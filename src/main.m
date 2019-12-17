%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PROJET SIGNAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../data');
load('fcno03fz.mat');

%% VARIABLES
var_n = 50;
moyenne = 0;
signal = fcno03fz';
winlen = 1024;


%Genreation d'un bruit blanc
bruit = (randn(1,length(signal))*var_n)+moyenne;

signal = signal + bruit; 

%On decoupe pour conserver les données d'interet. 
signal = signal(1E4:4E4);

%Dimention de la matrice de Hankel

M = winlen;

tramelen = 1024*10;
Total = tramelen;
L = Total - M;  


%Nombre de valeur sigulière qu'on consrve. 
K = 0.9*Total;


%% TRAITEMENT

%On sépare le signal en trames : 
trames = SignalToTrames(signal,tramelen,1)';
rcv_trames = [];

for trame = trames
%Creation de la matrice de Hankel

    Hy = myHankel(trame,M);

    [U,S,V] = svd(Hy);

    Sk = S;
    Sk(K-1:M,K-1:M)=0;
   
    
    Hs = U*Sk*V';

    %Fm = eye(L);
    %%
    %for ii=1:M
     %   if(S(ii,ii)>0), Fm(ii,ii) = 1-(var_n./S(ii,ii))^2;end
    %end

    %Hs_fm = U*Fm*S*V;

    rcv_signal = restore(Hs);
    %rcv_signal2 = restore(Hs_fm);
    
    rcv_trames = cat(2,rcv_trames,rcv_signal);
    
end

rcv_signal =  TramesToSignal(rcv_trames,1); 


hold on
plot(signal,'b');
plot(rcv_signal,'r');


