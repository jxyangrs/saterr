function [sc_az,sc_scannadir,sc_scanaz,sc_lat,sc_lon,sc_h] = scfov2scaninterp_scheme2(fov_lat,fov_lon,sc_lat,sc_lon,sc_h)
% determine scanning geometry from observation
% sc_az is from geo of SC
%
% Input:
%       fov_lat,        fov latitude,       [crosstrack,alongtrack]
%       fov_lon,        fov longitude,      [crosstrack,alongtrack]
%       sc_lon,         sc latitude,        [crosstrack,alongtrack]/[1,alongtrack]
%       sc_lat,         sc latitude,        [crosstrack,alongtrack]/[1,alongtrack]
%       sc_h,           sc altitude,        [crosstrack,alongtrack]/[1,alongtrack]
%
% Output:
%       sc_az,          flight direction center az,   [crosstrack,alongtrack]
%       sc_scannadir,   scanning nadir,     [crosstrack,alongtrack]
%       sc_scanaz,      scanning azimuth,   [crosstrack,alongtrack]
%                       wrt sc_az
%       sc_lon,         sc latitude interp, [crosstrack,alongtrack],    interpolating [1,alongtrack] to [cross,alongtrack]
%       sc_lat,         sc latitude interp, [crosstrack,alongtrack],    interpolating [1,alongtrack] to [cross,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/03/2019: original code

% -----------------------------
% preprocess
% -----------------------------
n1 = size(fov_lat);
n2 = size(fov_lon);
d = n1-n2;
if sum(d(:))>0
    error('size mismatch')
end

m1 = size(sc_lat);
m2 = size(sc_lon);
m3 = size(sc_h);
d = bsxfun(@minus,m1,[m2;m3]);
if sum(d(:))>0
    error('size mismatch')
end

if n1(2)~=m1(2)
    error('size mismatch')
end

if n1(1)~=m1(1)
    s = 1;
else
    s = 0;
end

n_cross = n1(1);
n_along = n1(2);

% -----------------------------
% determine scanning azimuth and tilt
% -----------------------------
% azimuth and tilt
fov_h = zeros(size(fov_lat));

% sc position interpolation
if s
    [sc_lat,sc_lon,sc_h] = scgeointerp(sc_lat,sc_lon,sc_h,n_cross);
end

% determine sc direction and scanning
[sc_az,sc_scannadir,sc_scanaz] = scfov2scan_scheme2(fov_lat,fov_lon,fov_h,sc_lat,sc_lon,sc_h);

