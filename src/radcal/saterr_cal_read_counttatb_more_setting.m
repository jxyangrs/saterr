% setting path and variables for loading count, ta, tb
% 
% Input:
%       setting path
% Output:
%       variables
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code


% =======================================================
% setting path
% =======================================================

% ---------------------------
% setting target and reference satellites
% ---------------------------
ndatestr = datestr(datenum(Path.date.range(1),'yyyymmdd'): datenum(Path.date.range(2),'yyyymmdd')-1,'yyyymmdd');

% -----------------------------
% count data
% -----------------------------
pathin_count = [Path.sim.count];
fileID_count = ['sim_',Path.sensor.spacecraft,'.',Path.sensor.name,'*'];

% -----------------------------
% ta,tb data
% -----------------------------
pathin_tatb = [Path.cal.output];
fileID_tatb = ['cal_',Path.sensor.spacecraft,'.',Path.sensor.name,'*'];


% =======================================================
% setting daily variables
% =======================================================

% variable from count files
tc = [];
tw = [];
cs = [];
cc = [];
cw = [];

fov_lat = [];
fov_lon = [];
sc_lat = [];
sc_lon = [];
sc_time = [];

faraday_omega = [];
faraday_d = [];
faraday_U = [];

% variable from ta,tb files
tas = [];
tas_bias = [];
tas_noise = [];
tac = [];
taw = [];
tac_noise = [];
taw_noise = [];
tbs = [];


