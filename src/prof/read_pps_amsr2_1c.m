function [tb_low,qual_low,eia_low,lat_low,lon_low,time_low,sc_h_low,sc_lat_low,sc_lon_low,...
    tb_high,qual_high,eia_high,lat_high,lon_high] = read_pps_amsr2_1c(inpath,infile)
% Read a single orbital file of AMSR2 (PPS HDF5 format)
%   e.g. 1C.GCOMW1.AMSR2.XCAL2016-V.20150101-S000954-E014846.013958.V05A.HDF5
%
% Input:
%       filepath, path of file
%       infile, name of file
%
% Output:
%       tb_low,     brightness temperature,     [crosstrack(243),alongtrack(~3956),channel(8)] (10-36 GHz)
%       eia_low,    Earth incidence angle,      [crosstrack,alongtrack,channel(8)]
%       qual_low,   quality flag, 0=good,1=bad, [crosstrack,alongtrack]
%       lat_low,    latitude,                   [crosstrack,alongtrack]
%       lon_low,    longitude,                  [crosstrack,alongtrack]
%       time_low,   datenum,                    [1,alongtrack]
%       tb_high,    brightness temperature,     [crosstrack(486),alongtrack,channel(4)] (89 GHz)
%       eia_high,   Earth incidence angle,      [crosstrack,alongtrack,channel(4)]
%       qual_high,  quality flag, 0=good,1=bad, [crosstrack,alongtrack]
%       lat_high,   latitude,                   [crosstrack,alongtrack]
%       lon_high,   longitude,                  [crosstrack,alongtrack]
%
% Description:
%       AMSR2 channels in PPS 1C (10-89; 6/7 are not included)
%       low:  '10.65V','10.65H','18.7V','18.7H','23.8V','23.8H','36.5V','36.5H'
%       high: '89AV','89AH','89BV','89BH'
% 
% written by John Xun Yang,  University of Maryland, jxyang@umd.edu, 7/11/2016: GPM

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
    '/S2/Latitude','/S2/Longitude','/S2/Tc','/S2/incidenceAngle','/S2/Quality',...
    '/S3/Latitude','/S3/Longitude','/S3/Tc','/S3/incidenceAngle','/S3/Quality',...
    '/S4/Latitude','/S4/Longitude','/S4/Tc','/S4/incidenceAngle','/S4/Quality',...
    '/S5/Latitude','/S5/Longitude','/S5/Tc','/S5/incidenceAngle','/S5/Quality',...
    '/S6/Latitude','/S6/Longitude','/S6/Tc','/S6/incidenceAngle','/S6/Quality'};
Var = {'lat1','lon1','qual1','eia1','tb1','tyear','tmon','tday','thour','tmin','tsec',...
    'sc_h1','sc_lat1','sc_lon1',...
    'lat2','lon2','tb2','eia2','qual2',...
    'lat3','lon3','tb3','eia3','qual3',...
    'lat4','lon4','tb4','eia4','qual4',...
    'lat5','lon5','tb5','eia5','qual5',...
    'lat6','lon6','tb6','eia6','qual6'};

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
n5 = size(tb5,1);
n6 = size(tb6,1);

tb_low = cat(1,tb1,tb2,tb3,tb4);
tb_high = cat(1,tb5,tb6);
tb_low = permute(tb_low,[2,3,1]);
tb_high = permute(tb_high,[2,3,1]);

eia_low = cat(1,eia1(ones(n1,1),:,:),eia2(ones(n2,1),:,:),eia3(ones(n3,1),:,:),eia4(ones(n4,1),:,:));
eia_high = cat(1,eia5(ones(n5,1),:,:),eia6(ones(n6,1),:,:));
eia_low = permute(eia_low,[2,3,1]);
eia_high = permute(eia_high,[2,3,1]);

qual_low = qual1 | qual2 | qual3 | qual4;
qual_high = qual5 | qual6;

lat_low = lat1;
lat_high = lat5;

lon_low = lon1;
lon_high = lon5;

sc_h_low = sc_h1;
sc_lat_low = sc_lat1;
sc_lon_low = sc_lon1;

% NaN
idx = sc_h_low<-999;
sc_h_low(idx) = NaN;
sc_lat_low(idx) = NaN;
sc_lon_low(idx) = NaN;


% time_low format
time_low = datenum([double(tyear),double(tmon),double(tday),double(thour),double(tmin),double(tsec)]);
time_low = time_low(:)';



