clear all;
close all;
clc;

rs = 100e3; % taxa de simbolo da entrada do canal/taxa de transmissao 
ts = 1/rs; % tempo de simbolo
SNR = 10;
num_sim = 1e5; % numero de simbolos a ser transmitidos
t = [0:ts:num_sim/rs-(ts)];
doppler = 10; %fd                                                                                                             ; % parametro Riciano
M = 2; %ordem da modulação M = representa geração de bits

info = randi(M,num_sim,1)-1; %gerando informação a ser transmitida
info_mod = pskmod(info,M); %utilizando uma função que faz a modulação PSK (modulação digital em fase)

canal_ray = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray2 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray3 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray4 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray5 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray6 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal

canal_ray.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray2.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray3.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray4.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray5.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray6.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
sinal_rec_ray = filter(canal_ray, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray2 = filter(canal_ray2, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray3 = filter(canal_ray3, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray4 = filter(canal_ray4, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray5 = filter(canal_ray5, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray6 = filter(canal_ray6, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio

ganho_ray = canal_ray.PathGains; % salvando os ganhos do canal
ganho_ray2 = canal_ray2.PathGains; % salvando os ganhos do canal
ganho_ray3 = canal_ray3.PathGains; % salvando os ganhos do canal
ganho_ray4 = canal_ray4.PathGains; % salvando os ganhos do canal
ganho_ray5 = canal_ray5.PathGains; % salvando os ganhos do canal
ganho_ray6 = canal_ray6.PathGains; % salvando os ganhos do canal
ganho_eq = max(ganho_ray,ganho_ray2);
ganho_eq = max(ganho_ray3,ganho_eq);
ganho_eq = max(ganho_ray4,ganho_eq);
ganho_eq = max(ganho_ray5,ganho_eq);
ganho_eq = max(ganho_ray6,ganho_eq);
figure(1)
plot(20*log10(abs(ganho_ray)))
hold on
plot(20*log10(abs(ganho_ray2)))
hold on
plot(20*log10(abs(ganho_ray3)))
hold on
plot(20*log10(abs(ganho_ray4)))
hold on
plot(20*log10(abs(ganho_ray5)))
hold on
plot(20*log10(abs(ganho_ray6)))
hold on
plot(20*log10(abs(ganho_eq)),'.')
% sinal_rec_ray_awgn = awgn(sinal_rec_ray,SNR); % Modelando a inserção do ruido branco no sinal recebido
% sinal_rec_ray_awgn2 = awgn(sinal_rec_ray2,SNR); % Modelando a inserção do ruido branco no sinal recebido
% sinalEqRay = sinal_rec_ray_awgn./ganho_ray;
% sinalEqRay2 = sinal_rec_ray_awgn2./ganho_ray2;
% sinalDemRay = pskdemod(sinalEqRay,M);
% sinalDemRay2 = pskdemod(sinalEqRay2,M);

