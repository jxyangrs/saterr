function [az,elev,rs] = ned2ang(x,y,z)
% ENU to angle
%       x,      north 
%       y,      east
%       z,      down
% 
% Output:
%       az,     azimuth angle (degree), north=0, clockwises
%       elev,   elevation angle (degree)
%       rs,     slant range (km)

[x,y,z] = xenu2ned(x,y,z);

r = sqrt(x.^2+y.^2);
rs = sqrt(r.^2+z.^2);
elev = atan2d(z,r);
az = mod(atan2d(x,y),360);
