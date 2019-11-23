%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PROJET SIGNAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear;

addpath('../data');
load('fcno03fz.mat');

%% VARIABLES
var_n = 1;
moyenne = 0;
signal = fcno03fz';

%Genreation d'un bruit blanc
bruit = (randn(1,length(signal))*var_n)+moyenne;

%% PRELIMINAIRE 1

%Correlations
CorrBruit_th = zeros(1,length(signal));
CorrBruit_th(floor(length(signal)/2)) = 1;

[CorrBruit_biased, lags_biased] = xcorr(bruit,'biased');

[CorrBruit_unb, lags_unb] = xcorr(bruit,'unbiased');

%Periodogramme Daniell
DSP_daniell = pnegru(bruit);
%figure ,plot(linspace(-1,1,length(DSP_daniell)),DSP_daniell);


%Dentsité spectale
window = 500;
DSP_welch = (pwelch(bruit,window))';

%figure , plot(linspace(-1,1,length(DSP_welch)*2),[fliplr(DSP_welch), DSP_welch]);


%Periodogramme bartlett
DSP_bartlett = pbartlett(bruit);
figure ,plot(linspace(-1,1,length(DSP_bartlett)),DSP_bartlett);

%Correlogram




%% Affichage

%Affichage des Autocorrelation.

%{
subplot(3,1,1); plot(linspace(-1,1,length(signal)), CorrBruit_th);
subplot(3,1,2); plot(lags_biased, CorrBruit_biased);
subplot(3,1,3); plot(lags_unb, CorrBruit_unb);
%}

%Affichage des Densité spetrales.
%{
figure; plot(SpctPuiss);
%}

%%DSP
%{
    figure (5)
    subplot(211);
    semilogy(DSP_Ss);
    subplot(212);
    semilogy(linspace(0,Fe*0.1/2,200),ones(1,200));
    ylabel('ampitude');
    xlabel('f');
    title('DSP théorique de Ss');
    figure (6)
    subplot(211);
    semilogy(linspace(0,Fe*0.1/2,8192),DSP_th_Sl);
    ylabel('ampitude');
    xlabel('f en Hz*10');
    title('DSP théorique de Sl');
    subplot(212);
    semilogy(DSP_Sl);
    ylabel('ampitude');
    xlabel('f en Hz*10');
    title('DSP de Sl');
%}

%% PRELIMINAIRE 2

rsb = 5; %Rapport signal sur bruit. 

sig_bruit=bruitage(signal,rsb);

figure(1)
subplot(1,2,1); spectrogram(sig_bruit,'yaxis');
subplot(1,2,2); plot(sig_bruit);

figure(2)
subplot(1,2,1); spectrogram(signal,'yaxis');
subplot(1,2,2); plot(signal);

%COMMENTAIRE : La puissance des petites fréquence augmente. Le résultas est
%plus visible lorsqu'on augmente la variance du bruit. 

%% PREEMBULE 2.4

%Coupe un signal en trames de len 50
trames = SignalToTrames(signal,50,0);

rec_signal = TramesToSignal(signal,0); %J'ai pas fini le mode 1 (50% de recouvrement)

err = sum(rec_signal - signal);

