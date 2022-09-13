function [tb_low,qual_low,eia_low,lat_low,lon_low,time,sc_h_low,sc_lat_low,sc_lon_low,tb_high,qual_high,eia_high,lat_high,lon_high] = read_pps_ssmis_1c(inpath,infile)
% Read a single orbital file of SSMI (PPS HDF5 format)
%   e.g. 1C.F15.SSMI.XCAL2018-V.20050101-S013246-E031430.026118.V07A.HDF5
% 
% Input:
%       filepath, path of file
%       infile, name of file
%
% Output:
%       tb_low,     brightness temperature;     [crosstrack(90),alongtrack(~3222),channel(5)] (19-37 GHz)
%       eia_low,    Earth incidence angle,      [crosstrack,alongtrack,channel(5)]
%       qual_low,   quality flag; 0=good,1=bad; [crosstrack,alongtrack]
%       lat_low,    latitude;                   [crosstrack,alongtrack]
%       lon_low,    longitude;                  [crosstrack,alongtrack]
%       time,       datenum,                    [alongtrack,1]
%       tb_high,    brightness temperature;     [crosstrack(180),alongtrack(~3222),channel(6)] (91-183 GHz)
%       eia_high,   Earth incidence angle,      [crosstrack,alongtrack,channel(6)]
%       qual_high,  quality flag; 0=good,1=bad; [crosstrack,alongtrack]
%       lat_high,   latitude;                   [crosstrack,alongtrack]
%       lon_high,   longitude;                  [crosstrack,alongtrack]
%
% Description:
%       AMSR2 channels in PPS 1C :
%       low:  19.35V,19.35H,22.235V,37V,37H
%       high: 91.665V,91.665H,150H,183.31±1H,183.31±3H,183.31±6.6H,183.31±1H
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 07/11/2016

% output
tb=[];qual=[];eia=[];lat=[];lon=[];time=[];

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
    '/S2/Latitude','/S2/Longitude','/S2/Tc','/S2/incidenceAngle','/S2/Quality',...
    '/S3/Latitude','/S3/Longitude','/S3/Tc','/S3/incidenceAngle','/S3/Quality',...
    '/S4/Latitude','/S4/Longitude','/S4/Tc','/S4/incidenceAngle','/S4/Quality',...
    };
Var = {'lat1','lon1','qual1','eia1','tb1','tyear','tmon','tday','thour','tmin','tsec',...
    'sc_h1','sc_lat1','sc_lon1',...
    'lat2','lon2','tb2','eia2','qual2',...
    'lat3','lon3','tb3','eia3','qual3',...
    'lat4','lon4','tb4','eia4','qual4',...
    };

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
n3 = size(tb3,1);
n4 = size(tb4,1);

tb_low = cat(1,tb1, tb2);
tb_low = permute(tb_low,[2,3,1]);
tb_high = cat(1,tb4,tb3);
tb_high = permute(tb_high,[2,3,1]);

eia_low = cat(1,eia1(ones(n1,1),:,:), eia2(ones(n2,1),:,:));
eia_low = permute(eia_low,[2,3,1]);
eia_high = cat(1,eia4(ones(n4,1),:,:),eia3(ones(n3,1),:,:));
eia_high = permute(eia_high,[2,3,1]);

qual_low = qual1 | qual2;
qual_high = qual3 | qual4;

lat_low = lat1;
lon_low = lon1;

lat_high = lat3;
lon_high = lon3;

sc_h_low = sc_h1;
sc_lat_low = sc_lat1;
sc_lon_low = sc_lon1;

% quanlity flag, replace -9999 with NaN
lat_low(qual_low) = NaN;
lon_low(qual_low) = NaN;
tb_low(repmat(qual_low,[1,1,size(tb_low,3)])) = NaN;
eia_low(repmat(qual_low,[1,1,size(tb_low,3)])) = NaN;

lat_high(qual_high) = NaN;
lon_high(qual_high) = NaN;
tb_high(repmat(qual_high,[1,1,size(tb_high,3)])) = NaN;
eia_high(repmat(qual_high,[1,1,size(tb_high,3)])) = NaN;

idx = sc_h_low<-999;
sc_h_low(idx) = NaN;
sc_lat_low(idx) = NaN;
sc_lon_low(idx) = NaN;

% time format
time = datenum([double(tyear),double(tmon),double(tday),double(thour),double(tmin),double(tsec)]);
time = time(:)';

