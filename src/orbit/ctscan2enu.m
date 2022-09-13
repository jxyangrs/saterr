function [x,y,z] = ctscan2enu(az,scanang)
% satellite scanning angle to ENU 
% Input
%       az,       azimuth angle (north=0, clockwise) (degree)
%       scanang,  scanning angle (degree); >0 down, <0 up
% 
% Output:
%       x,      east 
%       y,      north
%       z,      up     >0 up, <0 down

[x,y,z] = ctscan2ned(az,scanang);
[x,y,z] = xenu2ned(x,y,z);

