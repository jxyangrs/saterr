function [sc_azc] = scgeo2scaz(sc_lat,sc_lon,sc_h)
% determine spacecraft center azimuth
% 
% Input:
%       sc_lat,         sc latitude,        [1,alongtrack]
%       sc_lon,         sc latitude,        [1,alongtrack]
%       sc_h,           sc altitude,        [1,alongtrack]
% 
% Output:
%       sc_azc,         sc center az,       [1,alongtrack]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/03/2019: original code

N = size(sc_lat);
sc_lat = sc_lat(:)';
sc_lon = sc_lon(:)';
sc_h = sc_h(:)';

% ECEF vector
[a,b,e] = earth_wgs84;
[x,y,z] = gd2gc(sc_lat,sc_lon,sc_h,a,e);

% line of intersection
dx = diff(x);
dy = diff(y);
dz = diff(z);

xe = 2*dx(end)-dx(end-1);
dx = [dx,xe];
ye = 2*dy(end)-dy(end-1);
dy = [dy,ye];
ze = 2*dz(end)-dz(end-1);
dz = [dz,ze];

[x3, y3, z3] = gco2enu(dx,dy,dz,sc_lat,sc_lon);

% sc atitude and scanning angle
[sc_azc, elev, rs] = enu2ang(x3,y3,z3);
sc_azc = reshape(sc_azc,N);
