%%%%%%%%%%%%%%%%%%%%%%%%%%   DRAW DATA   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Pour analyser l'influence des paramtères, nous avons recolté des données
%%% Nous avons fait variées plusieurs paramtères. (Taille des trames, K ..)
%%% Ces données sont stocké dans dataSaved
%%% Le fichiers contients toutes nos tests tiré. La hirarchi des fichier donnes les
%%% Cette fonction permet de les tracés.
%%% Des fichiers audio vont être cree.
%%% Pour des reson d'economie de stockage, veillez les supprimer après utilisation

clear all ;clc;close all;

addpath('../data');
load('fcno03fz.mat');
signal = fcno03fz';
signal = signal(1E4:4E4);

%% Paramtères  A choisir

methods = [1];  %Possible value : 1 ou 2

winlens = [256]; %Possible value : 256,512,1024 

Ks = fliplr(10:50:200);  %Possible value : toute les valeurs de 10:5:60 et 10:50:500.


%% Tracé le signal :


figure, plot(signal,'b','DisplayName','Signal Original');
hold on

for winlen = winlens
  for K  = Ks
      for method = methods
        load("../savedData/methode"+int2str(method)+"/winlen"+int2str(winlen)+"/data/SigForkequal_"+int2str(K)+".mat");
        plot(rcv_signal,'DisplayName',"Winlen = "+int2str(winlen)+"& K = "+int2str(K)+"^"+int2str(method));
      end
  end
end
legend
title("Signals");
hold off

%% Sig + specrtograme

nb_fig = length(winlens) + length(Ks);

figure,subplot(nb_fig,2,2); spectrogram(signal,'yaxis');
subplot(nb_fig,2,1); plot(signal);

id = 3;
for winlen = winlens
  for K  = Ks
    load("../savedData/methode"+int2str(method)+"/winlen"+int2str(winlen)+"/data/SigForkequal_"+int2str(K)+".mat");
    subplot(nb_fig,2,id+1); spectrogram(rcv_signal,'yaxis');
    title("Winlen = "+int2str(winlen)+"& K = "+int2str(K));
    subplot(nb_fig,2,id); plot(rcv_signal);
    id = id+2;
  end
end


%% Audiowrite

%%Après utilisation, supprmer le .wav, pas le dossier. 
for winlen = winlens
  for K  = Ks
    load("../savedData/methode"+int2str(method)+"/winlen"+int2str(winlen)+"/data/SigForkequal_"+int2str(K)+".mat");
    audiowrite("../savedData/methode"+int2str(method)+"/winlen"+int2str(winlen)+"/data/SigForkequal_"+int2str(K)+".wav",rcv_signal, 8000);
  end
end


