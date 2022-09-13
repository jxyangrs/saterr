function absN2 = rtm_abs_N2(T,P,freq)
% absorption coefficient of Nitrogen
% dry continuum, mostly due to N2-N2, but also contributions from O2-N2 and O2-O2
% 
% Input:
%       T,      temperature (K)
%       P,      pressure (mb)
%       freq,   frequency (GHz)
% 
% Output:
%       absN2,  absorption coefficient of Nitrogen (Neper/km)
% 
% Description:
%       This code is based on the Fortran code of Rosenkranz model of version 2020
%       http://cetemps.aquila.infn.it/mwrnet/lblmrt_ns.html
%       [DOI: 10.21982/M81013 ] Line-by-line microwave radiative transfer (non-scattering)
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, johnxun@umich.edu, 01/2014: original code

absN2 = 6.4e-14*P.^2.*freq.^2*300./T*3.55;


