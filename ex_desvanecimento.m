clear all
close all
clc

rb = 1e3; %taxa de transmissao
tb = 1/rb;  %tempo de bit
doppler = 30; %
tau = [0 1 2 5]*1e-6; % vetor de atraso de sinal
pdb = [-20 -10 -10 0]; %potencia em db

info = randint(1,100,2);
info_mod = pskmod(info,2); 
canal = rayleighchan(tb, doppler,tau, pdb);
canal.StoreHistory = 1;
sinal_rec = filter(canal, info_mod);

plot(canal)