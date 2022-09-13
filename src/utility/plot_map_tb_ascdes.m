function h_colorbar = plot_map_tb_ascdes(tb,lat,lon,orbit_node,varargin)
% Input:
%       tb,             tb or variables to plot,        [cross-track,along-track]
%       lat,            latitude,                       [cross-track,along-track]
%       lon,            longitude,                      [cross-track,along-track]
%       orbit_node,     orbit node,                     asc/des/both
%       opt_lonrange,   longitude range,                1/2; 1=[-180,180],2=[0,360]
%
% Output:
%       figures of map asc/des/both
%
% Examples:
%       figure(1)
%       set(1,'paperposition',[0 0 12 6])
%       plot_map_tb_ascdes(tb,lat,lon,'asc',2)
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/09/2019: original code

% -------------------------
% setting
% -------------------------
if ~isempty(varargin)
    opt_lonrange = varargin{1};
else % default is 1([-180,180])
    opt_lonrange = 1;
end

[clat,clon] = plot_map_coastline(opt_lonrange);

% -------------------------
% processing
% -------------------------
% asc/des
[idx_asc,idx_des] = idx_orbit_ascdes(lat(round(end/2),:));

% processing lat, lon
if opt_lonrange==1
    % [-180,180]
    idx = lon>180;
    lon(idx) = lon(idx) - 360;
else
    % [0,360]
    idx = lon<0;
    lon(idx) = lon(idx) + 360;
end

lat(abs(lat)>90) = NaN;
lon = plot_map_lonedgenan(lon);

% -------------------------
% plot
% -------------------------
[n1,n2] = size(tb);

if isempty(orbit_node)
    orbit_node = 'both';
end

switch orbit_node
    case 'asc'
        idx_node = idx_asc;
    case 'des'
        idx_node = idx_des;
    case 'both'
        idx_node = true(size(idx_asc));
    otherwise 
        error('orbit_node should be asc/des/both')
end

M = NaN(n1,n2);
M(:,idx_node) = tb(:,idx_node);

pcolor(lon,lat,M);
shading flat
h_colorbar = colorbar;

hold on
plot(clon,clat,'k')

