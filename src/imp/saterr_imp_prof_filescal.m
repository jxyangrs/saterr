% saterr_imp_prof_filescal.m
% load file information of calculated data
%
% Input:
%       Path,                       path setting
%
% Output:
%       files_days,                 file information of all days,       [nfile,1]
%       num_filedaily,              array of number of daily files,     [1,nday]
%       ind_filedaily1,             beginning index of daily files,     [1,nday]
%       ind_filedaily2,             ending index of daily files,        [1,nday]
%       Path.date.ndatestr,         date string,                        [nday]
%       pathin_root,                root path of data,                  string
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019

global Rad Orbit Prof Path

% -----------------------------
% load
% -----------------------------
pathin_root = Path.cal.output;
fileID = Path.sensor.fileID;
datebegin = Path.date.range{1};
dateend = Path.date.range{2};

ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

files_days = [];
num_filedaily = [];

for iday=1: size(ndatestr,1)
    pathin = [pathin_root,'/',ndatestr(iday,1:4),'/',ndatestr(iday,:)];
    files = dir([pathin,'/','*',fileID,'*']);
    files_days = [files_days;files];
    num_filedaily(iday) = size(files,1);
end
[ind_filedaily1,ind_filedaily2]= ind_startend_cum(num_filedaily);
Path.date.ndatestr = ndatestr;

