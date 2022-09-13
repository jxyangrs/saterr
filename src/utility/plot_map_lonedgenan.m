function lon = plot_map_lonedgenan(lon)
% mark edge of longitude as NaN
% 
% Input: 
%       lon, longitude, [cross-track,along-track]
% 
% Examples:
%       lon_plot = plot_map_lonedgenan(lon);
% 
% 

% dlon=abs(lon(:,:)-lon([2:end,end],[2:end,end]))  ...
%     +abs(lon([2:end,end],:)-lon(:,[2:end,end]));
% lon((dlon>60))=NaN;

% 
idx = abs(diff(lon([1:end,end],:),1,1))>60 | abs(diff(lon(:,[1:end,end]),1,2))>60;
lon(idx) = NaN;
