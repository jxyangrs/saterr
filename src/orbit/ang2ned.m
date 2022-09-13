function [x,y,z] = ang2ned(az,elev,rs)
% angle to NED 
% Input
%       az,     azimuth angle (degree)
%       elev,   elevation angle (degree)
%       rs,     slant range (km)
% 
% Output:
%       x,      north 
%       y,      east
%       z,      down

[x,y,z] = ang2enu(az,elev,rs);
[x,y,z] = xenu2ned(x,y,z);

