function saterr_imp_scanning_1fromscanset
% determining scanning geometry from the scanning settings 
%
% Input:
%       Rad.scan.angle_res,         azimuth resolution (degree),            scalar
%       Rad.scan.angle_center,      angular center for cs,cc,cw (degree),   [1,3]
%       Rad.scan.period,            period per rotation (degree),           scalar
%       Rad.scan.angle_tilt,        tilt angle wrt nadir (degree),          scalar
%
% Output:
%       --crosstrack
%       Rad.scan.cs_angscan,        scene azimuth angle (degree),           [cs crosstrack,1]
%       Rad.scan.cc_angscan,        cold-space azimuth angle (degree),   	[cc crosstrack,1]
%       Rad.scan.cw_angscan,        warm-load azimuth angle (degree),       [cw crosstrack,1]
%       Rad.scan.scantilt,          tilt angle wrt nadir (degree),          [crosstrack,1],             NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            azimuth angle (degree),                 [crosstrack,1],             NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%       --conical
%       Rad.scan.cs_angscan,        scene azimuth angle (degree),           [cs crosstrack,1]
%       Rad.scan.cc_angscan,        cold-space azimuth angle (degree),   	[cc crosstrack,1]
%       Rad.scan.cw_angscan,        warm-load azimuth angle (degree),       [cw crosstrack,1]
%       Rad.scan.scantilt,          tilt angle wrt nadir (degree),          [crosstrack,1],             NED;>0=downward,<0=upward;
%       Rad.scan.scanaz,            azimuth angle (degree),                 [crosstrack,1],             NED(clockwise);e.g.,when fiight direction is north,0=north,-90=west
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/01/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: scanning angle, azimuth, tilt
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: angle of cc and cw for reflector emission

global Rad

% -----------------------------
% implement
% -----------------------------
switch Rad.scantype
    case 'crosstrack'
        n = Rad.ind_CT_num(1);
        Rad.scan.cs_angscan = -(n-1)/2*Rad.scan.angle_res+(0:n-1)*Rad.scan.angle_res+Rad.scan.angle_center(1);
        Rad.scan.cs_angscan = Rad.scan.cs_angscan(:);
        n = Rad.ind_CT_num(2);
        Rad.scan.cc_angscan = -(n-1)/2*Rad.scan.angle_res+(0:n-1)*Rad.scan.angle_res+Rad.scan.angle_center(2);
        Rad.scan.cc_angscan = Rad.scan.cc_angscan(:);
        n = Rad.ind_CT_num(3);
        Rad.scan.cw_angscan = -(n-1)/2*Rad.scan.angle_res+(0:n-1)*Rad.scan.angle_res+Rad.scan.angle_center(3);
        Rad.scan.cw_angscan = Rad.scan.cw_angscan(:);
        
        t = ctscan2tilt(Rad.scan.cs_angscan);
        Rad.scan.scantilt = t(:);
        az = ctscan2az(Rad.scan.cs_angscan);
        Rad.scan.scanaz = az(:);
        
    case 'conical'
        n = Rad.ind_CT_num(1);
        Rad.scan.cs_angscan = -(n-1)/2*Rad.scan.angle_res+(0:n-1)*Rad.scan.angle_res+Rad.scan.angle_center(1);
        Rad.scan.cs_angscan = Rad.scan.cs_angscan(:);
        n = Rad.ind_CT_num(2);
        Rad.scan.cc_angscan = -(n-1)/2*Rad.scan.angle_res+(0:n-1)*Rad.scan.angle_res+Rad.scan.angle_center(2);
        Rad.scan.cc_angscan = Rad.scan.cc_angscan(:);
        n = Rad.ind_CT_num(3);
        Rad.scan.cw_angscan = -(n-1)/2*Rad.scan.angle_res+(0:n-1)*Rad.scan.angle_res+Rad.scan.angle_center(3);
        Rad.scan.cw_angscan = Rad.scan.cw_angscan(:);
        
        scanaz = Rad.scan.cs_angscan;
        scantilt = Rad.scan.angle_tilt*ones(size(scanaz));
        
        Rad.scan.scantilt = scantilt(:);
        Rad.scan.scanaz = scanaz(:);
        
    otherwise
        error('Rad.scantype')
end

