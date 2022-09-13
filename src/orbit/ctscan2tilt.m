function [scantilt] = ctscan2tilt(ang_scan)
% crosstrack scanning angle to tilt angle 
% Input
%       ang_scan,   scanning angle (degree); left-hand; 0=down
% 
% Output:
%       scantilt,   tilt angle (degree), [0,180], in NED down=[0,90],up=[90,180]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/28/2019: original code

scantilt = abs(ang_scan);

