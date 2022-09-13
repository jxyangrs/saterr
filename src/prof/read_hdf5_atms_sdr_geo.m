function [tb,lat,lon,time,qual,eia,azm] = read_hdf5_atms_sdr_geo(inpath,infile)
% Read a single HDF5 file of atms
% e.g. GATMO-Satms_j01_d20200831_t2357120_e0005116_b14438_c20201102154134586728_noac_ops.h5
%
% Input:
%       inpath, path of file
%       infile, name of file
%
% Output:
%       tb,         brightness temperature          [cross-track,along-track,channel]
%       lat,        latitude,                       [cross-track,along-track,band]           -999=bad
%       lon,        longitude;                      [cross-track,along-track,band]           -999=bad
%       time,       time in datenum (midtime),      [1,along-track]
%       qual,       quality flag, 0=good,1=bad,     [cross-track,along-track]
%       eia,        eia (degrees),                  [cross-track,along-track]
%       azm,        azimuth angle,                  [cross-track,along-track]
%
% Examples:
%       GATMO-Satms_j01_d20200831_t2357120_e0005116_b14438_c20201102154134586728_noac_ops.h5
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/16/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/24/2016: try catch
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/24/2016: [cross-track,along-track]
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/01/2017: check and add help
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/28/2021: eia and azm

tb=[];time=[];

% bad file
s = dir([inpath,infile]);
if isempty(s)
    return
end
if s.bytes==0
    return
end

% read
InVar = {...
    '/All_Data/atms-TDR_All/AntennaTemperature',...
    '/All_Data/atms-TDR_All/AntennaTemperatureFactors'...
    '/All_Data/atms-SDR-GEO_All/BeamLatitude',...
    '/All_Data/atms-SDR-GEO_All/BeamLongitude',...
    '/All_Data/atms-SDR-GEO_All/MidTime',...
    '/All_Data/atms-SDR-GEO_All/SatelliteZenithAngle',...
    '/All_Data/atms-SDR-GEO_All/SatelliteAzimuthAngle'...
    };

Var = {'tb','scale','lat','lon','time','eia','azm'};

try
    for i=1: length(Var)
        eval([Var{i}, '= double(h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
    end
    
    % corrupted file
    if isempty(tb)
        return
    end
    
    % convert
    time = 715146 + time/(24*3600*1e6);
    
    tb = tb*scale(1)+scale(2);
    tb = permute(tb,[2 3 1]); % [cross-track,along-track,channel]
    
    % reshape
    lat = permute(lat,[2,3,1]);
    lon = permute(lon,[2,3,1]);
    
    time = time(:)';
    
    % quality flag
    qual = logical(sum(lat==-9999,3)); % the raw time is [cross-track,along-track]
    
    
end

