function M = eulerrotate(roll,pitch,yaw)
% rotation matrix due to attitude offset roll, pitch, yaw, ZYX rotation
%
% Input:
%       roll,	roll angle (degree)     [1]/[1,1,n]
%       pitch,  pitch angle (degree)    [1]/[1,1,n]
%       yaw,    yaw angle (degree)      [1]/[1,1,n]
%   
% Output:
%       M,      rotation matrix
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 08/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 12/19/2019: right-hand law

% rotation matrix
n = size(yaw);

a1 = yaw/180*pi;  
a2 = pitch/180*pi;  
a3 = roll/180*pi;  

rz=[cos(a1)     -sin(a1)	zeros(n);
    sin(a1)     cos(a1)     zeros(n);
    zeros(n)    zeros(n)    ones(n)];
ry=[cos(a2)     zeros(n)    sin(a2);
    zeros(n)    ones(n)     zeros(n);
    -sin(a2)	zeros(n)    cos(a2)];
rx=[ones(n)     zeros(n)    zeros(n);
    zeros(n)    cos(a3)     -sin(a3);
    zeros(n)    sin(a3)     cos(a3)];

% (rz*ry)*rx
M = mtimes_3d3d(rz,ry);
M = mtimes_3d3d(M,rx);

