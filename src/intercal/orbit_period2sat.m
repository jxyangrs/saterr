function T = orbit_period2sat(h1,epsilon1,h2,epsilon2)
% the collocation oscillation period of two LEO satellites
% When collocating two satellites, the collocated locations oscillate as a function of latitude and longitude.
% The script determines the oscillation period.
% 
% Input:
%       h,          altitude (km),                  1D
%       epsilon,    inclination angle (degree),     1D
% 
% Output:
%       T,          oscillation period (day)
% 
% Examples:
%         1) GMI to TMI
%         h1 = 403;
%         epsilon1 = [35];
%         h2 = [407];
%         epsilon2 = 65;
%         T = orbit_period2sat(h1,epsilon1,h2,epsilon2);
% 
%         2) GMI to the others, AMSR2, TMI, WindSat, F16-F18 
%         h1 =      [700 403 840 853];
%         epsilon1 = [98.2 35 98.7 98.9];
%         h2 = [407 407 407 407];
%         epsilon2 = [65 65 65 65];
%         T = orbit_period2sat(h1,epsilon1,h2,epsilon2);
% 
%         Satellite Altitude (km)   Inclination (degree)
%         AMSR2     700             98.2
%         GMI       407             65
%         TMI       403             35
%         WindSat   840             98.7
%         F16-F18   853             98.9
% 
% Reference:
%       Yang et al., Uncertainties in Radiometer Intercalibration associated with Variability in Geophysical Parameters, Journal of Geophysical Research-Atmosphere, 2016
% 
% written by John Xun Yang, University of Michigan, johnxun@umich.edu, 1/31/2016: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: refined help

h1 = h1*1e3; % km to meter
h2 = h2*1e3;
epsilon1 = epsilon1/180*pi; % degree to radian
epsilon2 = epsilon2/180*pi;

Re = 6378.137*1e3;
a1 = h1+Re;
a2 = h2+Re;
T = 360./(2*6.529*1e24*abs(a1.^(-3.5).*cos(epsilon1)-a2.^(-3.5).*cos(epsilon2)));




