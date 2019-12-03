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
winlen = 100; 

%Dimention de la matrice de Hankel
M = winlen;


%Genreation d'un bruit blanc
bruit = (randn(1,length(signal))*var_n)+moyenne;

%% TRAITEMENT

%Creation de la matrice de Hankel

Hs = Hankel(signal,M);

