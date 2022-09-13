function saterr_imp_orbit
% orbit geometry
%
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: direction cosine angle
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: angle of cc and cw 

global Rad

% -----------------------------
% implement
% -----------------------------
switch Rad.scantype
    case 'crosstrack'
        latc = Rad.orbit.sc_lat;
        lonc = Rad.orbit.sc_lat;
        azc = Rad.orbit.sc_lat;
        h = Rad.orbit.sc_lat;
        nadir_scan = Rad.scan;
        
        [lat,lon,eia] = orbit_scan2gd_ct(latc,lonc,azc,h,nadir_scan);
        
        Rad.orbit.fov_lat = lat;
        Rad.orbit.fov_lon = lon;
        Rad.orbit.fov_eia = eia;
        Rad.orbit.fov_lat = lat;
        
    case 'conical'
        latc = Rad.orbit.sc_lat;
        lonc = Rad.orbit.sc_lat;
        azc = Rad.orbit.sc_lat;
        h = Rad.orbit.sc_lat;
        nadir_scan = Rad.scan;
        
        
        scanpos = [221,98,13,84,13,71];
        n1 = scanpos(1);
        n2 = sum(scanpos);
        az_scan = coscan2az(n1,n2);
        az_scan = az_scan(:);
        
        nadir_scan = 45.224*ones(n1,1);
        
        [lat,lon,eia] = orbit_scan2gd_co(latc,lonc,azc,h,nadir_scan,az_scan);
        
        Rad.orbit.fov_lat = lat;
        Rad.orbit.fov_lon = lon;
        Rad.orbit.fov_eia = eia;
        Rad.orbit.fov_lat = lat;
        
    otherwise
        error('Rad.scantype')
end