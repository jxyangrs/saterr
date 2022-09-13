function [tb,qual,eia,lat,lon,time] = read_hdf5_gmi_1c(inpath,infile,varargin)
% Read a single HDF5 file of GMI
%
% Input:
% filepath, path of file
% infile, name of file
% indchanselect, index for selecting channels
%
% Output:
% tb, brightness temperature; 3D, [cross-track,along-track,channel]
% eia, EIA; 3D, [cross-track,along-track,channel]
% qual, quality flag; 0=good,1=bad; 2D, [cross-track,along-track]
% lat, latitude; 2D, [cross-track,along-track]
% lon, longitude; convert to range between [0,360); 2D, [cross-track,along-track]
% time, time in the format of Matlab datenum; 1D, [along-track,1]
%
% written by John Xun Yang, University of Michigan, johnxun@umich.edu, 02/2014
% revised by John Xun Yang, 7/5/2014: duplicate eia to all channles
% revised by John Xun Yang,  University of Maryland, jxyang@umd.edu, 7/11/2016: add indchanselect
% revised by John Xun Yang,  University of Maryland, jxyang@umd.edu, 1/14/2017: cross,along; varargin


% GMI channels
% rad = 'GMI';
% chanstr = {'10.65V','10.65H','18.7V','18.7H','23.8V','36.64V','36.64H','89V','89H','166V','166H','183.31±3V','183.31±7V'}; % channel names
% chanind = [1,        2,       3,       4,     5,      6,       7,       8,    9,    10,    11,    12,         13];

% output
tb=[];qual=[];eia=[];lat=[];lon=[];time=[];

% bad empty file
s = dir([inpath,'/',infile]);
if isempty(s)
    return
end
if s.bytes==0
    return
end

if isempty(varargin)
    indchanselect=1:13;
else
    indchanselect=varargin{1};
end

% set up variables
NumGroup1 = 9; % number of lower 9 channels
s1 = sum(indchanselect<=NumGroup1);
s2 = sum(indchanselect>NumGroup1);
if  s1 && s2 % channels 10-89 and 166-183
    InVar = {'/S1/Latitude','/S1/Longitude','/S1/Quality','/S1/incidenceAngle','/S1/Tc','/S1/ScanTime/Year','/S1/ScanTime/Month','/S1/ScanTime/DayOfMonth','/S1/ScanTime/Hour','/S1/ScanTime/Minute','/S1/ScanTime/Second',...
        '/S2/Tc','/S2/incidenceAngle','/S2/Quality'};
    Var = {'lat','lon','qual1','eia1','tb1','tyear','tmon','tday','thour','tmin','tsec',...
        'tb2','eia2','qual2'};
elseif  s1 % channels from 10-89
    InVar = {'/S1/Latitude','/S1/Longitude','/S1/Quality','/S1/incidenceAngle','/S1/Tc','/S1/ScanTime/Year','/S1/ScanTime/Month','/S1/ScanTime/DayOfMonth','/S1/ScanTime/Hour','/S1/ScanTime/Minute','/S1/ScanTime/Second'};
    Var = {'lat','lon','qual','eia','tb','tyear','tmon','tday','thour','tmin','tsec'};
elseif  s2 % channels from 166-183
    InVar = {'/S2/Latitude','/S2/Longitude','/S2/Quality','/S2/incidenceAngle','/S2/Tc','/S2/ScanTime/Year','/S2/ScanTime/Month','/S2/ScanTime/DayOfMonth','/S2/ScanTime/Hour','/S2/ScanTime/Minute','/S2/ScanTime/Second'};
    Var = {'lat','lon','qual','eia','tb','tyear','tmon','tday','thour','tmin','tsec'};
    indchanselect = indchanselect-NumGroup1; % take out lower 9 channels
else % no channels: indchanselect is empty
    return
end

% read
for i=1: length(Var)
    eval([Var{i}, '= double(h5read([''',inpath,infile,'''],','''',InVar{i},'''));']);
end

% corrupted file
if isempty(lat)
    return
end

% tb
if s1>0 && s2>0
    tb = cat(1,tb1,tb2);
end
tb = tb(indchanselect,:,:);
tb = permute(tb,[2,3,1]); % transform to [cross-track,along-track,frequency]

% eia
if s1>0 && s2>0
    eia1 = eia1(ones(s1,1),:,:);
    eia2 = eia2(ones(s2,1),:,:);
    eia = cat(1,eia1,eia2);
elseif s1
    eia = eia(ones(s1,1),:,:);
elseif s2
    eia = eia(ones(s2,1),:,:);
end
eia = permute(eia,[2,3,1]);

% qual
if s1>0 && s2>0
    qual = logical(qual1+qual2);
end
qual = qual;

% time format
time = datenum([double(tyear),double(tmon),double(tday),double(thour),double(tmin),double(tsec)]);
time = time(:)';





