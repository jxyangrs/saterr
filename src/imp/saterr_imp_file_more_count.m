% saterr_imp_file_more_count.m
% loading orbital file information of count from extensive simulation
%
% Input:
%       Orbit.fov.lat,              FOV latitude (degree),                  [crosstrack,alongtrack],    NED;>0=downward,<0=upward;
%       Orbit.fov.lon,              FOV longitude (degree),                 [crosstrack,alongtrack],	NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.lat,               spacecraft latitude (degree),           [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lon,               sc longitude (degree),                  [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.h,                 sc altitude (degree),                   [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.ind_center,        scanning index of flight direction (km), [scalar or array]
%
% Output:
%       Rad.scan.scantilt,          scan tilt angle wrt nadir (degree),     [crosstrack,alongtrack],	NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            scan azimuth angle (degree),            [crosstrack,alongtrack],    NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.az,                spacecraft azimuth (degree),            [crosstrack,alongtrack]
%       Orbit.sc.lat,               spacecraft latitude (degree),           [crosstrack,alongtrack]
%       Orbit.sc.lon,               spacecraft longitude (degree),          [crosstrack,alongtrack]
%       Orbit.sc.h,                 spacecraft altitude (km),               [crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit Prof Path

% -----------------------------
% load
% -----------------------------
pathin_root = Path.sim.count;
fileID = 'sim_count_*';
datebegin = Path.date.range{1};
dateend = Path.date.range{2};

ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

files_simorbit = [];
num_filedaily = [];

for iday=1: size(ndatestr,1) % daily
    inpath = [pathin_root,'/',ndatestr(iday,1:4),'/',ndatestr(iday,:),'/'];
    files = dir([inpath,fileID]);
    files_simorbit = [files_simorbit;files];
    num_filedaily(iday) = size(files,1);
end
[ind_filedaily1,ind_filedaily2]= ind_startend_cum(num_filedaily);
Path.date.ndatestr = ndatestr;

