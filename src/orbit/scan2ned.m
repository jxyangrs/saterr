function [x,y,z] = scan2ned(az,scanang)
% scanning angle to NED 
% Input
%       az,         azimuth angle (north=0, clockwise) (degree),      N-D
%       scanang,    tilt scanning angle (degree); >0 down, <0 up,     N-D
% 
% Output:
%       x,          north,     N-D
%       y,          east,      N-D
%       z,          down,      N-D
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/19/2019: original code

r = sind(scanang);
y = r.*sind(az);
x  = r.*cosd(az);
z = cosd(scanang);
