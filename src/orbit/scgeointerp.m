function [sc_lat,sc_lon,sc_h] = scgeointerp(sc_lat,sc_lon,sc_h,n_cross)
% spacecraft position interpolation
%
% Input:
%       sc_lat,         sc latitude,        [1,alongtrack]
%       sc_lon,         sc latitude,        [1,alongtrack]
%       sc_h,           sc altitude,        [1,alongtrack]
%       n_cross,        crosstrack no.,     scalar (>1)
% 
% Output:
%       sc_lat,         sc latitude,        [crosstrack,alongtrack]
%       sc_lon,         sc latitude,        [crosstrack,alongtrack]
%       sc_h,           sc altitude,        [crosstrack,alongtrack]
% 
% Description:
%       The assumption is that sc positions are for the beginning and ending of one scanning
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 07/03/2019: original code

if n_cross==1
    return
end

[a,b,e] = earth_wgs84;

[x,y,z] = gd2gc(sc_lat,sc_lon,sc_h,a,e);

m = size(sc_lat);

% interpolation
hi = (1:n_cross)';
h = repmat([1,n_cross+1]',[1,m(2)]);

xe = 2*x(end)-x(end-1);
x2 = [x;[x(2:end),xe]];
ye = 2*y(end)-y(end-1);
y2 = [y;[y(2:end),ye]];
ze = 2*z(end)-z(end-1);
z2 = [z;[z(2:end),ze]];

[x2i,y2i,z2i] = interp_lin_2D_asc(hi,h,x2,y2,z2);

[sc_lat,sc_lon,sc_h] = gc2gd(x2i,y2i,z2i,a,e);
