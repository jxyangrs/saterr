function [lat,lon] = plot_map_coastline(m)
% coastline with longitude ranging in either [-180,180] (m=1) or [0,360] (m=2)
%
% Input:
%       m,      option for lon range,   1=[-180,180],2=[0,360]
% 
% Output:
%       lat,    latitude,               1=[-180,180],2=[0,360]
%       lon,    longitude,              1=[-180,180],2=[0,360]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/11/2019: original code

c = load('coast');
switch m
    case 1 % [-180,180]
        lat = c.lat;
        lon = c.long;
        idx = lon>180;
        
        lat1 = lat;
        lon1 = lon;
        lat1(idx) = NaN;
        lon1(idx) = NaN;
        
        lat2 = lat;
        lon2 = lon;
        
        lat2(~idx) = NaN;
        lon2(idx) = lon2(idx)-360;
        
        
        lat = [lat1;lat2];
        lon = [lon1;lon2];
    case 2 % [0,360]
        
        lat = c.lat;
        lon = c.long;
        idx = lon<0;
        
        lat1 = lat;
        lon1 = lon;
        lat1(idx) = NaN;
        lon1(idx) = NaN;
        
        lat2 = lat;
        lon2 = lon;
        
        lat2(~idx) = NaN;
        lon2(idx) = mod(lon2(idx),360);
        
        lat = [lat1;lat2];
        lon = [lon1;lon2];
        
end

