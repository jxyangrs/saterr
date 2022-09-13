function saterr_imp_scanning
% scanning angle and geometry
% SC geo is also determined for case of Real_SCFOV
%
%
% Input:
%   case {'Keplerian','Real_SC'}
%       Rad.scan.angle_res,         azimuth resolution (degree),            scalar
%       Rad.scan.angle_center,      angular center for cs,cc,cw (degree),   [1,3]
%       Rad.scan.period,            period per rotation (degree),           scalar
%       Rad.scan.angle_tilt,        tilt angle wrt nadir (degree),          scalar
%
%   case {'Real_SCFOV'}
%       Orbit.fov.lat,              FOV latitude (degree),                  [crosstrack,alongtrack],    NED;>0=downward,<0=upward;
%       Orbit.fov.lon,              FOV longitude (degree),                 [crosstrack,alongtrack],	NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.lat,               spacecraft latitude (degree),           [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lon,               sc longitude (degree),                  [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.h,                 sc altitude (degree),                   [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.ind_center,        scanning index of flight direction (km), [scalar or array]
%
% Output:
%   case {'Keplerian','Real_SC'}
%       --crosstrack
%       Rad.scan.cs_angscan,        scene azimuth angle (degree),           [cs crosstrack,1]
%       Rad.scan.cc_angscan,        cold-space azimuth angle (degree),   	[cc crosstrack,1]
%       Rad.scan.cw_angscan,        warm-load azimuth angle (degree),       [cw crosstrack,1]
%       Rad.scan.scantilt,          tilt angle wrt nadir (degree),          [crosstrack,1],             NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            azimuth angle (degree),                 [crosstrack,1],             NED(clockwise);e.g.,when flight direction is north,0=north,-90=west
%       --conical
%       Rad.scan.cs_angscan,        scene azimuth angle (degree),           [cs crosstrack,1]
%       Rad.scan.cc_angscan,        cold-space azimuth angle (degree),   	[cc crosstrack,1]
%       Rad.scan.cw_angscan,        warm-load azimuth angle (degree),       [cw crosstrack,1]
%       Rad.scan.scantilt,          tilt angle wrt nadir (degree),          [crosstrack,1],             NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            azimuth angle (degree),                 [crosstrack,1],             NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%
%   case {'Real_SCFOV'}
%       Rad.scan.scantilt,          scan tilt angle wrt nadir (degree),     [crosstrack,alongtrack],	NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            scan azimuth angle (degree),            [crosstrack,alongtrack],    NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       Orbit.sc.az,                spacecraft azimuth (degree),            [crosstrack,alongtrack]
%       Orbit.sc.lat,               spacecraft latitude (degree),           [crosstrack,alongtrack]
%       Orbit.sc.lon,               spacecraft longitude (degree),          [crosstrack,alongtrack]
%       Orbit.sc.h,                 spacecraft altitude (km),               [crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: scanning angle, azimuth, tilt
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: angle of cc and cw for reflector emission
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations

global Rad Orbit

% -----------------------------
% implement
% -----------------------------
switch Orbit.onoff
    case 0
        % determining scanning geometry from the scanning settings 
        saterr_imp_scanning_1fromscanset
        
    case 1
        % determining scanning geometry from the scanning settings or observational orbit 
        switch Orbit.type
            case {'Keplerian','Real_SC'}
                % -----------------------------
                % determine scanning geometry for 'Keplerian','Real_SC'
                % -----------------------------
                
                % % determining scanning geometry from the scanning settings 
                saterr_imp_scanning_1fromscanset
                
            case {'Real_SCFOV'}
                % -----------------------------
                % determine scanning geometry for 'Real_SCFOV'
                % -----------------------------
                saterr_imp_scanning_2fromobsretr
                
            case {'Real_FOV'}
                % -----------------------------
                % determine scanning geometry for 'Real_FOV'
                % -----------------------------
                saterr_imp_scanning_3combo
                
            case {'Real_AllFromObs'}
                % -----------------------------
                % all scanning parameters are from observation
                % -----------------------------
                saterr_imp_scanning_4allfromobs

            otherwise
                error('Rad.scantype')
                
        end
        
    otherwise
        error('Orbit.onoff')
        
end
