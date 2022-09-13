function saterr_set_geoorbit_real_scfov
% setting by importing real spacecraft (sc) orbit
%   Given spacecraft orbit & FOV, the code will determine scanning angle, Earth incidence angle, etc.
%
% Input:
%       Orbit.sc.h,             sc altitude (km),                     [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lat,           sc geodetic latitude,                 [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.lon,           sc geodetic longitude,                [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.time,          sc time (datenum),                    [1,alongtrack]/[crosstrack,alongtrack]
%       Orbit.sc.ind_center,    center index for flight direction,    scalar
%       Orbit.fov.lat,          fov geodetic longitude,               [crosstrack,alongtrack]
%       Orbit.fov.lon,          fov geodetic longitude,               [crosstrack,alongtrack]
%
% Output:
%       SC orbit setting
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
                    Orbit.sc.ind_center = floor(n1/2);      % scalar
                    
                case {'smap'}
                    % an example orbit of smap
                    
                    % SC and FOV geo
                    data = load('sample_orbit_smap.mat');
                    
                    Orbit.sc.h = double(data.hsc);
                    Orbit.sc.lat = double(data.latsc);
                    Orbit.sc.lon = double(data.lonsc);
                    Orbit.sc.time = double(data.timesc);
                    Orbit.sc.ind_center = double(data.ind_center);
                    Orbit.fov.lat = double(data.latfov);
                    Orbit.fov.lon = double(data.lonfov);
                    
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


