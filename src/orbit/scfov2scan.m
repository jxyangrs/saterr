function [sc_azc,sc_scannadir,sc_scanaz] = scfov2scan(fov_lat,fov_lon,fov_h,sc_lat,sc_lon,sc_h,sc_indc)
% determine spacecraft scanning
% sc_azc is calculated with FOV and SC
% 
% Input:
%       fov_lat,        fov latitude,       [crosstrack,alongtrack]
%       fov_lon,        fov latitude,       [crosstrack,alongtrack]
%       fov_h,          fov altitude,       [crosstrack,alongtrack]
%       sc_lat,         sc latitude,        [crosstrack,alongtrack]
%       sc_lon,         sc latitude,        [crosstrack,alongtrack]
%       sc_h,           sc altitude,        [crosstrack,alongtrack]
%       sc_indc,        scanning index of   [crosstrack index] (e.g. [15,16] out of 1:30)
%                       sc direction,        
% 
% Output:
%       sc_azc,         sc center az,       [crosstrack,alongtrack]
%       sc_scannadir,   scanning nadir,     [crosstrack,alongtrack]
%       sc_scanaz,      scanning azimuth,   [crosstrack,alongtrack]
%                       wrt sc_azc
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/03/2019: original code

[n1,n2] = size(fov_lat);

% ECEF vector
[a,b,e] = earth_wgs84;

[x1,y1,z1] = gd2gc(fov_lat,fov_lon,fov_h,a,e);
[x2,y2,z2] = gd2gc(sc_lat,sc_lon,sc_h,a,e);

% line of intersection
dx = x1-x2;
dy = y1-y2;
dz = z1-z2;

[x3, y3, z3] = gco2enu(dx,dy,dz,sc_lat,sc_lon);

% sc atitude and scanning angle
[az, elev, rs] = enu2ang(x3,y3,z3);

sc_azc = mean(az(sc_indc,:),1);

sc_scannadir = 90 + elev; % from center scanning

% scanning azimuth
sc_scanaz = bsxfun(@minus,az,sc_azc);
sc_azc = sc_azc(ones(n1,1),:);

