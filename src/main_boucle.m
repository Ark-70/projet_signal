%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PROJET SIGNAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;clc;close all;

addpath('tools','../data');
%load('fcno03fz.mat');
%Fs= 8000;
[sig,Fs] = audioread('CAMSON2.wav');

%% VARIABLES

moyenne = 0;
signal = sig';
winlen = 512;

%Ajout de bruit blanc
%{
rsb = 5; %Rapport signal sur bruit. 
sig_bruit5=bruitage(signal,rsb);
audiowrite('sigbruit.wav',signal, Fs)
%}

%On estime la variance du bruit :
var_n = var(signal(1:1E3)); %On pend le debut ou il n'y a pas de parole.

%On decoupe pour conserver les données d'interet.
signal = signal(1E4:4E4);
audiowrite('sig.wav',signal, 8000)


%Dimention de la matrice de Hankel

M = winlen;

tramelen = M*10;
Total = tramelen;
L = Total - M;


%Nombre de valeur sigulière qu'on consrve.

for K=10:5:60

%% TRAITEMENT

%On sépare le signal en trames :
trames = SignalToTrames(signal,tramelen,0)';
rcv_trames = [];

%% On traite toute les trames séparement
for trame = trames
%Creation de la matrice de Hankel

    Hy = myHankel(trame,M);

    [U,S,V] = svd(Hy);

    Sk = S;
    Sk(K-1:L,K-1:M)=0;


    Hs = U*Sk*V';

    %Première option : Sans prendre en compte le rapport signal sur bruit
    %rcv_signal = restore(Hs);
    %rcv_trames = cat(2,rcv_trames,rcv_signal);

    %Deuxième option :En en compte le rapport signal sur bruit

    Fm = eye(L);

    for ii=1:M
        if(S(ii,ii)>0), Fm(ii,ii) = 1-(var_n./S(ii,ii))^2;end
    end

    Hs_fm = U*Fm*Sk*V';
    rcv_signal2 = restore(Hs_fm);
    rcv_trames = cat(2,rcv_trames,rcv_signal2);


end

%% On reconsruit le signal

rcv_signal =  TramesToSignal(rcv_trames,0);
save("../savedData/methode2/winlen1024/data/SigForkequal_"+int2str(K)+".mat","rcv_signal","K","winlen");
%audiowrite("../savedData/methode1/winlen1024/wav/SigForkequal_"+int2str(K)+".wav",rcv_signal, Fs)

end
