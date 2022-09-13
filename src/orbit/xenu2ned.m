function [x,y,z] = xenu2ned(x,y,z)
% ENU to NED and vice versa
% 
% Input:
%       x,      east/north
%       y,      north/east
%       z,      up/down
% 
% Output:
%       x,      north/east
%       y,      east/north
%       z,      down/up
% 
% Examples:
%       [ue,un,uu] = xenu2ned(un,ue,ud);
%       [un,ue,ud] = xenu2ned(ue,un,uu);

x0 = x;
x = y;
y = x0;
z = -z;

