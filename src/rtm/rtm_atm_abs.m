function absatm = rtm_atm_abs(pres,tmp,qabs,freq)
% atmospheric layer absorption
% 
% Input:
%       pres,       pressure (mb),                  [altitude,pixel,frequency]
%       tmp,        temperature (K),                [altitude,pixel,frequency]
%       qabs,       absolute humidity (g/m^3),      [altitude,pixel,frequency]
% 
% Output:
%       absatm,     layer absorption (Np/km),       [altitude,pixel,frequency]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code

absgas = rtm_abs_O2(tmp,pres,qabs,freq); 
absatm = absgas;
absgas = rtm_abs_wvp(tmp,pres,qabs,freq); % input dimension [altitude,pixel,frequency]
absatm = absatm+absgas;
absgas = rtm_abs_N2(tmp,pres,freq); 
absatm = absatm+absgas;
