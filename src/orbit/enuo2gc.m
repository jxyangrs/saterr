function [x,y,z] = enuo2gc(lat,lon,ue,un,uu)
% ENU offset vector to geocentric ECEF
% 
% Input:
%       lat,    degree
%       lon,    degree
%       ue,     ENU east (km)
%       un,     ENU north (km)
%       uu,     ENU up (km)
% Output:
%       x, y, z, geocentric coordinate (km)

r = cosd(lat).*uu-sind(lat).*un;
x = cosd(lon).*r-sind(lon).*ue;
y = sind(lon).*r+cosd(lon).*ue;
z = sind(lat).*uu+cosd(lat).*un;
