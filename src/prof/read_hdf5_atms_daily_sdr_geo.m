function [tb,lat,lon,time,qual,eia,azm] = read_hdf5_atms_daily_sdr_geo(inpath,infile)
% Read daily atms SDR file
%
% Input:
% inpath, path of file
% infile, name of file
%
% /Data
%       tb,           tb,               K,          0,                                  [cross-track,along-track,channel]
%       lat,          latitude,         degree,     -999.3,                             [cross-track,along-track,band]
%       lon,          longitude,        degree,     -999.3,                             [cross-track,along-track,band]
%       time,         time in datenum   degree,     715146/datenum([1958 1 1 0 0 0]),   [1,along-track]
%       qual,         quality flag      degree,     1,                                  [cross-track,along-track]
%       eia,          eia               degree,     1,                                  [cross-track,along-track]
%       azm,          azm               degree,     1,                                  [cross-track,along-track]
% 
% /Atrributes
%       metadata and scale
%
% Examples:
% Gatms.npp.STAR.SDR.20111127.HDF5
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/6/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/10/2016: debug qual
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 9/8/2016: flag bad lat
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/13/2017: eia can be single channel
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/20/2017: attributes revised
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/28/2017: qual: double to logical
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/28/2021: eia and azm

tb=[];lat=[];lon=[];time=[];qual=[];

% bad file
s = dir([inpath,infile]);
if isempty(s)
    return
end
if s.bytes==0
    return
end

try
    % variables coverted to double
    
    InVar = {...
        '/Data/tb','/Data/lat','/Data/lon','/Data/time','/Data/eia','/Data/azm',...
        };
    Var = {'tb','lat','lon','time','eia','azm'};
    
    for i=1: length(Var)
        eval([Var{i}, '= double(h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
    end
    
    % variables keeping the same format
    InVar = {...
        '/Attributes/tb_scale'...
        };
    Var = {'tb_scale'};
    for i=1: length(Var)
        eval([Var{i}, '= (h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
    end

    % corrupted file
    if isempty(lat)
        return
    end
    
    % quality flag
    qual = logical(sum(tb==0,3));
    
    % convert
    tb = tb*tb_scale(1)+tb_scale(2);
    
    % time conversion (seconds to datenum)
    time = 715146 + time/(24*3600);
    time = time(:)';
end

