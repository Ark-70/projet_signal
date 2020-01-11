%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% PREMBULES   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear;

addpath('tools','../data');
load('fcno04fz.mat');

%% VARIABLES
var_n = 1;
moyenne = 0;
signal = fcno04fz';

%Generation d'un bruit blanc
bruit = (randn(1,length(signal))*var_n)+moyenne;

%% PRELIMINAIRE 1

%Correlations
CorrBruit_th = zeros(1,length(signal));
CorrBruit_th(floor(length(signal)/2)) = 1;

[CorrBruit_biased, lags_biased] = xcorr(bruit,'biased');

[CorrBruit_unb, lags_unb] = xcorr(bruit,'unbiased');


%Affichage des Autocorrelation.
%{
subplot(2,2,1); plot(linspace(-1,1,length(signal)), CorrBruit_th);
ylim([-0.5 1.1]), xlabel('temps (en s)'), ylabel('U²'), title("Corrélation théorique ");
subplot(2,2,2); plot(lags_biased, CorrBruit_biased);
ylim([-0.5 1.1]),xlabel('temps (en s)'), ylabel('U²'), title("Méthode biaisé ");
subplot(2,2,3); plot(lags_unb, CorrBruit_unb);
ylim([-0.5 1.1]),xlabel('temps (en s)'), ylabel('U²'), title("Méthode non biaisé");
sgtitle("Corrélation d'un bruit blanc");
%}

%Periodogramme Daniell
DSP_daniell = pnegru(bruit);
%figure ,plot(linspace(-1,1,length(DSP_daniell)),DSP_daniell);


%DentsitÃ© spectale
window = 500;
DSP_welch = (pwelch(bruit,window))';

%figure , plot(linspace(-1,1,length(DSP_welch)*2),[fliplr(DSP_welch), DSP_welch]);


%Periodogramme bartlett
DSP_bartlett = pbartlett(bruit);
%figure ,plot(linspace(-1,1,length(DSP_bartlett)),DSP_bartlett);


%Affichage des Autocorrelation.
%{
subplot(2,2,1); plot(linspace(-1,1,length(DSP_bartlett)),DSP_bartlett);
xlabel('temps (en s)'), ylabel('U²'), title("Périodogramme de Bartlett");
subplot(2,2,2); plot(linspace(-1,1,length(DSP_welch)*2),[fliplr(DSP_welch), DSP_welch]);
xlabel('temps (en s)'), ylabel('U²'), title("Périodogramme de Welch");
subplot(2,2,3); plot(linspace(-1,1,length(DSP_daniell)),DSP_daniell);
xlabel('temps (en s)'), ylabel('U²'), title("Périodogramme de Daniell,");
sgtitle("Densité spectrales de puissance d'un bruit blanc");
%}


%Correlogram

% Nothin' :( 


%% PRELIMINAIRE 2

rsb = 5; %Rapport signal sur bruit. 
sig_bruit5=bruitage(signal,rsb);
rsb = 10; 
sig_bruit10=bruitage(signal,rsb);
rsb = 15;  
sig_bruit15=bruitage(signal,rsb);


%Affichage des sig bruit.

%{
figure(2)
subplot(4,2,1); spectrogram(signal, 'yaxis'), caxis([0 70]),title("Sigal original"); 
subplot(4,2,3); plot(signal), xlabel('temps (en s)'), ylabel('Amplitude');
subplot(4,2,2); spectrogram(sig_bruit15, 'yaxis'), xlabel(''), ylabel(''), caxis([0 70]), title("Sigal bruité (rsb = 15)");
subplot(4,2,4); plot(sig_bruit15);
subplot(4,2,5); spectrogram(sig_bruit10, 'yaxis'), xlabel(''), ylabel(''),caxis([0 70]), title("Sigal bruité (rsb = 10)");
subplot(4,2,7); plot(sig_bruit10);
subplot(4,2,6); spectrogram(sig_bruit5, 'yaxis'), xlabel(''), ylabel(''), caxis([0 70]), title("Sigal bruité (rsb = 5)");
subplot(4,2,8); plot(sig_bruit5);
sgtitle("Spectogrames et représentaions temporelles d'un signal");
%}

%COMMENTAIRE : La puissance des petites frÃ©quence augmente. Le rÃ©sultas est
%plus visible lorsqu'on augmente la variance du bruit. 

%% PREEMBULE 2.4

%Coupe un signal en trames de len 50
trames = SignalToTrames(signal,50,0);

rec_signal = TramesToSignal(signal,0); %J'ai pas fini le mode 1 (50% de recouvrement)

err = sum(rec_signal - signal);

