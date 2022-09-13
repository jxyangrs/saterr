function eia = sphere_nadir2eia(H,ascan)
% Earth incidence angle assuming a spherical Earth
%
% Input:
%         H,            satellite altitude (km)
%         ascan,        scan angle wrt nadir (degree) 
% Output:
%         eia,          Earth incidence angle (degree)
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, 03/19/2017: original code

R = 6366707.0195/1e3; % spherical radius (km)
ascan = abs(ascan/180*pi); 

sin_rho = R./(R+H);
eia = pi/2-acos(sin(ascan)./sin_rho);
eia = eia/pi*180;

