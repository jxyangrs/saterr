% parsing orbiting
%   store multiple orbits, break it down for simulation
% 
% Output:
%         Orbit.multiorbit.sc.h,              sc altitude,        [crosstrack,alongtrack]
%         Orbit.multiorbit.sc.lat,            sc latitude,        [crosstrack,alongtrack]
%         Orbit.multiorbit.sc.lon,            sc longitude,       [crosstrack,alongtrack]
%         Orbit.multiorbit.sc.az,             sc azimuth,         [crosstrack,alongtrack]
%         Orbit.multiorbit.sc.time,           sc time,            [1,alongtrack]
% 
%         Orbit.multiorbit.scan.scantilt,     scan tilt,          [crosstrack,alongtrack]
%         Orbit.multiorbit.scan.scanaz,       scan azimuth,       [crosstrack,alongtrack]
% 
%         Orbit.multiorbit.sc.ind_startend,   index of orbit,     [orbit start, orbit end]
%         Orbit.multiorbit.norbit,            no. of orbit,       scalar
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/31/2019: original code

if Orbit.onoff==1
    switch Orbit.type
        case 'Keplerian'
            
            Orbit.multiorbit.sc.h = Orbit.sc.h;       % [crosstrack,alongtrack]
            Orbit.multiorbit.sc.lat = Orbit.sc.lat;   % [crosstrack,alongtrack]
            Orbit.multiorbit.sc.lon = Orbit.sc.lon;   % [crosstrack,alongtrack]
            Orbit.multiorbit.sc.az = Orbit.sc.az;     % [crosstrack,alongtrack]
            Orbit.multiorbit.sc.time = Orbit.sc.time; % [1,alongtrack]
            
            Orbit.multiorbit.scan.scantilt = Orbit.scan.scantilt; % [crosstrack,alongtrack]
            Orbit.multiorbit.scan.scanaz = Orbit.scan.scanaz;     % [crosstrack,alongtrack]
            
            
    end
end
