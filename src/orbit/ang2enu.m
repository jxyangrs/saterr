function [x,y,z] = ang2enu(az,elev,rs)
% angle to ENU 
% Input
%       az,     azimuth angle (degree)
%       elev,   elevation angle (degree)
%       rs,     slant range (km)
% 
% Output:
%       x,      east 
%       y,      north
%       z,      up

z = rs.*sind(elev);
r = rs.*cosd(elev);
x = r.*sind(az);
y = r.*cosd(az);