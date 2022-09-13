function saterr_parse_scanning
% parsing scan geometry and angle
%

% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/17/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/09/2019: angular center
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: accurate calculation of angle

global Rad

% -----------------------------
% parse
% -----------------------------
switch Rad.scantype
    case 'crosstrack'
        if ~isfield(Rad.scan,'angle_center')
            error('crosstrack scanning needs to set Rad.scan.angle_res')
        end
        if ~isfield(Rad.scan,'angle_center')
            error('crosstrack scanning needs to set Rad.scan.angle_center')
        end
        n = size(Rad.scan.angle_center);
        if n~=3
            error('Size of Rad.scan.angle_center should equal 3 for cs,cc,cw')
        end
    case 'conical'
        if ~isfield(Rad.scan,'angle_center')
            error('conical scanning needs to set Rad.scan.angle_res')
        end
        if ~isfield(Rad.scan,'angle_center')
            error('conical scanning needs to set Rad.scan.angle_center')
        end
        if ~isfield(Rad.scan,'angle_tilt')
            error('conical scanning needs to set Rad.scan.angle_tilt')
        end
        n = size(Rad.scan.angle_center);
        if n~=3
            error('Size of Rad.scan.angle_center should equal 3 for cs,cc,cw')
        end
        
end

