function [tb,qual,eia,lat,lon,time,sc_h,sc_lat,sc_lon] = read_pps_amsub_1c(inpath,infile)
% Read a single orbital file of AMSU-B (PPS HDF5 format)
%   e.g. 1C.NOAA17.AMSUB.XCAL2017-V.20050101-S000007-E014118.013105.V05A.HDF5
% 
% Input:
%       filepath, path of file
%       infile, name of file
%
% Output:
%       tb,     brightness temperature;     [crosstrack(90),alongtrack(~2277),channel(5)]
%       eia,    Earth incidence angle;      [crosstrack,alongtrack,channel(5)]
%       qual,   quality flag; 0=good,1=bad; [crosstrack,alongtrack]
%       lat,    latitude;                   [crosstrack,alongtrack]
%       lon,    longitude;                  [crosstrack,alongtrack]
%       time,   datenum;                    [1,alongtrack]
%
% Description:
%       AMSU-B channels in PPS 1C
%       chanstr = {'89V','150V','183.31±1','183.31±3','183.31±7'};
% 
% written by John Xun Yang,  University of Maryland, jxyang@umd.edu, 7/11/2016: GPM

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
    '/S1/SCstatus/SCaltitude','/S1/SCstatus/SClatitude','/S1/SCstatus/SClongitude'
    };
Var = {'lat1','lon1','qual1','eia1','tb1','tyear','tmon','tday','thour','tmin','tsec',...
    'sc_h1','sc_lat1','sc_lon1'
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
tb = permute(tb1,[2,3,1]);
eia = permute(eia1,[2,3,1]);
qual = qual1;
lat = lat1;
lon = lon1;

sc_h = sc_h1;
sc_lat = sc_lat1;
sc_lon = sc_lon1;


% time format
time = datenum([double(tyear),double(tmon),double(tday),double(thour),double(tmin),double(tsec)]);
time = time(:)';

% NaN
idx = sc_h<-999;
sc_h(idx) = NaN;
sc_lat(idx) = NaN;
sc_lon(idx) = NaN;


