function [tb_low,qual_low,eia_low,lat_low,lon_low,time_low,sc_h_low,sc_lat_low,sc_lon_low,tb_high,qual_high,eia_high,lat_high,lon_high] = read_pps_ssmi_1c(inpath,infile)
% Read a single orbital file of SSMI (PPS HDF5 format)
%   e.g. 1C.F15.SSMI.XCAL2018-V.20050101-S013246-E031430.026118.V07A.HDF5
% 
% Input:
%       filepath,   path of file
%       infile,     name of file
%
% Output:
%       tb_low,     brightness temperature,     [crosstrack(64),alongtrack(~1607),channel(5)] (19-37 GHz)
%       eia_low,    Earth incidence angle,      [crosstrack,alongtrack,channel(5)]
%       qual_low,   quality flag, 0=good,1=bad, [crosstrack,alongtrack]
%       lat_low,    latitude,                   [crosstrack,alongtrack]
%       lon_low,    longitude,                  [crosstrack,alongtrack]
%       time_low,   datenum,                    [1,alongtrack]
%       tb_high,    brightness temperature,     [crosstrack(128),alongtrack(~3214),channel(2)] (85 GHz)
%       eia_high,   Earth incidence angle,      [crosstrack,alongtrack,channel(2)]
%       qual_high,  quality flag, 0=good,1=bad, [crosstrack,alongtrack]
%       lat_high,   latitude,                   [crosstrack,alongtrack]
%       lon_high,   longitude,                  [crosstrack,alongtrack]
%
% Description:
%       SSM/I channels in PPS 1C (10-89; 6/7 are not included)
%       low:  19.35V,19.35H,22.235V,37V,37H
%       high: 85.5V,85.5H
%                                
% written by John Xun Yang,  University of Maryland, jxyang@umd.edu, 07/11/2016

% output
tb=[];qual=[];eia=[];lat=[];lon=[];time_low=[];

% bad empty file
filename = [inpath,'/',infile];
s = dir(filename);
if isempty(s)
    return
end
if s.bytes==0
    return
end

% set up variables
InVar = {'/S1/Latitude','/S1/Longitude','/S1/Quality','/S1/incidenceAngle','/S1/Tc','/S1/ScanTime/Year','/S1/ScanTime/Month','/S1/ScanTime/DayOfMonth','/S1/ScanTime/Hour','/S1/ScanTime/Minute','/S1/ScanTime/Second',...
    '/S1/SCstatus/SCaltitude','/S1/SCstatus/SClatitude','/S1/SCstatus/SClongitude',...
    '/S2/Latitude','/S2/Longitude','/S2/Tc','/S2/incidenceAngle','/S2/Quality'};
Var = {'lat1','lon1','qual1','eia1','tb1','tyear','tmon','tday','thour','tmin','tsec',...
    'sc_h1','sc_lat1','sc_lon1',...
    'lat2','lon2','tb2','eia2','qual2'};

% read
for i=1: length(Var)
    eval([Var{i}, '= double(h5read([''',filename,'''],','''',InVar{i},'''));']);
end

% corrupted file
if isempty(lat1)
    return
end

% combine
n1 = size(tb1,1);
n2 = size(tb2,1);

tb_low = permute(tb1,[2,3,1]);
tb_high = permute(tb2,[2,3,1]);

eia_low = permute(eia1(ones(n1,1),:,:),[2,3,1]);
eia_high = permute(eia2(ones(n2,1),:,:),[2,3,1]);

qual_low = logical(qual1);
qual_high = logical(qual2);

lat_low = lat1;
lat_high = lat2;

lon_low = lon1;
lon_high = lon2;

sc_h_low = sc_h1;
sc_lat_low = sc_lat1;
sc_lon_low = sc_lon1;

% time_low format
time_low = datenum([double(tyear),double(tmon),double(tday),double(thour),double(tmin),double(tsec)]);
time_low = time_low(:)';

% NaN
idx = qual_low;
lat_low(idx) = NaN;
lon_low(idx) = NaN;

idx = qual_high;
lat_high(idx) = NaN;
lon_high(idx) = NaN;

idx = sc_h_low<-999;
sc_h_low(idx) = NaN;
sc_lat_low(idx) = NaN;
sc_lon_low(idx) = NaN;

