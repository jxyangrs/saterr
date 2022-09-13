% saterr_imp_sat_ana_files.m
% load file information of satellite and reanalysis data
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
cc_chan = [];
cs_chan = [];
cw_chan = [];
tc_chan = [];
tw_chan = [];
lat = [];
lon = [];
tb_mainlobe = [];

for iday=1: size(Path.date.ndatestr,1)
    ind = ind_filedaily1(iday): ind_filedaily2(iday);
    files_daily = files_sat_ana_simgranuel(ind);
    
    for ifile=1: size(files_daily,1)
        inpath = files_daily(ifile).folder;
        infile = files_daily(ifile).name;
        disp(infile)
        data = load([inpath,'/',infile]);
        
        % collect
        cc_chan = cat(2,cc_chan,data.cc_chan);
        cs_chan = cat(2,cs_chan,data.cs_chan);
        cw_chan = cat(2,cw_chan,data.cw_chan);
        tc_chan = cat(2,tc_chan,data.tc_chan);
        tw_chan = cat(2,tw_chan,data.tw_chan);
        lat = cat(2,lat,data.lat);
        lon = cat(2,lon,data.lon);
        
    end
end

clear data

