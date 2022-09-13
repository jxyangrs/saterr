function [az,elev,rs] = enu2ang(x,y,z)
% ENU to angle
% 
% Input:
%       x,      east 
%       y,      north
%       z,      up
% 
% Output:
%       az,     azimuth angle (degree), north=0, clockwises
%       elev,   elevation angle (degree)
%       rs,     slant range (km)

r = sqrt(x.^2+y.^2);
rs = sqrt(r.^2+z.^2);
elev = atan2d(z,r);
az = mod(atan2d(x,y),360);
