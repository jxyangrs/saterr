function [lat,lon,eia,az,rs] = orbit_scan2gd_ct(scantilt,latsc,lonsc,azsc,h,roll,pitch,yaw)
% crosstrack scanning to Earth footprint
%
% Input:
%         scantilt,   scanning angle to nadir (degree), [n1,1]/[n1,n2]  down=0; left-hand
%         latsc,      spacecraft latitude (degree),     [1,n2]/[n1,n2] (n1=crosstrack,n2=alongtrack)
%         lonsc,      sc longitude (degree),            [1,n2]/[n1,n2]
%         azsc,       sc azimuth in NED (degree),       [1,n2]/[n1,n2]  north=0
%         h,          altitude (km),                    [1,n2]/[n1,n2]
%         roll,       roll (degree),                    [1,n2]/[n1,n2]/0
%         pitch,      pitch (degree),                   [1,n2]/[n1,n2]/0
%         yaw,        yaw (degree),                     [1,n2]/[n1,n2]/0
%
% Output:
%         lat,        footprint latitude (degree),      [n1,n2]
%         lon,        footprint longitude (degree),     [n1,n2]
%         eia,        earth incidence angle (degree),   [n1,n2]
%         az,         footprint azimuth to sc (degree), [n1,n2]
%         rs,         slant range (km),                 [n1,n2]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 05/19/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/04/2019: NED

% variables
if isequal(roll,0) && isequal(pitch,0) && isequal(yaw,0)
    s_att = 0;
else
    s_att = 1;
end

% transform size to [crosstrack,alongtrack]
m1 = size(latsc);
m2 = size(scantilt);
s_mat = 0;
if s_att
    d = [size(lonsc);size(azsc);size(h);size(roll);size(pitch);size(yaw)]-m1;
else
    d = [size(lonsc);size(azsc);size(h)]-m1;
end
if sum(abs(d(:)))~=0
    error('input size mismatch')
end

if m1(1)>1
    if ~isequal(m1,m2)
        error('input size mismatch')
    end
else
    if m2(2)>1
        error('input size mismatch')
    else 
        s_mat = 1;
    end
end

if s_mat==1 
    % repmat to [crosstrack,alongtrack]
    n1 = size(scantilt,1);
    n2 = size(azsc,2);
    
    scantilt = scantilt(:,ones(n2,1));
    azsc = azsc(ones(n1,1),:);
    h = h(ones(n1,1),:);
    latsc = latsc(ones(n1,1),:);
    lonsc = lonsc(ones(n1,1),:);
    
    if s_att
        % reshape to [1,1,alongtrack]
        roll = roll(ones(n1,1),:);
        pitch = pitch(ones(n1,1),:);
        yaw = yaw(ones(n1,1),:);
    end
else
    n1 = m1(1);
    n2 = m1(2);
end

% NED
if s_att
    % NED
    scanaz = ctscan2az(scantilt);
    [x,y,z] = ctscan2ned(scanaz,scantilt);
    
    % attitude offset
    roll1 = permute(roll(:),[2,3,1]);
    pitch1 = permute(pitch(:),[2,3,1]);
    
    azr = yaw(:)+azsc(:);
    yaw1 = permute(azr,[2,3,1]);
    M = eulerrotate(roll1,pitch1,yaw1);
    
    V(1,1,:) = x(:)';
    V(2,1,:) = y(:)';
    V(3,1,:) = z(:)';
    V = mtimes_3d3d(M,V);
    x = V(1,1,:);
    y = V(2,1,:);
    z = V(3,1,:);
    
    x = reshape(x,[n1,n2]);
    y = reshape(y,[n1,n2]);
    z = reshape(z,[n1,n2]);
else
    scanaz = ctscan2az(scantilt);
    [x,y,z] = ctscan2ned(scanaz+azsc,scantilt);
end

% footprint coordinate
[lat,lon,eia,az,rs] = gd_linesightx_ned(latsc,lonsc,h,x,y,z);

