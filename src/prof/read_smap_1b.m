function [tb,qual,eia,lat,lon,time,azm] = read_smap_1b(inpath,infile)
% Read a single orbital file of SMAP (HDF5)
%   e.g. SMAP_L1B_TB_23129_A_20190601T001524_R16022_001.h5
% 
% Input:
%       filepath, path of file
%       infile, name of file
%
% Output:
%       tb,     brightness temperature;     [crosstrack,alongtrack,channel(tbv,tbh,tb3,tb4)]
%       eia,    Earth incidence angle;      [crosstrack,alongtrack]
%       qual,   quality flag; 0=good,1=bad; [crosstrack,alongtrack]
%       lat,    latitude;                   [crosstrack,alongtrack]
%       lon,    longitude;                  [crosstrack,alongtrack]
%       time,   datenum;                    [crosstrack,alongtrack]
%       azm,    azimuth angle;              [crosstrack,alongtrack]
% 
% written by John Xun Yang,  University of Maryland, jxyang@umd.edu, 7/11/2016

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
InVar = {'/Brightness_Temperature/tb_lat','/Brightness_Temperature/tb_lon','/Brightness_Temperature/earth_boresight_incidence','/Brightness_Temperature/earth_boresight_azimuth',...
    '/Brightness_Temperature/tb_3','/Brightness_Temperature/tb_4','/Brightness_Temperature/ta_h','/Brightness_Temperature/ta_v',...
    '/Brightness_Temperature/tb_time_seconds'...
    };
Var = {'lat1','lon1','eia1','azm1','tb3','tb4','tbh','tbv','time'};

% read
for i=1: length(Var)
    eval([Var{i}, '= double(h5read([''',filename,'''],','''',InVar{i},'''));']);
end

t = h5read([filename],'/Brightness_Temperature/tb_time_seconds');
qual = t==-9999;
t(qual) = NaN;
time = datenum([2000 1 1 0 0 0]) + t/(24*3600);

tbv(qual) = NaN;
tbh(qual) = NaN;
tb3(qual) = NaN;
tb4(qual) = NaN;

eia = eia1;
lat = lat1;
lon = lon1;
azm = azm1;

eia(qual) = NaN;
lat(qual) = NaN;
lon(qual) = NaN;
azm(qual) = NaN;

% combine
tb = cat(3,tbv,tbh,tb3,tb4);


