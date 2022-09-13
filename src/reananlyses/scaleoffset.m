function [scale_factor,add_offset] = scaleoffset(num_range,data_range)
% calculating scale factor and offset for int16, provided the boundary
%   -32767 is assumed to be FillValue/bad value
%
% Input:
%       num_range,          range of numeric type,     scalar (double)
%       data_range,         range of data,             scalar (double)
% 
% Output:
%       scale_factor,       scale factor
%       add_offset,         offset
% 
% Examples:
%      1)
%       num_range = [-32767,32767]; % for int16
%       data_range = [150,330]; % Temperature [150,330] (K)
%      2) conservative
%       num_range = [-32767+4,32767-4]; % for int16
%       data_range = [150,330]; % Temperature [150,330] (K)
% 
% Note:
% 		intmax,   intmin
% 		realmax,  realmin
% 		cast,     convert w/ nearest round
% 		typecast, convert w/o changing underlying data
%      
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/16/2020: original code


scale_factor = (data_range(2)-data_range(1))./(num_range(2)-num_range(1));
add_offset = data_range(1) - scale_factor*num_range(1);





