% saterr_imp_file_simorbit.m
% load file information of simualted orbital data
%
% Input:
%       Path,                       path setting
%
% Output:
%       files_simorbit,               sensor file information
%       num_filedaily,              array of number of daily files
%       ind_filedaily1,             beginning index of daily files
%       ind_filedaily2,             ending index of daily files
%       Path.date.ndatestr,         date string
%       ind_dayn,                   index of day
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit Prof Path

% -----------------------------
% load
% -----------------------------
% pathin_root = Path.pathout.sim.sim;
% datebegin = Path.date.range{1};
% dateend = Path.date.range{2};

pathin_root = Path.sim.orbit;
fileID = 'sim_*';
datebegin = Path.date.range{1};
dateend = Path.date.range{2};

ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

files_simorbit = [];
num_filedaily = [];

for iday=1: size(ndatestr,1) % daily
    inpath = [pathin_root,'/',ndatestr(iday,1:4),'/',ndatestr(iday,:)];
    files = dir([inpath,'/',fileID]);
    files_simorbit = [files_simorbit;files];
    num_filedaily(iday) = size(files,1);
end
[ind_filedaily1,ind_filedaily2]= ind_startend_cum(num_filedaily);
Path.date.ndatestr = ndatestr;


ind_dayn = ones(sum(num_filedaily),1); % 1=day one,2=day two,...; [1,nfile]
for i=1: length(ind_filedaily1)
    ind = ind_filedaily1(i): ind_filedaily2(i);
    ind_dayn(ind) = i;
end

