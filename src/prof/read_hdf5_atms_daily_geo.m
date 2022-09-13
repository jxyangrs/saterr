function [lat,lon,time,eia,qual,azm] = read_hdf5_atms_daily_geo(inpath,infile)
% Read daily atms SDR file
%
% Input:
%       inpath, path of file
%       infile, name of file
%
% Output:
%       lat,          latitude,         degree,     -999,                               [cross-track,along-track,band]
%       lon,          longitude,        degree,     -999,                               [cross-track,along-track,band]
%       time,         time in datenum   degree,     715146/datenum([1958 1 1 0 0 0]),   [1,along-track]
%       eia,          eia               degree,     -999,                               [cross-track,along-track]
%       qual,         quality flag      degree,     1,                                  [cross-track,along-track]
%       azm,          azimuth angle     degree,     -999,                               [cross-track,along-track]
% 
% Examples:
%       Gatms.npp.STAR.SDR.20111127.HDF5
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/06/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/10/2016: debug qual
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/08/2016: remove scrange

lat=[];lon=[];time=[];eia=[];qual=[];azm=[];

% bad file
s = dir([inpath,infile]);
if isempty(s)
    return
end
if s.bytes==0
    return
end

try
% read
% variables coverted to double
InVar = {...
    '/Data/lat','/Data/lon','/Data/time','/Data/eia','/Data/azm',...
    };
Var = {'lat','lon','time','eia','azm'};

for i=1: length(Var)
    eval([Var{i}, '= double(h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
end

% variables keeping the same format
InVar = {...
    '/Attributes/timeformat'...
    };
Var = {'timeformat'};
for i=1: length(Var)
    eval([Var{i}, '= (h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
end

% corrupted file
if isempty(lat)
    return
end

% 
qual = sum(abs(lat)>90,3)>0;

% time conversion (seconds to datenum)
time = 715146 + time/(24*3600);
time = time(:)';
end

