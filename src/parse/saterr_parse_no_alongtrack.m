function saterr_parse_no_alongtrack
% parsing number of alongtrack
%
% Input:
%       Rad.num_alongtrack_1orbit
%       Rad.num_orbit
%
% Output:
%       Rad.num_alongtrack,                     [cs,cc,cw,null]
%       Rad.alongtrack_orbit_ind_startend,      [cs,cc,cw,null]
%       Rad.norbit,                             [cs,cc,cw,null],         (no blank interval)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/03/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/19/2019: more index of crosstrack
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/19/2019: reorder starting w/ cs

global Rad

Rad.num_alongtrack = Rad.num_alongtrack_1orbit*Rad.num_orbit;
[ind1,ind2] = ind_startend_bin(Rad.num_orbit*Rad.num_alongtrack_1orbit,Rad.num_alongtrack_1orbit);
Rad.alongtrack_orbit_ind_startend = [ind1(:),ind2(:)];             
Rad.norbit = 1;