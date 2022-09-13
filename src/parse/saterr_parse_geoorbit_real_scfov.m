% parse advanced setting for spacecraft orbit and geometry
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: original code

% -----------------------------
% parse
% -----------------------------
% dimension check
n1 = size(Orbit.sc.h);
n2 = size(Orbit.sc.lat);
n3 = size(Orbit.sc.lon);

d = [n1;n2]-n3;
if sum(abs(d(:)))~=0
    error('dimension mismatch')
end


n1 = size(Orbit.fov.lat);
n2 = size(Orbit.fov.lon);

d = n1-n2;
if sum(abs(d(:)))~=0
    error('dimension mismatch')
end