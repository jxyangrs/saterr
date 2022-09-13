function varargout = col_prof2grid(lat,lon,latgeo,longeo,varargin)
% allocate gridded profiles to satellite FOV
%
% Input:
%       lat,          latitude of FOV,        [n1 1]
%       lon,          longitude of FOV,       [n2 1]
%       latgeo,       latitude of grid,       [m1,1] (constant interval)
%       longeo,       longitude of grid,      [m2,1] (constant interval)
%       varargin,     gridded profiles,       [m1,m2,height], 2D/3D
% 
% Output:
%       varargout,    profiles,               [altitude,n1]
% 
% Examples:
%       allocate ERA profiles (0.25-by-0.25 degree grid) to satellite FOVs of lat&lon
%       longeo = (0:0.25:359.75)';latgeo = -90:0.25:90;
%       [T,wind] = col_prof2grid(lat,lon,latgeo,longeo,T,wind); % T=3D, wind=2D
%     
% Examples:
%       longitudes (lon&longeo etc.) should have consistent range [-180,180] or [0,360]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/10/2016: enable flexible reference coordinate
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/01/2016: refine variable and help

% adjust range
latgeo = latgeo(:);
longeo = longeo(:);

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
latgeo = latgeo(:,ones(n1,1));
longeo = longeo';
longeo = longeo(ones(n2,1),:);

IDgeo = latgeo+longeo*n2;
IDgeo = IDgeo(:);

% input coordinate
lat = round((lat-minlatgeo)/latstep);
lon = round((lon-minlongeo)/lonstep);
ID = lat+lon*n2;

[~,idxref,~] = intersect(IDgeo,ID);
[~,~,idxtar] = unique(ID);
n = length(IDgeo);

% intersect
for i=1: nargin-4
    x = varargin{i};
    if length(size(x))==2 % for parameters without height dimension
        x = x(:); % transform to dimensions [grid,height]
        idx = idxref; 
        x = x(idx);
    elseif length(size(x))==3 % for parameters with height dimension
        nh = size(x,3);
        x = reshape(x,[],nh); % transform to dimensions [grid,height]
        idx = repmat(idxref,[1,nh]) + repmat((0:nh-1)*n,[size(idxref,1) 1]); 
        x = x(idx);
    else
        error('Matrix dimension is larger than 2')
    end
    % allocate intersected parameters to target
    x = x(idxtar,:);
    % transform to be with dimensions: [height,grid]
    varargout{i} = x';
end

