clear all
close all
clc

rb = 2e6;
tb = 1/rb
sigma = 0.1*tb

%b
fc = 5.8e9;
v = (30*1.6)/3.6;
lamda = 3e8/fc;
fm = v/lamda; %frequencia maxima doppler
tc = 0.423/fm

%d
bits = tc/tb

