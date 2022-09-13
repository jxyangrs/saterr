function saterr_set_geoorbit
% setting of spacecraft orbit
%   for studying attitude offset, polarlization misalignment, etc.
%
% Input:
%       Oribit,     Keplerian/Real_SC/Real_SCFOV,       Keplerian=modeling Keplerian orbit;Real_SC=import actual SC orbit;Real_SCFOV=import SC&FOV geolocation
%       
% Output:
%       Modeled spacecraft oribit or imported realistic orbit
% 
% Description:
%       Keplerian,      sc orbit is from a Keplerian model;
%       Real_SC,        sc orbit is from observation
%       Real_SCFOV,     sc orbit and FOV geo are from observation
%       Real_FOV,     FOV geo is from observation w/o sc orbit since many simulation needs no sc orbit
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: original code

global Rad Orbit Path

% -----------------------------
% setting
% -----------------------------
Orbit.onoff = 1; % orbit setting, 0=off,1=on;

if Orbit.onoff == 1
    Orbit.type = 'Keplerian'; % Keplerian/Real_SC/Real_SCFOV/Real_FOV/Real_AllFromObs
    
    if strcmp(Path.scheme,'B')
        Orbit.type = 'Real_SCFOV'; % Real_SC/Real_SCFOV/Real_FOV; Real_SCFOV can study attitude; 
    end
    
    switch Orbit.type
        case 'Keplerian'
            % setting Keplerian orbit
            saterr_set_geoorbit_kepler
            
        case 'Real_SC'
            % setting spacecraft geolocation
            saterr_set_geoorbit_real_sc

        case {'Real_SCFOV','Real_FOV'}
            % setting spacecraft and footprint FOV geolocation
            saterr_set_geoorbit_real_scfov

        case {'Real_AllFromObs'}
            % setting spacecraft and footprint FOV geolocation
            saterr_set_geoorbit_real_allfromobs
    end
        
end
