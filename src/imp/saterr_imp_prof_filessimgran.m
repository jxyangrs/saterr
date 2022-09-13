% saterr_imp_sat_ana_files.m
% load file information of satellite and reanalysis data
%
% Input:
%       Path,                       path setting
%
% Output:
%       files_simgran,              granuel file information
%       num_filedaily,              array of number of daily files
%       ind_day_simgran1,           beginning index of daily files
%       ind_day_simgran2,           ending index of daily files
%       Path.date.ndatestr,         date string
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit Prof Path

% -----------------------------
% load
% -----------------------------
pathin_root = Path.sim.granuel;
datebegin = Path.date.range{1};
dateend = Path.date.range{2};

ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

files_simgran = []; % simulated granuel files
num_filedaily = [];

for iday=1: size(ndatestr,1) % daily
    inpath = [pathin_root,'/',ndatestr(iday,1:4),'/',ndatestr(iday,:),'/'];
    files = dir([inpath,'*.mat']);
    files_simgran = [files_simgran;files];
    num_filedaily(iday) = size(files,1);
end
[ind_day_simgran1,ind_day_simgran2]= ind_startend_cum(num_filedaily);
Path.date.ndatestr = ndatestr;

