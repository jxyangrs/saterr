function [cID,clat,clon,ctime,ID1,idx1,ID2,idx2] = sub_collocate(Time,Grid,lat1,lon1,time1,lat2,lon2,time2,varargin)
% spatialtemporal collocation
% (output is sorted by default)
%
% Input (1D [n,1], double precision):
%         Time,     time resolution (minute)
%         Grid,     grid resolution (km/degree)
%         lat1,     x1 location
%         lon1,     y1 location
%         lat2,     x2 location
%         lon2,     y2 location
%         varargin, sorted/stable (default is sorted); specify range of x&y
%
% Output:
%         cID,      ID in common
%         ID1,      ID for group 1
%         idx1,     logical for ismember
%         ID2,      ID for group 2
%         idx2,     logical for ismember
% 
% 
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/22/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/26/2016: varargin for range
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/18/2016: stable option

% setting
w = 24*60/Time; % windows for matching time; e.g., 24*60/5=within 5 minutes

% preprocess
time1org = time1; % coordinate 1 as output
lat1org = lat1;
lon1org = lon1;

if ~isempty(varargin) % use given range
    Sort = varargin{1};
    RangeLat = varargin{2};
    RangeLon = varargin{3};
else
    Sort = 'sorted';
    RangeLat = max(max(lat1),max(lat2)) - min(min(lat1),min(lat2));
    RangeLon = max(max(lon1),max(lon2)) - min(min(lon1),min(lon2));
end

IDgeoNum = round(RangeLat/Grid+1)*round(RangeLon/Grid+1);
LatNum = round(RangeLat/Grid+1);

temp = floor(min(min(time1),min(time2)));
time1 = time1-temp;
time2 = time2-temp;

% ID
lat1 = round(lat1/Grid);
lon1 = round(lon1/Grid);
IDgeo1 = lat1+lon1*LatNum;
time1 = round(time1*w);
ID1 = IDgeo1+time1*IDgeoNum;

lat2 = round(lat2/Grid);
lon2 = round(lon2/Grid);
IDgeo2 = lat2+lon2*LatNum;
time2 = round(time2*w);
ID2 = IDgeo2+time2*IDgeoNum;

% match
[cID,idx1] = intersect(ID1,ID2,Sort); % default is sorted

clat = lat1org(idx1);
clon = lon1org(idx1);
ctime = time1org(idx1);

idx1 = ismember(ID1,cID);
ID1 = ID1(idx1);

idx2 = ismember(ID2,cID);
ID2 = ID2(idx2);


