function ascan = sphere_eia2nadir(H,eia)
% Earth incidence angle assuming a spherical Earth
%
% Input:
%         H,            satellite altitude (km)
%         eia,          EIA (degree)
% Output:
%         ascan,        scan angle wrt nadir (degree) 
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 03/19/2017: original code

R = 6366707.0195/1e3; % spherical radius (km)
sin_rho = R./(R+H);
eia = eia/180*pi;

ascan = asin(cos(pi/2-eia)*sin_rho);
ascan = ascan/pi*180;



