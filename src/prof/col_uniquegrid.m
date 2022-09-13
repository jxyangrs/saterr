function [idxuniq,idxIDall] = col_uniquegrid(lat,lon,latgeo,longeo)
% popoluate unique ID w/ gridded latitude and longitude
% 
% Input: 
%       lat,        latitude                [n1,1] (mono-increase w/ constant step)
%       lon,        longitude,              [m1,1] (mono-increase w/ constant step)
%       latgeo,     reference latitude      [grid,1]
%       longeo,     reference longitude     [grid,1]
% 
% Output:
%       idxuniq,    index of unique data grid
%       idxIDall,   index to reconstruct full grids
% 
% Examples:
%       latgeo = (-90:90)';longeo = (-180:179)';
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/27/2016: adaptive latgeo, longeo
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/27/2017: merge to collocation

% adjust range
minlongeo = min(longeo);
maxlongeo = max(longeo);
minlatgeo = min(latgeo);
maxlatgeo = max(latgeo);

idx = lon<minlongeo;
lon(idx) = minlongeo;
idx = lon>maxlongeo;
lon(idx) = maxlongeo;

idx = lat<minlatgeo;
lat(idx) = minlatgeo;
idx = lat>maxlatgeo;
lat(idx) = maxlatgeo;

% reference coordinate
latstep = mean(diff(latgeo));
lonstep = mean(diff(longeo));
latgeo = round((latgeo-minlatgeo)/latstep);
longeo = round((longeo-minlongeo)/lonstep);

if (latgeo(end)-latgeo(1)+1)~=length(latgeo) || (longeo(end)-longeo(1)+1)~=length(longeo)
    warning('latitude and longitude of geophysical field are not regularized')
end
n1 = length(longeo);
n2 = length(latgeo);

% input coordinate
lat = round((lat-minlatgeo)/latstep);
lon = round((lon-minlongeo)/lonstep);
ID = lat+lon*n2;

[~,idxuniq,idxIDall] = unique(ID);


