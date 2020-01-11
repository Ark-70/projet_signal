%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PROJET SIGNAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;clc;close all;

addpath('tools','../data');
%load('fcno03fz.mat');  %Fs = 8000, bien pensé décommenté pour l'utiliser !
[sig,Fs] = audioread('CAMSON2.wav');

%% VARIABLES
signal = sig';
%Fs = 8000; % A decommenter si load fcno
winlen = 1024;

%Ajout de bruit blanc
rsb = 5; %Rapport signal sur bruit. 
sig_bruit5=bruitage(signal,rsb);

%On decoupe pour conserver les données d'interet / pour que le scipt complie plus vite
signal = signal(1E4:4E5);
audiowrite('sig.wav',signal, Fs)


%Dimention de la matrice de Hankel
M = winlen;
tramelen = 1024*10;
Total = tramelen;
L = Total - M;  

%Nombre de valeur siguliÃ¨re qu'on consrve. 
K = 400;


%% TRAITEMENT

%On sÃ©pare le signal en trames : 
trames = SignalToTrames(signal,tramelen,0)';
rcv_trames = [];

%% On traite toute les trames sÃ©parement
for trame = trames
%Creation de la matrice de Hankel

    Hy = myHankel(trame,M);

    [U,S,V] = svd(Hy);

    Sk = S;
    Sk(K-1:L,K-1:M)=0;
  
    
    Hs = U*Sk*V';

    %PremiÃ¨re option : Sans prendre en compte le rapport signal sur bruit
    rcv_signal = restore(Hs);
    rcv_trames = cat(2,rcv_trames,rcv_signal);
    
    %DeuxiÃ¨me option :En en compte le rapport signal sur bruit
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
legend('Signal original','Signal debruitÃ©');
audiowrite('sig_nonrehausse.wav',2*rcv_signal, Fs)


figure,subplot(2,1,1); spectrogram(signal,'yaxis');
subplot(2,1,2); plot(signal);
title("Signal original");


figure,subplot(2,1,1); spectrogram(rcv_signal,'yaxis');
subplot(2,1,2); plot(rcv_signal);
title("Signal debruitÃ©");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Dans le rapport, il y a érit :                                           %
%    Il suffit alors de considérer les échantillons de la première        %
%       colonne et de la dernière ligne pour obtenir la trame rehaussée.  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Rehaussement du signal (c'est probablement de la merde)

%{
%Threshold
rcv_signal_rehaus= rcv_signal.*1E50.*(abs(rcv_signal)>=2500) + rcv_signal.*(abs(rcv_signal)<2500);

figure, plot(signal,'b');
hold on
plot(rcv_signal_rehaus,'r');
title("Signals");
legend('Signal original','Signal RehaussemÃ©');
audiowrite('truc.wav',rcv_signal_rehaus, 8000)

figure,subplot(2,1,1); spectrogram(rcv_signal_rehaus,'yaxis');
subplot(2,1,2); plot(rcv_signal_rehaus);
title("Signal RehaussemÃ©");
%}
