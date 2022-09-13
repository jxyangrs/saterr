function saterr_imp_prof_ini
% initializing
%
% Input:
%       Orbit.FOV.lat,              FOV latitude (degree),                  [crosstrack,alongtrack],    NED;>0=downward,<0=upward;
%
% Output:
%       Rad.num_alongtrack,         granuel alongtrack length,     [crosstrack,alongtrack],	NED;>0=downward,<0=upward;
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit

[n1,n2] = size(Orbit.sc.lat);
Rad.num_alongtrack = n2;
