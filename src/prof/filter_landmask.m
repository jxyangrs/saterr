function idx_land = filter_landmask(lat,lon,LatMask,LonMask,LandMask)
% generating land index
%   make sure lon, LonMask have the same range [-180,180], or [0,360]
%
% Input:
%       lat,        latitude,       [m1,m2] (constant-step; monotonic not necessary)
%       lon,        longitude,      [m1,m2] (constant-step; monotonic not necessary)
%       LatMask,    mask lat,       [n1,1]
%       LonMask,    mask lon,       [1,n2]
%       LandMask,   mask,           [n1,n2]
%                   (1=land,0=water)
%
% Output:
%       idx_land,   logical index,  [m1,1]
%                   (1=land,0=ocean)
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/19/2017: flexible mask
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/19/2018: refined from sub_filterLand.m, mask as input

[n1,n2] = size(LandMask);

latstep = mean(diff(LatMask));
lonstep = mean(diff(LonMask));

minlat = min(LatMask);
minlon = min(LonMask);
maxlat = max(LatMask);
maxlon = max(LonMask);

latgeo = round((LatMask-minlat)/latstep);
longeo = round((LonMask-minlon)/lonstep);
geogrid = bsxfun(@plus,latgeo(:),longeo(:)'*n1);
IDgeo = geogrid(logical(LandMask));

lat(lat<minlat)=minlat;
lon(lon<minlon)=minlon;
lat(lat>maxlat)=maxlat;
lon(lon>maxlon)=maxlon;

lat = round((lat-minlat)/latstep);
lon = round((lon-minlon)/lonstep);
ID = lat + lon*n1;

idx_land = ismember(ID, IDgeo);
