function [x2, y2, z2] = gco2enu(dx,dy,dz,lat,lon)
% geocentric offset vector to enu
%
% Input:
%       dx,	 geoenctric x  
%       dy,   
%       dz,   
%   
% Output:
%       x2,	 east
%       y2,  north
%       z2,  up
% 
% Examples:
%       [x2, y2, z2] = gco2enu(dx,dy,dz,lat,lon)

coslat = cosd(lat);
sinlat = sind(lat);
coslon = cosd(lon);
sinlon = sind(lon);

r = coslon.*dx + sinlon.*dy;
x2 = -sinlon.*dx + coslon.*dy;

z2 = coslat.*r + sinlat.*dz;
y2 = -sinlat.*r + coslat.*dz;
