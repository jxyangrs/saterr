function saterr_set_faraday
% setting Faraday rotation
% Faraday rotation takes place due to ionosphere and Earth magnetic field. 
% It is pronounced for low-frequency or polarimetric radioemters (e.g. third Stokes)
%
% Input:
%       Faraday.iono.VTEC,      vertical total electron content (TECU),     [cross-track,alongtrack]/scalar
%       Faraday.iono.h,         ionosphere altitude (km),                   scalar
%       Faraday.magfield.B,     magnetic field (nano Tesla),                'IGRF'/'customize'([cross-track,alongtrack]/scalar)
% 
% Output:
%       Faraday.iono.VTEC,      total electron content (TECU),              [cross-track,alongtrack]/scalar
%       Faraday.iono.h,         ionosphere altitude (km),                   scalar
%       Faraday.magfield.B,     magnetic field (nano Tesla),                'IGRF'/'customize'([cross-track,alongtrack]/scalar)
%
% Description:
%       Magnetic filed can be computed with model or customized with observational data, and default is 
%       International Geomagnetic Reference Field (IGRF) model is of version 12th that is valide through 1990-2020
% 
%       The ionosphere is assumed as a shell layer of electron at a specific altitude above ground (default is 400 km)
%
%       Equations:
%               omega = 1.355e-5*f^(-2)*B*cos(gamma)*VTEC*secd(theta); 
%       where omega is in degree, 
%           f is EM frequency (GHz),
%           B is geomagnetic field (nano Tesla), gamma is the angle between EM wave propagation direction and B on the ionosphere shell,
%           VTEC is the vertical total electron (TECU;1 TECU=1.6e10 electron/m^2), 
%           theta is the local zenith angle of EM wave intersected with the ionosphere (degree)
%       Stokes change due to Faraday rotation is:
%               [Tv'  = [cosd(omega)^2   sind(omega)^2  1/2*sind(2*omega)  0  * [Tv
%                Th'     sind(omega)^2   cosd(omega)^2  -1/2*sind(2*omega) 0     Th
%                T3'     -sind(2*omega)  sind(2*omega)  cosd(2*omega)      0     T3
%                T4']    0               0              0                  1]    T4]
%       where the left Stokes is before entering ionosphere, and the right Stokes is from going through ionosphere
%       The above equation is equivalent to:
%               Q   =   Tv-Th;
%               U   =   T3;
%               d   =   Q*sind(omega)^2 - U/2*sind(2*omega);
%               Tv' =   Tv - d;
%               Th' =   Th + d;
%               U'  =   U*cosd(2*omega) - Q*sind(2*omega);
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/31/2019: original code

global Faraday Rad

% -----------------------------
% setting
% -----------------------------
Faraday.onoff = 0; % 0=off,1=on

if Faraday.onoff ==1
    
    % -----------------------------
    % set total electron content:
    % Faraday.iono.VTEC, total electron content (TECU), [cross-track,alongtrack]/scalar
    % Faraday.iono.h,   ionosphere altitude (km),      scalar
    % -----------------------------
    Faraday.iono.source = 'constant'; % constant/import
    
    % example of importing
    switch Faraday.iono.source
        case 'constant'
            Faraday.iono.VTEC = 20; % vertical total electron content (TECU); 1 TECU=1.6e10 electron/m^2; 
            Faraday.iono.h = 400; % ionosphere altitude (km)
        case 'import'
            data = load('sample_smap_TEC.mat');
            Faraday.iono.VTEC = double(data.fov_TEC); % VTEC (TECU), [crosstrack,alongtrack]
            Faraday.iono.h = 400; % ionosphere altitude (km)
    end
    
    % -----------------------------
    % set magnetic field:
    % Faraday.magfield.B,   magnetic field (nano Tesla),    [crosstrack,alongtrack]
    % -----------------------------
    Faraday.magfield.source = 'IGRF'; % IGRF/customize
    switch Faraday.magfield.source
        case 'IGRF'
            Faraday.magfield.B = []; % initialize; magnetic field will be computed w/ IGRF model; valid time ranges from year 1990-2020
        case 'customize'
            Faraday.magfield.B = []; % customize magnetic field for every FOV
    end
    
    % time step
    % Compute magnetic field w/ timestep every orbit, or every scanning. The last one is slowest due to a long loop
    Faraday.magfield.timestep = 'EveryOrbit'; % EveryOrbit/constantTime/EveryScan
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_faraday
    
end
