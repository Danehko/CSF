clear all;
close all;
clc;

rs = 100e3; % taxa de simbolo da entrada do canal/taxa de transmissao 
ts = 1/rs; % tempo de simbolo
SNR = 10;
num_sim = 1e6; % numero de simbolos a ser transmitidos
t = [0:ts:num_sim/rs-(ts)];
doppler = 300; %fd 
k = 100; % parametro Riciano
M = 2; %ordem da modulação M = representa geração de bits

imagem = imread('teste.png');
figure(1)
image(imagem);

imagem_serial = reshape(imagem, 1 ,[]);
imagem_bin = de2bi(imagem_serial);
imagem_bin_serial = reshape(imagem_bin,1,[]);
info = transpose(double(imagem_bin_serial));

info_mod = pskmod(info,M); %utilizando uma função que faz a modulação PSK (modulação digital em fase)
canal_ray = rayleighchan(ts, doppler);% gerando o objeto que representa o canal
canal_ric = ricianchan(ts, doppler, k);
canal_ray.StoreHistory = 1; % hablitando a gravação dos ganhos de canal
canal_ric.StoreHistory = 1;
sinal_rec_ray = filter(canal_ray, info_mod); %esta função representa  o ato de transmitir um sinal modulado por um canal sem fio
sinal_rec_ric = filter(canal_ric, info_mod);
ganho_ray = canal_ray.PathGains; % salvando os ganhos do canal
ganho_ric = canal_ric.PathGains;

sinal_rec_ray_awgn = awgn(sinal_rec_ray,SNR); % Modelando a inserção do ruido branco no sinal recebido
sinal_rec_ric_awgn = awgn(sinal_rec_ric,SNR);
sinalEqRay = sinal_rec_ray_awgn./ganho_ray; % (equalizando)eliminando os efeitos de rotação de fase e alteração de amplite no sinal recebido
sinalEqRic = sinal_rec_ric_awgn./ganho_ric;
sinalDemRay = pskdemod(sinalEqRay,M);% demodulando o sinal equalizado
sinalDemRic = pskdemod(sinalEqRic,M);
inf_rxRay = transpose(sinalDemRay);
inf_rxRic = transpose(sinalDemRic);
inf_rxRay = uint8(inf_rxRay);
inf_rxRic = uint8(inf_rxRic);
inf_8_rxRay = reshape(inf_rxRay,[],8);
inf_8_rxRic = reshape(inf_rxRic,[],8);
inf_de_rxRay = bi2de(inf_8_rxRay);
inf_de_rxRic = bi2de(inf_8_rxRic);
inf_de_rxRay = transpose(inf_de_rxRay);
inf_de_rxRic = transpose(inf_de_rxRic);
imagem_Ray =reshape(inf_de_rxRay,size(imagem));
imagem_Ric =reshape(inf_de_rxRic,size(imagem));
figure(2)
subplot(1,2,1);
image(imagem_Ray)
subplot(1,2,2);
image(imagem_Ric)

[num_ray, taxa_ray]  =symerr(info,sinalDemRay) % comparando a sequencia de informação gerada com a informação demodulada
[num_ric, taxa_ric]  =symerr(info,sinalDemRic)