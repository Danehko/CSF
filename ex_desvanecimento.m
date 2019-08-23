clear all
close all
clc

rs = 100e3; % taxa de transmissao
ts = 1/rs;  % tempo de simbolo
num_bits = 1e6; 
t = [0:ts:num_bits/rs-(ts)];
doppler = 100; %
%tau = [0 1 2 5]*1e-6; % vetor de atraso de sinal
%pdb = [-20 -10 -10 0]; % potencia em db

info = randi(2,1,num_bits)-1;
info_mod = pskmod(info,2); 
canal = rayleighchan(ts, doppler);
%canal = rayleighchan(tb, doppler,tau, pdb);
canal.StoreHistory = 1;
sinal_rec = filter(canal, info_mod);

%plot(canal)

ganho = canal.PathGains;
figure(1)
subplot(2,3,1)
hist(real(ganho), 100)
subplot(2,3,2)
hist(imag(ganho), 100)
subplot(2,3,3)
hist(abs(ganho), 100)
subplot(2,3,4)
hist(angle(ganho), 100)
subplot(2,3,5)
plot(t,20*log10(abs(ganho)))