clc; clear all;
configime;
rx1_lat = -22.95592; % RX ime
rx1_long = -43.16629;

rx2_lat = -22.9508; % RX epv
rx2_long = -43.1517;

rx3_lat = -22.9442; % RX pão de açúcar
rx3_long = -43.1611;

geo_ref_lat  = mean([rx1_lat, rx2_lat, rx3_lat]);
geo_ref_long = mean([rx1_long, rx2_long, rx3_long]);

[x1, y1] = latlong2xy( rx1_lat, rx1_long, geo_ref_lat, geo_ref_long );
[x2, y2] = latlong2xy( rx2_lat, rx2_long, geo_ref_lat, geo_ref_long );
[x3, y3] = latlong2xy( rx3_lat, rx3_long, geo_ref_lat, geo_ref_long );

rx_lat_positions  = [rx1_lat   rx2_lat   rx3_lat ];
rx_long_positions = [rx1_long  rx2_long  rx3_long];
 
% [heatmap_long, heatmap_lat, heatmap_mag] = create_heatmap(doa_meters12, doa_meters13, doa_meters23, rx1_lat, rx1_long, rx2_lat, rx2_long, rx3_lat, rx3_long, heatmap_resolution, geo_ref_lat, geo_ref_long); % generate heatmap
% heatmap_cell = {heatmap_long, heatmap_lat, heatmap_mag};

% for open street map
create_html_file_osm( ['imeg/map_' file_identifier '_interp' num2str(interpol_factor) '_osm.html'], rx_lat_positions, rx_long_positions);



% plot(x1, y1, 'o')
% hold on
% plot(x2, y2, 'o')
% hold on
% plot(x3, y3, 'o')