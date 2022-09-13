function saterr_imp_scanning_2fromobs
% determining scanning geometry from the observations (SC and FOV geolocation)
%
% Input:
%       Orbit.fov.lat,              FOV latitude (degree),                  [crosstrack,alongtrack],    NED;>0=downward,<0=upward;
%       Orbit.fov.lon,              FOV longitude (degree),                 [crosstrack,alongtrack],	NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.lat,               spacecraft latitude (degree),           [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lon,               sc longitude (degree),                  [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.h,                 sc altitude (degree),                   [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.ind_center,        scanning index of flight direction (km), [scalar or array]
%
% Output:
%       Rad.scan.scantilt,          scan tilt angle wrt nadir (degree),     [crosstrack,alongtrack],	NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            scan azimuth angle (degree),            [crosstrack,alongtrack],    NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.az,                spacecraft azimuth (degree),            [crosstrack,alongtrack]
%       Orbit.sc.lat,               spacecraft latitude (degree),           [crosstrack,alongtrack]
%       Orbit.sc.lon,               spacecraft longitude (degree),          [crosstrack,alongtrack]
%       Orbit.sc.h,                 spacecraft altitude (km),               [crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit 

% -----------------------------
% implementing
% -----------------------------




fov_lat = Orbit.fov.lat;
fov_lon = Orbit.fov.lon;
sc_lat = Orbit.sc.lat;
sc_lon = Orbit.sc.lon;
sc_h = Orbit.sc.h;
sc_indcenter = Orbit.sc.ind_center;

[sc_az,sc_scannadir,sc_scanaz,sc_lat,sc_lon,sc_h] = scfov2scaninterp(fov_lat,fov_lon,sc_lat,sc_lon,sc_h,sc_indcenter);

Rad.scan.scantilt = sc_scannadir;
Rad.scan.scanaz = sc_scanaz;

Orbit.sc.az = sc_az;
Orbit.sc.lat = sc_lat;
Orbit.sc.lon = sc_lon;
Orbit.sc.h = sc_h;
