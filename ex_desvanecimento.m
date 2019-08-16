clear all
close all
clc

tx = 1/10000; %taxa de transmissao
doppler = 30; %

info = randint(1,5000,2);
info_mod = pskmod(info,2); 
canal = rayleighchan(tx, doppler);
canal.StoreHistory = 1;
sinal_rec = filter(canal, info_mod);

plot(canal)