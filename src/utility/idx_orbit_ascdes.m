function [idx_asc,idx_des] = idx_orbit_ascdes(lat)
% index of ascending/descending orbit
% 
% Input:
%       lat,        latitude,           [1,alongtrack]/[alongtrack,1]
% 
% Output:
%       idx_asc,    1=asc,0=not asc,    [1,alongtrack]/[alongtrack,1]
%       idx_des,    1=des,0=not des,    [1,alongtrack]/[alongtrack,1]
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/11/2017: pre-screened lat regardless of lat anormaly like jump; no NaN

x = diff(lat,1);
idx_asc = x>0;
idx_asc = idx_asc([1,1:end]);
idx_des = ~idx_asc;
