function tb = rtm_toa(eia,tbsfc,reflc,tbup,tbdn,tau,Tcosmic)
% compute TOA tb w/ atmosphere, surface and cosmic background
%
% Input:
%       eia,        Earth incident angle (degree)
%       tbsfc,      surface brightness temperature (K)
%       reflc,      surface reflectivity
%       tbup,       atmosphere upwell (K)
%       tbdn,       atmosphere downwell (K)
%       tau,        atmosphere optical depth (Np)
%       Tcosmic,    cosmic brightness temperature (K)
%
% Output:
%       tb,         TOA tb (K)
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2017: original code

trtot = exp(-tau.*sec(eia*pi/180));
tb = (tbsfc+reflc.*(tbdn + Tcosmic.*trtot)).*trtot + tbup;
