%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PROJET SIGNAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all ;clc;close all;

addpath('../data');
load('fcno03fz.mat');

%% VARIABLES
var_n = 1;
moyenne = 0;
signal = fcno03fz';
winlen = 1024;


%Genreation d'un signal test avec bruit blanc pour faire des tests avec un
%signal non bruité ou se genre de baille t'as capté ?

%{
signaltest = sin(length(signal));
bruit = (randn(1,length(signal))*var_n)+moyenne;

signal = signaltest + bruit;
%}

%On decoupe pour conserver les données d'interet.
% signal = signal(1E4:11E4);
%audiowrite('sig.wav',signal, 8000)


%Dimensions de la matrice de Hankel

M = winlen;

tramelen = 1025;
Total = tramelen;
L = Total - M;


%Nombre de valeur sigulière qu'on consrve.
K = 200;


%% TRAITEMENT

%On sépare le signal en trames :
trames = SignalToTrames(signal,tramelen,0)';
rcv_trames = [];

%% On traite toute les trames séparement
matrix_of_all_VS = [];

for i=1:size(trames, 2) % "trames" = Matrice(nb_trames_en_ligne, valeur_de_chaque_trame_en_col)
%Creation de la matrice de Hankel
    trame = trames(:, i);

    hankel_of_trame = myHankel(trame,M);

    [U,S,V] = svd(hankel_of_trame);

    vecteur_VS = diag(S)'; %vecteur des val singulieres en colonnes

    matrix_of_all_VS = [matrix_of_all_VS vecteur_VS]; % matrice de VS avec de bas en haut l'importance de la valeur de gauche à droite le temps

end

figure, plot(matrix_of_all_VS);
return;
    %
    % Sk = S;
    % Sk(K-1:L,K-1:M)=0;
    %
    %
    % Hs = U*Sk*V';
    %
    % %Première option : Sans prendre en compte le rapport signal sur bruit
    % rcv_signal = restore(Hs);
    % rcv_trames = cat(2,rcv_trames,rcv_signal);

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

% end

%% On reconsruit le signal
rcv_signal =  TramesToSignal(rcv_trames,0);

%% AFFICHAGES

figure, plot(signal,'b');
hold on
plot(rcv_signal,'r');
title("Signals");
legend('Signal original','Signal debruité');
audiowrite('sig_nonrehausse.wav',rcv_signal, 8000)


figure,subplot(2,1,1); spectrogram(signal,'yaxis');
subplot(2,1,2); plot(signal);
title("Signal original");


figure,subplot(2,1,1); spectrogram(rcv_signal,'yaxis');
subplot(2,1,2); plot(rcv_signal);
title("Signal debruité");

%% Rehaussement du signal (c'est probablement de la merde)

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
