function [x,y,z,r] = interlos(ux,uy,uz,xn,yn,zn)
% intersection of line of sight
% 
% Input:
%       x,    normalized X/a
%       y,    Y/a
%       z,    Z/b
%       r,    range
% Output:
%       ux,   vector x
%       uy,   vector y
%       uz,   vector z
%       xn,   unit x
%       yn,   unit y
%       zn,   unit z

A = ux.^2+uy.^2+uz.^2;
B = ux.*xn+uy.*yn+uz.*zn;
d = A-((ux.*yn-uy.*xn).^2+(uy.*zn-uz.*yn).^2+(uz.*xn-ux.*zn).^2);

idx = (d>=0);
r = NaN(size(idx));
r(idx) = -(B(idx) + sqrt(d(idx)))./A(idx);
r(r<0) = NaN;

x = xn+ux.*r; 
y = yn+uy.*r;  
z = zn+uz.*r; 
