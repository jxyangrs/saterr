function [idxfil] = filter_precip_land(tb19v,tb37v)
% filtering precipitation over land
% conical scanning
%
% Input:
%       tb19v,      tb of 19v
%       tb37v,      tb of 37v
%
% Output:
%       idxfil,     logical;1=rain,0=no-rain
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2016: from code in 8/31/2014

idxfil = tb19v-tb37v>10;

