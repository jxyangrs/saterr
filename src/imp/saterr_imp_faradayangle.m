function saterr_imp_faradayangle
% Faraday rotation angle
%
% Input:
%       --spacecraft orbit scanning geometry
%       Orbit.sc.lat,               spacecraft latitude (degree),               [crosstrack,alongtrack]
%       Orbit.sc.lon,               sc longitude (degree),                      [crosstrack,alongtrack]
%       Orbit.sc.h,                 sc altitude (degree),                       [crosstrack,alongtrack]
%       Orbit.sc.az,                sc azimuth (degree),                        [crosstrack,alongtrack]
%       Orbit.sc.time,              sc time (degree),                           [1,alongtrack]
%       Orbit.scan.scantilt,        radiometer scan tilt angle (degree),        [crosstrack,alongtrack]
%       Orbit.scan.scanaz,          radiometer scan azimuth angle (degree),     [crosstrack,alongtrack]
%       Orbit.scan.roll,            spacecraft roll (degree),                   scalar
%       Orbit.scan.pitch,           spacecraft pitch (degree),                  scalar
%       Orbit.scan.yaw,             spacecraft yaw (degree),                    scalar
%       --radiometer specification
%       Rad.num_alongtrack_1orbit,  radiometer No. of alongtrack per orbit,     scalar
%       Rad.num_orbit,              No. of orbit,                               scalar
%       Rad.subband.uniq_freq,              frequency (GHz),                            [1,channel]
%       --Faraday setting
%       Faraday.iono.h,             ionosphere altitude (km),                   scalar
%       Faraday.iono.VTEC,          ionosphere altitude (km),                   scalar/[crosstrack,alongtrack]
%       Faraday.magfield.B,         magnetic field (nano Tesla),                'IGRF'/'customize'([cross-track,alongtrack]/scalar)
%       Faraday.magfield.timestep,  magnetic time step,                         'EveryOrbit'/'EveryScan'/'constantTime'
%
% Output:
%       Faraday.omega,              Faraday rotation angle (degree),            [cross-track,alongtrack,uniq-frequency]
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
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code

global Rad Orbit Faraday

% -----------------------------
% intersection with ionosphere
% -----------------------------

if Orbit.onoff==1 && Faraday.onoff==1
    % -----------------------------
    % intersection with ionosphere
    % -----------------------------
    % variables
    scantilt = Orbit.scan.scantilt;
    scanaz = Orbit.scan.scanaz;
    latsc = Orbit.sc.lat;
    lonsc = Orbit.sc.lon;
    azsc = Orbit.sc.az;
    h = Orbit.sc.h;
    roll = Orbit.sc.roll;
    pitch = Orbit.sc.pitch;
    yaw = Orbit.sc.yaw;
    
    if Orbit.attitude.onoff==1
        [n1,n2] = size(scantilt);
        % NED
        [x,y,z] = scan2ned(scanaz,scantilt);
        
        % attitude offset
        roll1 = permute(roll(:),[2,3,1]);
        pitch1 = permute(pitch(:),[2,3,1]);
        
        azr = yaw(:)+azsc(:);
        yaw1 = permute(azr,[2,3,1]);
        M = eulerrotate(roll1,pitch1,yaw1);
        
        V(1,1,:) = x(:);
        V(2,1,:) = y(:);
        V(3,1,:) = z(:);
        V = mtimes_3d3d(M,V);
        x = V(1,1,:);
        y = V(2,1,:);
        z = V(3,1,:);
        
        x = reshape(x,[n1,n2]);
        y = reshape(y,[n1,n2]);
        z = reshape(z,[n1,n2]);
    else
        [x,y,z] = scan2ned(scanaz+azsc,scantilt);
    end
    
    % footprint geometry
    [a,b,e] = earth_wgs84;
    ell(1) = a+Faraday.iono.h;
    ell(2) = b+Faraday.iono.h;
    ell(3) = sqrt(1-b^2/a^2);
    [lat,lon,eia,az,rs] = gd_linesightx_ned_ell(ell,latsc,lonsc,h,x,y,z);
    elev = 90-eia;
    rs = 1;
    [Lx,Ly,Lz] = ang2ned(az,elev,rs);
    
    % -----------------------------
    % magnetic field
    % -----------------------------
    [n1,n2] = size(lat);
    Bx = zeros(n1,n2);
    By = zeros(n1,n2);
    Bz = zeros(n1,n2);
    
    h = Faraday.iono.h*ones(n1,n2);
    
    switch Faraday.magfield.timestep
        case 'everyorbit'
            [ind1,ind2] = ind_startend_bin(Rad.num_alongtrack_1orbit*Rad.num_orbit,Rad.num_alongtrack_1orbit);
            
            for i=1: length(ind1)
                ind = ind1(i): ind2(i);
                m2 = length(ind);
                lat1 = lat(:,ind);
                lon1 = lon(:,ind);
                h1 = h(:,ind);
                time1 = mean(Orbit.sc.time(ind));
                
                [Bx1,By1,Bz1] = igrf(time1,lat1(:),lon1(:),h1(:));
                Bx(:,ind) = reshape(Bx1,[n1,m2]);
                By(:,ind) = reshape(By1,[n1,m2]);
                Bz(:,ind) = reshape(Bz1,[n1,m2]);
            end
            
        case 'everyscan'
            [ind1,ind2] = ind_startend_bin(Rad.num_alongtrack_1orbit*Rad.num_orbit,1);
            
            for i=1: length(ind1)
                ind = ind1(i): ind2(i);
                m2 = length(ind);
                lat1 = lat(:,ind);
                lon1 = lon(:,ind);
                h1 = h(:,ind);
                time1 = mean(Orbit.sc.time(ind));
                
                [Bx1,By1,Bz1] = igrf(time1,lat1(:),lon1(:),h1(:));
                Bx(:,ind) = reshape(Bx1,[n1,m2]);
                By(:,ind) = reshape(By1,[n1,m2]);
                Bz(:,ind) = reshape(Bz1,[n1,m2]);
            end
            
        case 'constanttime'
            ind1 = 1;
            ind2 = n2;
            for i=1: length(ind1)
                ind = ind1(i): ind2(i);
                m2 = length(ind);
                lat1 = lat(:,ind);
                lon1 = lon(:,ind);
                h1 = h(:,ind);
                time1 = mean(Orbit.sc.time(ind));
                
                [Bx1,By1,Bz1] = igrf(time1,lat1(:),lon1(:),h1(:));
                Bx(:,ind) = reshape(Bx1,[n1,m2]);
                By(:,ind) = reshape(By1,[n1,m2]);
                Bz(:,ind) = reshape(Bz1,[n1,m2]);
            end
    end
    
    % -----------------------------
    % Faraday rotation angle
    % -----------------------------
    L = [Lx(:),Ly(:),Lz(:)];
    B = [Bx(:),By(:),Bz(:)];
    Bp = sum(L.*B,2);
    Bp = reshape(Bp,[n1,n2]);
    
    theta = eia;
    VTEC = Faraday.iono.VTEC;
    f = [];
    f(1,1,:) = Rad.subband.uniq_freq;
    
    omega = 1.355e-5.*f.^(-2).*Bp.*VTEC.*secd(theta); % f (GHz), Bp (nano Tesla), VTEC (TECU), theta (tilt ange wrt VTEC, degree)
    
    Faraday.omega = omega;
    
end







