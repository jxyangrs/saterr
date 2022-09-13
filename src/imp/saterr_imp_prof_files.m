% saterr_imp_prof_files.m
% load file information of satellite and reanalysis data
%
% Input:
%       Path,                       path setting
%
% Output:
%       files_prof,                 profile file information
%       num_filedaily,              array of number of daily files
%       ind_day_prof1,              beginning index of daily files
%       ind_day_prof2,              ending index of daily files
%       Path.date.ndatestr,         date string
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/05/2019: original code

global Rad Orbit Prof Path

% -----------------------------
% load
% -----------------------------
pathin_root = Path.sim.prof;
datebegin = Path.date.range{1};
dateend = Path.date.range{2};

ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

files_prof = []; % cell [nfile,1]
num_filedaily = [];
files_path = []; % [1,day]

for nday=1: size(ndatestr,1)
    inpath = [pathin_root,'/',ndatestr(nday,1:4),'/',ndatestr(nday,:),'/'];
    
    fileID = ['prof_',Path.sensor.spacecraft,'_',Path.sensor.name,'_',Path.ana.name,'_granule_','*.mat'];
    files = dir([inpath,fileID]);
        
    files_prof = [files_prof;files];
    num_filedaily(nday) = size(files,1);
    files_path{nday} = inpath;
end
[ind_day_prof1,ind_day_prof2]= ind_startend_cum(num_filedaily);
Path.date.ndatestr = ndatestr;

ind_dayn = ones(sum(num_filedaily),1); % 1=day one,2=day two,...; [1,nfile]
for i=1: length(ind_day_prof1)
    ind = ind_day_prof1(i): ind_day_prof2(i);
    ind_dayn(ind) = i;
end


