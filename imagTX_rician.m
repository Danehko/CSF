clear all;
close all;
clc;

rs = 10e3; % taxa de simbolo da entrada do canal/taxa de transmissao 
ts = 1/rs; % tempo de simbolo
SNR = [100 100 0 10];
num_sim = 1e6; % numero de simbolos a ser transmitidos
t = [0:ts:num_sim/rs-(ts)];
doppler = 4; %fd 
k = [1 1000 1000 1]; % parametro Riciano
M = 2; %ordem da modulação M = representa geração de bits

imagem = imread('teste.png');
figure(1)
image(imagem);
imagem_serial = reshape(imagem, 1 ,[]);
imagem_bin = de2bi(imagem_serial);
imagem_bin_serial = reshape(imagem_bin,1,[]);
info = transpose(double(imagem_bin_serial));

%info = randi(M,num_sim,1)-1; %gerando informação a ser transmitida
info_mod = pskmod(info,M); %utilizando uma função que faz a modulação PSK (modulação digital em fase)
for n = 1:4
    canal_ric = ricianchan(ts, doppler, k(n));
    canal_ric.StoreHistory = 1;
    sinal_rec_ric = filter(canal_ric, info_mod);
    ganho_ric = canal_ric.PathGains;

    sinal_rec_ric_awgn = awgn(sinal_rec_ric,SNR(n));
    sinalEqRic = sinal_rec_ric_awgn./ganho_ric;
    sinalDemRic = pskdemod(sinalEqRic,M);
    inf_rxRic = transpose(sinalDemRic);
    inf_rxRic = uint8(inf_rxRic);
    inf_8_rxRic = reshape(inf_rxRic,[],8);
    inf_de_rxRic = bi2de(inf_8_rxRic);
    inf_de_rxRic = transpose(inf_de_rxRic);
    imagem_Ric =reshape(inf_de_rxRic,size(imagem));
    figure(n+1)
    image(imagem_Ric)
end