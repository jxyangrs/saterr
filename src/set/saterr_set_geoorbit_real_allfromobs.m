function saterr_set_geoorbit_real_allfromobs
% setting by importing real spacecraft (sc) orbit
%   all scanning parameters are from observation
%
% Input/Output:
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
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: original code

global Rad Orbit Path

% -----------------------------
% setting
% -----------------------------
if Orbit.onoff == 1
    
    Orbit.data.source = 'Default'; % Default/External_Data
    
    if Path.scheme=='B' % scheme B uses external reanalysis data
        Orbit.data.source = 'External_Data';
    end
    
    switch Orbit.data.source
        case 'Default'
            % input satellite orbit
            switch Rad.sensor
                case {'customize'}
                    % cumtomize spacecraft orbit
                    n1 = Rad.ind_CT_num(1);
                    n2 = Rad.num_alongtrack;
                    
                    % SC and FOV geo
                    Orbit.sc.h = 831*ones(n1,n2);           % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.lat = 831*ones(n1,n2);         % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.lon = 831*ones(n1,n2);         % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.time = datenum([2019 1 1 0 0 0])*ones(n1,n2);  % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.time = round(n1/2);            % scalar
                    Orbit.fov.lat = rand(n1,n2);            % [crosstrack,alongtrack]
                    Orbit.fov.lon = rand(n1,n2);            % [crosstrack,alongtrack]
                    Orbit.sc.az = floor(n1/2);      % scalar
                    
                otherwise
                    error('Rad.spacecraft')
            end
            
            % -----------------------------
            % parse
            % -----------------------------
            saterr_parse_geoorbit_real_scfov
            
        case {'External_Data'}
            % -----------------------------
            % setting
            % -----------------------------
            % read specific satellite data
            % read saterr_profcollocate.m for more details
            % This overwrite setting in saterr_set_path.m
            
            Orbit.data.path = Path.sensor.path;
            
        otherwise
            error('Orbit.data.source')
    end
    
end


