function saterr_set_scanning
% scan geometry and angle
%
% Input:
%       radiometer scanning parameters
%
% Output:
%       (radiometer scanning parameters (conical/crosstrack)
%       Rad.scan.angle_res,         azimuth resolution (degree),            scalar
%       Rad.scan.angle_center,      angular center for cs,cc,cw (degree),   [1,3]
%       Rad.scan.period,            period per rotation (degree),           scalar
%       Rad.scan.angle_tilt,        tilt angle wrt nadir (degree),          scalar
%
% Description:
%       Rad.scan.angle_res:
%           crosstrack scanning = angular resolution in scanning plane (perpendicular to alongtrack direction);
%           conical scanning    = azimuth angular resolution (parallel to alongtrack direction)
%       Rad.scan.angle_center:
%           crosstrack scanning = in scanning plane (perpendicular to alongtrack direction); 0=nadir,<0 is left,>0 is right; [-180,180]
%           conical scanning    = in horizontal plane (parallel to alongtrack direction); 0=alongtrack forward, [-180,180]
%       Rad.scan.angle_tilt:
%           conical scanning    = tilt angle to nadir; 0=nadir,[0,90]=down,[90,180]=up
%
% Examples:
%       amsr2 is conical scanning w/ setting as
%           Rad.scan.angle_res = 0.6025; % angular resolution of scan (degree)
%           Rad.scan.angle_center = [0,-135.36,154.8]; % angular center for cs,cc,cw; right-hand pointing to nadir; ,[-180,180]
%           Rad.scan.angle_tilt = 47.5; % tilt angle wrt nadir (degree); 0=nadir
%       Additionally, its scanning numbers are set in saterr_set_radspc.m as
%           Rad.name_crosstrack = {'cs','null','cw','null','cc','null'}; % cc=cold count,cw=warm-load count,cs=scene count,null=gaps between cc,cw,cs
%           Rad.num_crosstrack = [243,108,16,108,16,109]; % number of scanning positions in one rotation w.r.t. name_crosstrack; [243,108,16,108,16,108] 6-36;
%       Accordingly, amsr2 Earth scenes have azimuth angle from [-0.6025*(243-1)/2: 0.6025: 0.6025*(243-1)/2]+0, i.e., [-72.9025,72.9025] w/ 243 scan positions
%       amsr2 warmload scenes have azimuth angle from [-0.6025*(16-1)/2: 0.6025: 0.6025*(16-1)/2]+154.8, i.e., [150.2813,159.2813] w/ 16 scan positions
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/17/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2019: angular center
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: accurate calculation of angle

global Rad

% -----------------------------
% setting
% -----------------------------
switch Rad.sensor
    case 'customize'
        Rad.scan.angle_res = 1.11; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,73.6,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case {'demo'}
        Rad.scan.angle_res = 1.11; % angular resolution of scan (degree);
        Rad.scan.angle_center = [0,73.6,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'amsu-a'
        Rad.scan.angle_res = 3.333; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,83.3285,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'amsu-b'
        Rad.scan.angle_res = 1.1; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,83.3285,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'amsr-e'
        Rad.scan.angle_res = 0.6226; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,-135.36,154.8]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.angle_tilt = 47.601; % tilt angle wrt nadir (degree); [0,180]; 0=nadir,[0,90]=down,(90,180]=up
        Rad.scan.period = 60/40; % scanning period per rotation (second)
        Rad.scan.time_integ = 2.6e-3; % sampling integration time (second)

    case 'amsr2'
        Rad.scan.angle_res = 0.6226; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,-135.36,154.8]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.angle_tilt = 47; % tilt angle wrt nadir (degree); [0,180]; 0=nadir,[0,90]=down,(90,180]=up
        Rad.scan.period = 60/40; % scanning period per rotation (second)
        Rad.scan.time_integ = 2.6e-3; % sampling integration time (second); amsr2, 2.6 ms for 10-37 GHz, 1.3 ms for 89 GHz

    case 'atms'
        Rad.scan.angle_res = 1.11; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,73.6,184]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'gmi'
        Rad.scan.angle_res = 0.72; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,-79.92,79.92]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.angle_tilt = 48.5; % tilt angle wrt nadir (degree); 48.5 for 10-89, 45.3 for 166&183 [0,180]; 0=nadir,[0,90]=down,(90,180]=up
        Rad.scan.period = 60/32; % period of one spin (second)
        Rad.scan.time_integ = 0.0037; % sampling integration time (second)
        
    case 'mhs'
        Rad.scan.angle_res = 1.11; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,73.6,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'mwri'
        Rad.scan.angle_res = 1.088; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,180-5,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 60/35.3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'mwhs-2'
        Rad.scan.angle_res = 1.088; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,73.6,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'mwts-2'
        Rad.scan.angle_res = 1.1; % angular resolution of scan (degree); 49.5*2/90
        Rad.scan.angle_center = [0,73.6,180]; % angular center for cs,cc,cw; left-hand pointing to forward; nadir 0,[-180,180]
        Rad.scan.period = 8/3; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'smap'
        Rad.scan.angle_res = 1.4938; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,-135.36,154.8]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.angle_tilt = 35.4278; % tilt angle wrt nadir (degree); [0,180]; 0=nadir,[0,90]=down,(90,180]=up
        Rad.scan.period = 60/14.6; % scanning period per rotation (second)
        Rad.scan.time_integ = 0.018; % sampling integration time (second)
        
    case 'ssmi'
        Rad.scan.angle_res = 0.796; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,-135.36,154.8]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.angle_tilt = 45; % tilt angle wrt nadir (degree); [0,180]; 0=nadir,[0,90]=down,(90,180]=up
        Rad.scan.period = 60/31.6; % scanning period per rotation (second)
        Rad.scan.time_integ = 7.95e-3; % sampling integration time (second); ssm/i, 7.95 for 19-37, 3.89 for 85
        
    case 'ssmis'
        Rad.scan.angle_res = 0.8; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,253.6-180,180]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.angle_tilt = 45; % tilt angle wrt nadir (degree); [0,180]; 0=nadir,[0,90]=down,(90,180]=up
        Rad.scan.period = 60/31.9; % scanning period per rotation (second)
        Rad.scan.time_integ = 4.22e-3; % sampling integration time (second)
        
    case 'tempest-d'
        Rad.scan.angle_res = 0.9; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,180,270]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.period = 2; % scanning period per rotation (second)
        Rad.scan.time_integ = 5e-3; % sampling integration time (second)
        
    case 'tms'
        Rad.scan.angle_res = 1.5; % angular resolution of scan (degree)
        Rad.scan.angle_center = [0,120,160]; % angular center for cs,cc,cw; right-hand pointing to nadir; [-180,180]
        Rad.scan.period = 60/30; % scanning period per rotation (second)
        Rad.scan.time_integ = 1/120; % sampling integration time (second)
        
    otherwise
        error('Sensor not found')
end

% -----------------------------
% parse
% -----------------------------
saterr_parse_scanning
