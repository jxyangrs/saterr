function [x,y,z] = gd2gc(lat,lon,h,a,e)
% geodetic to geocentric
%
% Input:   
%         lat,     degree
%         lon,     degree
%         h,       altitude (km)
%         a,       major axis (km)
%         e,       eccentricity squared
% Output:  
%         x, y, z,  geocentric (km)

sinlat = sind(lat);
coslat = cosd(lat);
sinlon = sind(lon);
coslon = cosd(lon);
e2 = e^2;

v = a./sqrt(1-e2*sinlat.^2);
x = (v+h).*coslat.*coslon;
y = (v+h).*coslat.*sinlon;
z = (v.*(1-e2)+h).*sinlat;
