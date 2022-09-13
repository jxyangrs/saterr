function saterr_imp_orbitsingle
% scanning geometry along the orbit
%
% Input:
%   case 'Keplerian'
%       --six Keplerian orbit elements
%       a,                          orbital semi-major axis (km),               scalar
%       e,                          orbital eccentricity,                       scalar
%       i,                          inclination (degrees),                      scalar (range [0,180])
%       wa,                         longitude of ascending node (degree),       scalar (range [0,360])
%       w,                          argument of perigee (degrees),              scalar (range [0,360])
%       M,                          mean anomaly at epoch t0 (degrees),         scalar (range [0,360])
%       --radiometer scanning
%       Rad.scan.scantilt,          radiometer scan tilt angle (degree),        [crosstrack,1]
%       Rad.scan.scanaz,            radiometer scan azimuth angle (degree),     [crosstrack,1]
% 
%   case 'Real_SC'
%       --sc orbit
%       Orbit.sc.az,                spacecraft azimuth (degree),                [crosstrack,alongtrack]
%       Orbit.sc.lat,               spacecraft latitude (degree),               [crosstrack,alongtrack]
%       Orbit.sc.lon,               spacecraft longitude (degree),              [crosstrack,alongtrack]
%       Orbit.sc.h,                 spacecraft altitude (km),                   [crosstrack,alongtrack]
%       --radiometer scanning
%       Rad.scan.scantilt,          radiometer scan tilt angle (degree),        [crosstrack,1]
%       Rad.scan.scanaz,            radiometer scan azimuth angle (degree),     [crosstrack,1]
% 
%   case 'Real_SC'
%       the same orbit
% 
% Output:
%       Orbit.sc.lat,               spacecraft latitude (degree),               [crosstrack,alongtrack]
%       Orbit.sc.lon,               sc longitude (degree),                      [crosstrack,alongtrack]
%       Orbit.sc.h,                 sc altitude (degree),                       [crosstrack,alongtrack]
%       Orbit.sc.az,                sc azimuth (degree),                        [crosstrack,alongtrack]
%       Orbit.sc.time,              sc time (degree),                           [1,alongtrack]
%       Orbit.scan.scantilt,        radiometer scan tilt angle (degree),        [crosstrack,alongtrack]
%       Orbit.scan.scanaz,          radiometer scan azimuth angle (degree),     [crosstrack,alongtrack]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code

global Rad Orbit

% -----------------------------
% implement
% -----------------------------

if Orbit.onoff==1
    switch Orbit.type
        case 'Keplerian'
            ind_startend = Rad.alongtrack_orbit_ind_startend(Rad.norbit,:);
            ind = ind_startend(1): ind_startend(2);
            
            % output
            Orbit.sc.h = Orbit.multiorbit.sc.h(:,ind);       % [crosstrack,alongtrack]
            Orbit.sc.lat = Orbit.multiorbit.sc.lat(:,ind);   % [crosstrack,alongtrack]
            Orbit.sc.lon = Orbit.multiorbit.sc.lon(:,ind);   % [crosstrack,alongtrack]
            Orbit.sc.az = Orbit.multiorbit.sc.az(:,ind);     % [crosstrack,alongtrack]
            Orbit.sc.time = Orbit.multiorbit.sc.time(:,ind); % [1,alongtrack]

            Orbit.scan.scantilt = Orbit.multiorbit.scan.scantilt(:,ind); % [crosstrack,alongtrack]
            Orbit.scan.scanaz = Orbit.multiorbit.scan.scanaz(:,ind); % [1,alongtrack]
            
        case 'Real_SC'
            % loading single orbit 
            
        case {'Real_SCFOV','Real_FOV','Real_AllFromObs'}
            % loading single orbit
            
    end
    
end

