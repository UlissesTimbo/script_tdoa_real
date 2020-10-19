clear all;clc;
%% Config File for TDOA setup
h_ref=8;
% RX and TX Position
rx1_lat = -22.955278; % RX ime
rx1_long = -43.166389;
h1=31;
z1=h1-h_ref;

rx2_lat = -22.954167; % RX epv
rx2_long = -43.166667;
h2=55;
z2=h2-h_ref;


rx3_lat = -22.951667; % RX pão de açúcar E1
rx3_long = -43.165000;
h3=214;
z3=h3-h_ref;

rx4_lat = -22.949444; % RX pão de açúcar E2
rx4_long = -43.156389;
h4=394;
z4=h4-h_ref;

% signal processing parameters
interpol_factor = 10;
%time_stamps do menor pro maior
time_stamp1=336762141;
time_stamp2=359779977;
time_stamp3=430616899;
%sample_rate in Hz
sample_rate=2048000;
% heatmap (only with google maps)
heatmap_resolution = 400; % resolution for heatmap points

file_identifier = 'test.dat';
