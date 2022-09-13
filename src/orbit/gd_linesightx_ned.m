function [lat2,lon2,eia2,az2,rs2] = gd_linesightx_ned(lat,lon,h,un,ue,ud)
% geodetic location and angle of line-of-sight intersection
% 
% Input:   
%         lat,     latitude (degree),       N-D
%         lon,     longitude (degree),      N-D
%         h,       altitude (km),           N-D
%         un,      north,                   N-D
%         ue,      east,                    N-D
%         ud,      down,                    N-D
% Output:  
%         lat2,    intersect latitude (degree),     NaN if no intersection
%         lon2,    intersect longitude (degree)
%         eia2,    earth incidence angle (degree)
%         az2,     azimuth angle (degree)
%         rs2,     slant range (km)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/19/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/04/2019: NED

% satellite coordinate
[a,b,e] = earth_wgs84;
[x1,y1,z1] = gd2gc(lat,lon,h,a,e);

[ue,un,uu] = xenu2ned(un,ue,ud);

[ux, uy, uz] = enuo2gc(lat,lon,ue,un,uu);
n = sqrt(ux.^2+uy.^2+uz.^2);
ux = ux./n;
uy = uy./n;
uz = uz./n;

% intersect
uz = (a/b)*uz;
[x2,y2,z2,rn2] = interlos(ux,uy,uz,x1/a,y1/a,z1/b);

[lat2,lon2,h2] = gc2gd(a*x2,a*y2,b*z2,a,e);
rs2 = a*rn2;

% local angle
[x2,y2,z2] = gd2gc(lat2,lon2,h2,a,e);
dx = x1-x2;
dy = y1-y2;
dz = z1-z2;
[x,y,z] = gco2enu(dx,dy,dz,lat2,lon2);
[az2,elev2,~] = enu2ang(x,y,z);
eia2 = 90-elev2;

