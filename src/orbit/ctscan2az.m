function [az] = ctscan2az(ang_scan)
% crosstrack scanning angle to azimuth 
% Input
%       ang_scan, scanning angle (degree); left-hand; 0=down
% 
% Output:
%       az,       azimuth angle (degree), north=0, clockwise 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/28/2019: original code

az = ang_scan;
idx = ang_scan<0;
az(idx) = -90;
az(~idx) = 90;

