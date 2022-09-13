function saterr_imp_scanning_4allfromobs
% all scanning parameters are from observations (rare in any satellite data)
%
% Input & Output:
%       Orbit.fov.lat,              FOV latitude (degree),                  [crosstrack,alongtrack],    NED;>0=downward,<0=upward;
%       Orbit.fov.lon,              FOV longitude (degree),                 [crosstrack,alongtrack],	NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.lat,               spacecraft latitude (degree),           [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lon,               sc longitude (degree),                  [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.h,                 sc altitude (degree),                   [1,alongtrack]/[crosstrack,alongtrack]
%       Rad.scan.scantilt,          scan tilt angle wrt nadir (degree),     [crosstrack,alongtrack],	NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            scan azimuth angle (degree),            [crosstrack,alongtrack],    NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.az,                spacecraft azimuth (degree),            [crosstrack,alongtrack]
%       Orbit.sc.lat,               spacecraft latitude (degree),           [crosstrack,alongtrack]
%       Orbit.sc.lon,               spacecraft longitude (degree),          [crosstrack,alongtrack]
%       Orbit.sc.h,                 spacecraft altitude (km),               [crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: original code

% input & output
% Orbit.fov.lat;
% Orbit.fov.lon;
% Orbit.sc.lat;
% Orbit.sc.lon;
% Orbit.sc.h;
% 
% Rad.scan.scantilt;
% Rad.scan.scanaz;
% 
% Orbit.sc.az;
% Orbit.sc.lat;
% Orbit.sc.lon;
% Orbit.sc.h;
% 
% Rad.scan.cs_angscan
% Rad.scan.cc_angscan
% Rad.scan.cw_angscan

