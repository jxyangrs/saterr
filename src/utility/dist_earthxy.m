function [x,y] = dist_earthxy(lat1,lon1,lat2,lon2)
% arc distance (km) in meridian and prime vertical planes of WGS84 ellipsoid Earth
% 
% Input (degree):
%         lat1, latitude of center, 1D/2D [pixel-1,1]/[pixel-1,pixel-2]
%         lon1, longitude of center, range [-180,180), 1D/2D [pixel-1,1]/[pixel-1,pixel-2]
%         lat2, latitude to center, 1D/2D [1,pixel-2]/[pixel-1,pixel-2]
%         lon2, longitude to center, range [-180,180), 1D/2D [1,pixel-2]/[pixel-1,pixel-2]
% 
% Output (km):
%         x, distance in prime vertical plane, 1D/2D [1,lat2 pixel],[lat1 pixel,lat2 pixel]
%         y, distance in meridian plane 
% 
% Examples:
%         lat1=-60:60;lon1=-60:60;lat2=(-60:60)+3;lon2=(-60:60)+3;
%         [x,y] = dist_earthxy(lat1,lon1,lat2,lon2);
% 
%         lat1=-60:60;lon1=-60:60;lat2=7;lon2=8;
%         [x,y] = dist_earthxy(lat1,lon1,lat2,lon2);
% 
%         lat1=(-60:60)';lon1=(-60:60)';lat2=-50:50;lon2=-50:50;
%         [x,y] = dist_earthxy(lat1,lon1,lat2,lon2);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/16/2016
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 1/25/2017: debug preprocess

% preprocess for different sizes
if size(lat1,1)~=size(lat2,1) || size(lat1,2)~=size(lat2,2) 
    lat1=lat1(:);
    lon1=lon1(:);
    lat2=lat2(:)';
    lon2=lon2(:)';
    n1=size(lat1,1);
    n2=size(lat2,2);
    lat1=lat1(:,ones(n2,1));
    lon1=lon1(:,ones(n2,1));
    lat2=lat2(ones(n1,1),:);
    lon2=lon2(ones(n1,1),:);
end

% WGS84 ellipsoid Earth
Ra = 6378.137; % Earth ellipsoid semi-major (km); see referenceEllipsoid('wgs84');
e = 0.081819190842621; % eccentricity

% prime vertical arc distance with correcting issues of over-half-cicrle
dlon = lon2-lon1;
clear lon2 lon1
idx=dlon>180; % correcting issues of over-half-circle
dlon(idx)=-rem(360,dlon(idx));
idx=dlon<-180;
dlon(idx)=rem(360,dlon(idx));
clear idx
Rn = Ra./(1-e^2*sin(lat1/180*pi).^2); % radius of curvature in prime vertical plane, Rn=Ra/(1-e^2*sin(lat)^2), lat (radian)
x = Rn.*cos(lat1/180*pi).*dlon/180*pi;
clear Rn dlon

% meridian arc distance
% dm=(111132.95251*(lat2-lat1)-16038.50861*(sin(lat2*pi/90)-sin(lat1*pi/90)))/1e3; % lat2&lat1 (degree), dm (km); accuracy better than 17 meter
% reference: Pallikaris et al. 2009, New meridian arc formulas for sailing calculations in GIS, International Hydrographic Review.
y = (111132.95251*(lat2-lat1)-16038.50861*(sin(lat2*pi/90)-sin(lat1*pi/90)))/1e3;
