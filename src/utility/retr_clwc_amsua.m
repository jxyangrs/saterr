function [clwp_amsua,ierrret,scat] = retr_clwc_amsua(tb_obs,tsavg5,zasat)
% retrieving cloud liquid water for amsu-a
% 
% Input:
%       tb_obs,     observed TB (K),                [1,channel(15)]
%       tsavg5,     surface temperature (K),        scalar
%       zasat,      Earth incidence angle (radian), scalar
% 
% Output:
%       clwp_amsua, cloud liquid water content (g/m^2)
%       ierrret,    flag
%       scat,    	scattering
% 
% Reference:
%       algorithm is from eosdis
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/28/2020: original code

r285 = 285;
r284 = 284;
r1000 = 1000;
one = 1;
t0c = 273.15;

coszat=cos(zasat);
d0 = 8.240 - (2.622 - 1.846*coszat)*coszat;
d1 = 0.754;
d2 = -2.265;

if (tsavg5>t0c-one & tb_obs(1)<=r284 & tb_obs(2)<=r284  & tb_obs(1)>0 & tb_obs(2)>0)
    clwp_amsua= cos(zasat)*(d0 + d1*log(r285-tb_obs(1)) + d2*log(r285-tb_obs(2)));
    ierrret = 0;
    clwp_amsua=max(0,clwp_amsua);
else
    clwp_amsua = r1000;
    ierrret = 1;
end

scat=-113.2+(2.41-0.0049*tb_obs(1))*tb_obs(1) ...
    +0.454*tb_obs(2)-tb_obs(15);

scat=max(0,scat);





