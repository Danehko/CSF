clear all
close all
clc

M = 2;
num_sim = 1000;
rs = 10e3; % taxa de simbolo da entrada do canal/taxa de transmissao 
ts = 1/rs; % tempo de simbolo
doppler = 100; %fd   

info = randi([0 M-1], num_sim, 1); %gerando informação a ser transmitida
info_mod = pskmod(info, M);

info_mod_i = info_mod(1:2:end);
info_mod_p = info_mod(2:2:end);

info_tx_1 = zeros(size(info));
info_tx_2 = zeros(size(info));

info_tx_1(1:2:end) = info_mod_i;
info_tx_1(2:2:end) = -conj(info_mod_p);
info_tx_2(1:2:end) = info_mod_p;
info_tx_2(2:2:end) = conj(info_mod_i);

canal_ray = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray2 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal

canal_ray.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray2.StoreHistory = 1; % hablitando a gravação dos ganhos de canal

sinal_rec_ray = filter(canal_ray, info_tx_1); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray2 = filter(canal_ray2, info_tx_2); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio

ganho_ray = canal_ray.PathGains; % salvando os ganhos do canal
ganho_ray2 = canal_ray2.PathGains; % salvando os ganhos do canal

for SNR = 100:100
    sinal_rec_ray_awgn = awgn(sinal_rec_ray,SNR);
    sinal_rec_ray_awgn2 = awgn(sinal_rec_ray2,SNR);
    
    r0 = zeros(size(info));
    r0(1:2:end) = sinal_rec_ray_awgn(1:2:end).*ganho_ray(1:2:end);
    r0(2:2:end) = sinal_rec_ray_awgn2(1:2:end).*ganho_ray2(1:2:end);
    
    r1 = zeros(size(info));
    r1(1:2:end) = conj(sinal_rec_ray_awgn2(2:2:end)).*-ganho_ray(2:2:end);
    r1(2:2:end) = conj(sinal_rec_ray_awgn(2:2:end)).*ganho_ray2(2:2:end);
    
    s0 = conj(ganho_ray(1:2:end)).*r0(1:2:end) + ganho_ray2(2:2:end).*conj(r1(2:2:end));
    s1 = conj(ganho_ray2(1:2:end)).*r0(1:2:end) - ganho_ray(2:2:end).*conj(r1(2:2:end));
    s = zeros(size(info));
    s(1:2:end) = s0;
    s(2:2:end) = s1;
    sinal_demod = pskdemod(s,M);
end