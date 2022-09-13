function saterr_set_geoorbit_real_sc
% setting by importing real spacecraft (sc) orbit
%   Given spacecraft orbit, the code will combine it with scanning setting to determine footprint location, Earth incidence angle, etc.
%
% Input:
%       Orbit.sc.h,       sc altitude (km),                     [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.az,      sc azimuth angle (degree),            [1,alongtrack]/[crosstrack,alongtrack]
%                         0=north,90=east,-90=west,180=south
%       Orbit.sc.lat,     sc geodetic latitude,                 [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lon,     sc geodetic longitude,                [1,alongtrack]/[crosstrack,alongtrack]
%
% Output:
%       Orbit setting
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
                    n1 = Rad.num_crosstrack;
                    n2 = Rad.num_alongtrack;
                    
                    % sc geo
                    Orbit.sc.h = 831*ones(n1,n2);    % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.az = 831*ones(n1,n2);   % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.lat = 831*ones(n1,n2);  % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.lon = 831*ones(n1,n2);  % [1,alongtrack]/[crosstrack,alongtrack]
                    Orbit.sc.time = datenum([2019 1 1 0 0 0])*ones(n1,n2);  % [1,alongtrack]/[crosstrack,alongtrack]
                    
                case {'mhs','Demo'}
                    % an example orbit of mhs
                    
                    % sc geo
                    data = load('sample_orbit_mhs.mat');
                    
                    Orbit.sc.h = double(data.hsc);
                    Orbit.sc.az = double(data.azsc);
                    Orbit.sc.lat = double(data.latsc);
                    Orbit.sc.lon = double(data.lonsc);
                    Orbit.sc.time = double(data.timesc);
                    
                case {'amsr2'}
                    % an example orbit of amsr2
                    
                    % sc geo
                    data = load('sample_orbit_amsr2.mat');
                    
                    Orbit.sc.h = double(data.hsc);
                    Orbit.sc.az = double(data.azsc);
                    Orbit.sc.lat = double(data.latsc);
                    Orbit.sc.lon = double(data.lonsc);
                    Orbit.sc.time = double(data.timesc);
                    
                otherwise
                    error('Rad.spacecraft')
            end
            
            % -----------------------------
            % parse
            % -----------------------------
            saterr_parse_geoorbit_real_sc
            
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


