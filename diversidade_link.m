clear all;
close all;
clc;

num_sim = 20e3; % numero de simbolos a ser transmitidos
rs = 10e3; % taxa de simbolo da entrada do canal/taxa de transmissao 
ts = 1/rs; % tempo de simbolo
t = [0:ts:num_sim/rs-(ts)];
doppler = 100; %fd                                                                                                             ; % parametro Riciano
M = 2; %ordem da modulação M = representa geração de bits

info = randi(M,num_sim,1)-1; %gerando informação a ser transmitida
info_mod = pskmod(info,M); %utilizando uma função que faz a modulação PSK (modulação digital em fase)

canal_ray = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ray2 = rayleighchan(ts, doppler);% gerando o objeto que representa o canal

canal_ray.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ray2.StoreHistory = 1; % hablitando a gravação dos ganhos de canal

sinal_rec_ray = filter(canal_ray, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ray2 = filter(canal_ray2, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio

ganho_ray = canal_ray.PathGains; % salvando os ganhos do canal
ganho_ray2 = canal_ray2.PathGains; % salvando os ganhos do canal

ganho_eq = zeros(size(ganho_ray));
sinal_demod = zeros(size(info_mod));
for SNR = 0:25
    sinal_rec_ray_awgn = awgn(sinal_rec_ray,SNR);
    sinal_rec_ray_awgn2 = awgn(sinal_rec_ray2,SNR);
    sinalEqRay = sinal_rec_ray_awgn./ganho_ray;
    sinalEqRay2 = sinal_rec_ray_awgn2./ganho_ray2;
    for t = 1:length(info_mod)
        if abs(ganho_ray(t)) > abs(ganho_ray2(t))
            sinal_demod(t) = pskdemod(sinalEqRay(t),M);
            ganho_eq(t) = ganho_ray(t);
        else
            sinal_demod(t) = pskdemod(sinalEqRay2(t),M);
            ganho_eq(t) = ganho_ray2(t);
        end
    end
    sinal_MRC = (sinal_rec_ray_awgn.*conj(ganho_ray) + sinal_rec_ray_awgn2.*conj(ganho_ray2));
    sinal_demod_MRC = pskdemod(sinal_MRC,M);
    sinal_demod_1Tx1Rx = pskdemod(sinalEqRay,M);
    [num(SNR+1), taxa(SNR + 1)] = biterr(info, sinal_demod);
    [num2(SNR+1), taxa2(SNR + 1)] = biterr(info, sinal_demod_1Tx1Rx);
    [num3(SNR+1), taxa3(SNR + 1)] = biterr(info, sinal_demod_MRC);
end

figure(1)
plot(20*log10(abs(ganho_ray)),'b')
hold on
plot(20*log10(abs(ganho_ray2)),'r')
hold on
plot(20*log10(abs(ganho_eq)),'y')

figure(2)
semilogy([0:25],taxa,'b',[0:25],taxa2,'r',[0:25],taxa3,'y');

% ganho_eq = max(ganho_ray,ganho_ray2);
% 
% figure(1)
% plot(20*log10(abs(ganho_ray)))
% hold on
% plot(20*log10(abs(ganho_ray2)))
% hold on
% plot(20*log10(abs(ganho_eq)),'.')