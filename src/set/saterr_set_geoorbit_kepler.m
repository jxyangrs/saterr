function saterr_set_geoorbit_kepler
% setting Keplerian orbit of six orbital elements:
%   Semi-major axis, Eccentricity, Argument of perigee, Right ascension of ascending node, Inclination, Mean anomaly
%
% Input:
%       Oribit setting
% 
% Output:
%       --six orbital elements
%       a,          semi-major axis (km); based on h of altitude (km),      scalar
%       e,          eccentricity,                                           scalar
%       w,          Argument of perigee (degree), [0,360],                  scalar
%       wa,         Right ascension of ascending node (degree),             scalar
%       i,          Inclination (degree), [0,180],                          scalar
%       M,          Mean anomaly (degree),                                  scalar
%       --start time
%       time,       start time (in datenum),                                scalar
% 
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/04/2019: original code

global Rad Orbit Path

% -----------------------------
% setting
% -----------------------------
Re = 6378; % Earth radius (km)

if Orbit.onoff == 1
    
    switch Rad.spacecraft
        
        case 'customize'
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 831; % altitude (km)
            a = Re+h; % semi-major axis (km)
            e = 0; % eccentricity
            w = 180; % Argument of perigee (degree), [0,360]
            wa = 195; % Right ascension of ascending node (degree)
            i = 98.7; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
            
        case {'metop-a','metop-b','metop-c'}
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 831; % Altitude (km)
            a = Re+h; % Semi-major axis (km)
            e = 0; % Eccentricity
            w = 180; % Argument of perigee (degree)
            wa = 195; % Right ascension of ascending node (degree)
            i = 98.7; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
            
        case {'noaa-19'}
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 863; % altitude (km)
            a = Re+h; % semi-major axis (km)
            e = 0; % eccentricity
            w = 180; % Argument of perigee (degree)
            wa = 195; % Right ascension of ascending node (degree)
            i = 98.7; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
            
        case {'gcom-w'}
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 714; % altitude (km)
            a = Re+h; % semi-major axis (km)
            e = 0; % eccentricity
            w = 180; % Argument of perigee (degree)
            wa = 195; % Right ascension of ascending node (degree)
            i = 98.2; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
            
        case {'tempest-d'}
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 400; % altitude (km)
            a = Re+h; % semi-major axis (km)
            e = 0; % eccentricity
            w = 180; % Argument of perigee (degree)
            wa = 195; % Right ascension of ascending node (degree)
            i = 51.6; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
            
        case {'tropics-pathfinder'}
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 550; % altitude (km)
            a = Re+h; % semi-major axis (km)
            e = 0; % eccentricity
            w = 180; % Argument of perigee (degree)
            wa = 195; % Right ascension of ascending node (degree)
            i = 98.7; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
            
        otherwise
            % -----------------------------
            % orbit parameters
            % -----------------------------
            h = 831; % altitude (km)
            a = Re+h; % semi-major axis (km)
            e = 0; % eccentricity
            w = 180; % Argument of perigee (degree), [0,360]
            wa = 195; % Right ascension of ascending node (degree)
            i = 98.7; % Inclination (degree), [0,180]
            M = 0; % Mean anomaly (degree)
            
            % -----------------------------
            % starting time (UTC in datenum format)
            % time is needed if Faraday rotation is turned on
            % -----------------------------
            time = 0; % initilizing
    end
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_geoorbit_kepler
    
end



