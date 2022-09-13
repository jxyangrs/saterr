% parse granuel observational data that has varying length
%
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/04/2019: original code

global Rad Orbit

% length of alongtrack
Rad.num_alongtrack_1orbit = size(Orbit.fov.lat,2);

% attitude 
saterr_set_attitudeoffset



