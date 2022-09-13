function saterr_imp_orbitscanning
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
%     if Rad.num_orbit>1
%       Orbit.multiorbit.sc.h,              sc altitude,        [crosstrack,alongtrack]
%       Orbit.multiorbit.sc.lat,            sc latitude,        [crosstrack,alongtrack]
%       Orbit.multiorbit.sc.lon,            sc longitude,       [crosstrack,alongtrack]
%       Orbit.multiorbit.sc.az,             sc azimuth,         [crosstrack,alongtrack]
%       Orbit.multiorbit.sc.time,           sc time,            [1,alongtrack]
%       Orbit.multiorbit.scan.scantilt,     scan tilt,          [crosstrack,alongtrack]
%       Orbit.multiorbit.scan.scanaz,       scan azimuth,       [crosstrack,alongtrack]
%       Orbit.multiorbit.sc.ind_startend,   index of orbit,     [orbit start, orbit end]
%       Orbit.multiorbit.norbit,            no. of orbit,       scalar
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code

global Rad Orbit Path

% -----------------------------
% implement
% -----------------------------
if Orbit.onoff==1
    switch Orbit.type
        case 'Keplerian' 
            
            % variables
            n1 = Rad.ind_CT_num(1);
            n2 = Rad.num_alongtrack_1orbit;
            N_orbit = Rad.num_orbit;
            
            scantilt = Rad.scan.scantilt(:);
            scanaz = Rad.scan.scanaz(:);
            
            a = Orbit.kp.a;
            e = Orbit.kp.e;
            w = Orbit.kp.w;
            wa = Orbit.kp.wa;
            i = Orbit.kp.i;
            M = Orbit.kp.M;
            t1 = datenum(Path.date.ndatestr(Path.date.nday,:),'yyyymmdd');
            
            % spacecraft ground track
            [lat,lon,h,az,Torbit] = orbit_kepler(a,e,i,wa,w,M,N_orbit,n1*n2);
            lat = lat(:)';
            lon = lon(:)';
            h = h(:)';
            az = az(:)';
            
            % output
            Orbit.sc.h = reshape(h,[n1,n2*N_orbit]);       % [crosstrack,alongtrack]
            Orbit.sc.lat = reshape(lat,[n1,n2*N_orbit]);   % [crosstrack,alongtrack]
            Orbit.sc.lon = reshape(lon,[n1,n2*N_orbit]);   % [crosstrack,alongtrack]
            Orbit.sc.az = reshape(az,[n1,n2*N_orbit]);     % [crosstrack,alongtrack]
            Orbit.sc.time = t1+N_orbit*Torbit/(n2*N_orbit*24*60)*(0: n2*N_orbit-1); % [1,alongtrack]
            Orbit.scan.scantilt = scantilt(:,ones(n2*N_orbit,1)); % [crosstrack,alongtrack]
            Orbit.scan.scanaz = scanaz(:,ones(n2*N_orbit,1));     % [crosstrack,alongtrack]
            
            wa2 = wa-360/(24*60)*Torbit*N_orbit; % update wa for consecutive orbits
            Orbit.kp.wa = mod(wa2,360);
            
        case 'Real_SC'
            % variables
            latsc = Orbit.sc.lat;
            lonsc = Orbit.sc.lon;
            azsc = Orbit.sc.az;
            h = Orbit.sc.h;
            time = Orbit.sc.time;
            scantilt = Rad.scan.scantilt(:);
            scanaz = Rad.scan.scanaz(:);
            
            % transform to [crosstrack,alongtrack]
            n1 = Rad.ind_CT_num(1);
            n2 = Rad.num_alongtrack;
            
            if n1>1
                [latsc,lonsc,h] = scgeointerp(latsc,lonsc,h,n1);
            end
            
            scantilt = scantilt(:,ones(n2,1));
            scanaz = scanaz(:,ones(n2,1));
            azsc = azsc(ones(n1,1),:);
            
            % output
            Orbit.sc.lat = latsc; % [crosstrack,alongtrack]
            Orbit.sc.lon = lonsc; % [crosstrack,alongtrack]
            Orbit.sc.az = azsc; % [crosstrack,alongtrack]
            Orbit.sc.h = h; % [crosstrack,alongtrack]
            Orbit.sc.time = time; % [1,alongtrack]
            Orbit.scan.scantilt = scantilt; % [crosstrack,alongtrack]
            Orbit.scan.scanaz = scanaz; % [crosstrack,alongtrack]
            
        case {'Real_SCFOV','Real_FOV','Real_AllFromObs'}
            % using observational info; redundant coding for showing input/output
            
            % variables
            latsc = Orbit.sc.lat;
            lonsc = Orbit.sc.lon;
            azsc = Orbit.sc.az;
            h = Orbit.sc.h;
            time = Orbit.sc.time;
            scantilt = Rad.scan.scantilt;
            scanaz = Rad.scan.scanaz;
            
            % output 
            Orbit.sc.lat = latsc; % [crosstrack,alongtrack]
            Orbit.sc.lon = lonsc; % [crosstrack,alongtrack]
            Orbit.sc.az = azsc; % [crosstrack,alongtrack]
            Orbit.sc.h = h; % [crosstrack,alongtrack]
            Orbit.sc.time = time; % [1,alongtrack]
            Orbit.scan.scantilt = scantilt; % [crosstrack,alongtrack]
            Orbit.scan.scanaz = scanaz; % [crosstrack,alongtrack]
    end
    
end

saterr_parse_orbit
