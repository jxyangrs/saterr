function saterr_imp_attitudeoffset
% computing FOV geolocaiton with spacecraft attitude offset
%
% Input:
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
%
% Output:
%       Orbit.fov.lat,              fov latitude,                               [crosstrack,alongtrack]
%       Orbit.fov.lon,              fov latitude,                               [crosstrack,alongtrack]
%       Orbit.fov.eia,              fov eia (degree),                           [crosstrack,alongtrack]
%       Orbit.fov.az,               fov azimuth (degree),                       [crosstrack,alongtrack]
%       Orbit.fov.rs,               fov slant range (km),                       [crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 08/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/16/2019: case for executing attitude
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/18/2019: reorganize

global Orbit

if Orbit.onoff==1
    s = 0;
    switch Orbit.type
        case {'Keplerian','Real_SC'}
            s = 1;
        case {'Real_SCFOV','Real_FOV'}
            if Orbit.attitude.onoff==1
                s =1;
            end
    end
    
    if s==1
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
            % size
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
        ell(1) = a;
        ell(2) = b;
        ell(3) = e;
        [lat,lon,eia,az,rs] = gd_linesightx_ned_ell(ell,latsc,lonsc,h,x,y,z);
        
        Orbit.fov.lat = lat;
        Orbit.fov.lon = lon;
        Orbit.fov.eia = eia;
        Orbit.fov.az = az;
        Orbit.fov.rs = rs;
        
    end
end
