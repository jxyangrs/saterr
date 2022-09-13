function [az] = coscan2az(n1,n2)
% conical scanning azimuth angle
% Input
%       n1,       Earth scanning number
%       n2,       total scanning number
% 
% Output:
%       az,       azimuth angle, north=0, clockwise 
% 
% Examples:
%       scanpos = [221,98,13,84,13,71];
%       n1 = scanpos(1);
%       n2 = sum(scanpos);
%       az = coscan2az(n1,n2);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/19/2019: original code


ang = (n1-1)/n2*180;
az = linspace(ang,-ang,n1); % can be clockwise or counter-clockwise


