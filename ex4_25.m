clear all;
close all;
clc;

d=1600; % distancia entre as base station
n=4;
sigma=6;
d0=1;
di1 = 0:1:d;
di2 = d:-1:0;
xi = rand(size(di1))*sigma;

p0 =0;
pmin = -118;
pho = -112;

mx1 = p0-10*n*log10(di1/d0);
mx2 = p0-10*n*log10(di2/d0);

pr1 = mx1 + xi;
pr2 = mx2 + xi;

prob1 = qfunc((mx1 - pho)/sigma);
prob2 = qfunc((pmin - mx2)/sigma);

prob = prob1 .* prob2;

m_pmin = ones(1,1601)*pmin;
m_pho = ones(1,1601)*pho;

figure(1)
plot(di1,pr1)
hold on
plot(di1,pr2)
hold on
plot(di1,m_pmin);
hold on
plot(di1,m_pho);

figure(2)
plot(di1,prob)
