% parse advanced setting for spacecraft orbit and geometry
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/28/2019: original code

% -----------------------------
% parse
% -----------------------------
% dimension check
n1 = size(Orbit.sc.h);
n2 = size(Orbit.sc.az);
n3 = size(Orbit.sc.lat);
n4 = size(Orbit.sc.lon);

d = [n1;n2;n3]-n4;
if sum(abs(d(:)))~=0
    error('dimension mismatch')
end
