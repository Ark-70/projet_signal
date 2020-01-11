%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PROJET SIGNAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;clc;close all;

addpath('tools','../data');
%load('fcno03fz.mat');  %Fs = 8000, bien pens� d�comment� pour l'utiliser !
[sig,Fs] = audioread('CAMSON2.wav');

%% VARIABLES
signal = sig';
%Fs = 8000; % A decommenter si load fcno
winlen = 1024;

%Ajout de bruit blanc
rsb = 5; %Rapport signal sur bruit. 
sig_bruit5=bruitage(signal,rsb);

%On decoupe pour conserver les donn�es d'interet / pour que le scipt complie plus vite
signal = signal(1E4:4E5);
audiowrite('sig.wav',signal, Fs)


%Dimention de la matrice de Hankel
M = winlen;
tramelen = 1024*10;
Total = tramelen;
L = Total - M;  

%Nombre de valeur sigulière qu'on consrve. 
K = 400;


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
    rcv_signal = restore(Hs);
    rcv_trames = cat(2,rcv_trames,rcv_signal);
    
    %Deuxième option :En en compte le rapport signal sur bruit
    %{
    Fm = eye(L);
    
    for ii=1:M
        if(S(ii,ii)>0), Fm(ii,ii) = 1-(var_n./S(ii,ii))^2;end
    end

    Hs_fm = U*Fm*Sk*V';
    rcv_signal2 = restore(Hs_fm);
    rcv_trames = cat(2,rcv_trames,rcv_signal2);
    %}
    
    
end

%% On reconsruit le signal
rcv_signal =  TramesToSignal(rcv_trames,0); 

%% AFFICHAGES

figure, plot(signal,'b');
hold on
plot(rcv_signal,'r');
title("Signals");
legend('Signal original','Signal debruité');
audiowrite('sig_nonrehausse.wav',2*rcv_signal, Fs)


figure,subplot(2,1,1); spectrogram(signal,'yaxis');
subplot(2,1,2); plot(signal);
title("Signal original");


figure,subplot(2,1,1); spectrogram(rcv_signal,'yaxis');
subplot(2,1,2); plot(rcv_signal);
title("Signal debruité");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Dans le rapport, il y a �rit :                                           %
%    Il suffit alors de consid�rer les �chantillons de la premi�re        %
%       colonne et de la derni�re ligne pour obtenir la trame rehauss�e.  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Rehaussement du signal (c'est probablement de la merde)

%{
%Threshold
rcv_signal_rehaus= rcv_signal.*1E50.*(abs(rcv_signal)>=2500) + rcv_signal.*(abs(rcv_signal)<2500);

figure, plot(signal,'b');
hold on
plot(rcv_signal_rehaus,'r');
title("Signals");
legend('Signal original','Signal Rehaussemé');
audiowrite('truc.wav',rcv_signal_rehaus, 8000)

figure,subplot(2,1,1); spectrogram(rcv_signal_rehaus,'yaxis');
subplot(2,1,2); plot(rcv_signal_rehaus);
title("Signal Rehaussemé");
%}
