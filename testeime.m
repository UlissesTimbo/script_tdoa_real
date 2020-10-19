% =========================================================================
%  Experimental Evaluation Script for RTL-SDR based TDOA
% =========================================================================

clear;clc;close all;
format long;
% adds subfolder with functions to PATH
[p,n,e] = fileparts(mfilename('fullpath'));
addpath([p '/functions']);


%% Read Parameters from config file, that specifies all parameters
%---------------------------------------------

configime;

% calculate geodetic reference point as mean center of all RX positions
geo_ref_lat  = mean([rx1_lat, rx2_lat, rx3_lat, rx4_lat]);
geo_ref_long = mean([rx1_long, rx2_long, rx3_long, rx4_long]);

% x, y 
[x1, y1] = latlong2xy( rx1_lat, rx1_long, geo_ref_lat, geo_ref_long );
[x2, y2] = latlong2xy( rx2_lat, rx2_long, geo_ref_lat, geo_ref_long );
[x3, y3] = latlong2xy( rx3_lat, rx3_long, geo_ref_lat, geo_ref_long );
[x4, y4] = latlong2xy( rx4_lat, rx4_long, geo_ref_lat, geo_ref_long );

P=[x1 x2 x3 x4
   y1 y2 y3 y4
   z1 z2 z3 z4];

M = size(P,2); %number of sensors 

%generating signal
Ps=[-180;-120;1.5;];
plot3([P(1,:)],[P(2,:)],[P(3,:)],'ob','linewidth',4); hold on
plot3(Ps(1),Ps(2),Ps(3),'pr','linewidth',4); hold on
xlabel('Axis x') 
ylabel('Axis y') 
zlabel('Axis z') 
v=3e8;
df=sqrt(sum((P-kron(ones(1,M),Ps)).^2 ,1)); tf=df/v; 

signal = rand(1, 524288)'+1i*rand(1, 524288)'; 
Sinal1=delayseq(signal,tf(1),sample_rate) + (randn(1, length(signal))'+1i*randn(1, length(signal))')/10;
Sinal2=delayseq(signal,tf(2),sample_rate) + (randn(1, length(signal))'+1i*randn(1, length(signal))')/10;
Sinal3=delayseq(signal,tf(3),sample_rate) + (randn(1, length(signal))'+1i*randn(1, length(signal))')/10;
Sinal4=delayseq(signal,tf(4),sample_rate) + (randn(1, length(signal))'+1i*randn(1, length(signal))')/10;


% % distance between two RXes in meters
% rx_distance12 =  sqrt( (x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2 );
% rx_distance13 =  sqrt( (x1-x3)^2 + (y1-y3)^2 + (z1-z3)^2 );
% rx_distance23 =  sqrt( (x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2 );
% 
% %% Read Signals from File
% signalx = read_file_iq('test1.dat');
% signal2 = read_file_iq('test2.dat');
% signal3 = read_file_iq('test3.dat');
% 
% %% alinhamento dos sinais
% [signal1, signal2, signal3]=alignment(signal1, signal2, signal3, time_stamp1, time_stamp2, time_stamp3, sample_rate);
%     
% 
% %% windowing
% Sinal1=windowing(signal1);
% Sinal2=windowing(signal2);
% Sinal3=windowing(signal3);

% %% Calculate TDOA
% for i=1:10
% [doa_meters12(i), doa_samples12(i), reliability12(i) ] = tdoa2(Sinal1(:,i), Sinal2(:,i), interpol_factor, sample_rate);
% 
% [doa_meters13(i), doa_samples13(i), reliability13(i) ] = tdoa2(Sinal1(:,i), Sinal3(:,i), interpol_factor, sample_rate);
% 
% [doa_meters23(i), doa_samples23(i), reliability23(i) ] = tdoa2(Sinal2(:,i), Sinal3(:,i), interpol_factor, sample_rate);
% end

[doa_samples12, reliability12 ] = tdoa2(Sinal1, Sinal2, interpol_factor, sample_rate);
[doa_samples13, reliability13 ] = tdoa2(Sinal1, Sinal3, interpol_factor, sample_rate);
[doa_samples14, reliability14 ] = tdoa2(Sinal1, Sinal4, interpol_factor, sample_rate);
[doa_samples23, reliability23 ] = tdoa2(Sinal2, Sinal3, interpol_factor, sample_rate);
[doa_samples24, reliability24 ] = tdoa2(Sinal2, Sinal4, interpol_factor, sample_rate);
[doa_samples34, reliability34 ] = tdoa2(Sinal3, Sinal4, interpol_factor, sample_rate);
 
Tdoa=[0               doa_samples12   doa_samples13   doa_samples14
      doa_samples12         0         doa_samples23   doa_samples24
      doa_samples13   doa_samples23         0         doa_samples34
      doa_samples14   doa_samples24   doa_samples34        0        ];

Deltad=Tdoa*v/sample_rate;

%----------------------------------------------------- ----------------- 
% Estimating the transmitter position using  conventional LS (M=4) 
%----------------------------------------------------- ----------------- 
for n=2:M 
 A1(n-1,:)=[(P(:,n)-P(:,1))' Deltad(n,1)]; end 
for n=2:M 
 b1(n-1,:)=[(P(:,n))'*P(:,n)-(P(:,1))'*P(:,1)- Deltad(n,1)^2]/2; 
end 
poConvLS=(A1'*A1)\(A1'*b1); 
poConvLS=poConvLS(1:2);
poConvLS(3)=1.5;
plot3(poConvLS(1),poConvLS(2),poConvLS(3),'xg','linewidth',4) 


% %% Generate html map 
% 
% rx_lat_positions  = [rx1_lat   rx2_lat   rx3_lat ];
% rx_long_positions = [rx1_long  rx2_long  rx3_long];
% 
% % open street map
% create_html_file_osm( ['imeg/map_ime_interp' num2str(interpol_factor) '_osm.html'], rx_lat_positions, rx_long_positions);
% 
% % disp('______________________________________________________________________________________________');
