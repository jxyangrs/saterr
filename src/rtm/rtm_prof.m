function [prof_pres,prof_tmp,prof_qabs] = rtm_prof
% preprocessing atmospheric profile
%
% Input:
%       Prof.atm_pres,      pressure (mb),                  [altitude(top-down),pixel]/[altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_tmp,       temperature (K),                [altitude(top-down),pixel]/[altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_q,         relative humidity (kg/kg)       [altitude(top-down),pixel]/[altitude(top-down),crosstrack,alongtrack]
%
% Output:
%       prof_pres,          pressure (mb),                  [altitude(bottom-up),pixel]/[altitude(bottom-up),crosstrack,alongtrack]
%       prof_tmp,           temperature (K),                [altitude(bottom-up),pixel]/[altitude(bottom-up),crosstrack,alongtrack]
%       prof_qabs,          absolute humidity (g/m^3)       [altitude(bottom-up),pixel]/[altitude(bottom-up),crosstrack,alongtrack]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

global Prof

% -----------------------------
% prepare atmospheric profiles
% -----------------------------
% input
prof_pres = Prof.atm_pres;
prof_tmp = Prof.atm_tmp;
prof_q = Prof.atm_q;

% conversion
% input: specific humidy (kg/kg) to absolute humidity (kg/m^3); T(K); P(Pa)
% output: absolute humidity (kg/kg/)
prof_qabs = humconvert('SH2AH',prof_q,prof_tmp,prof_pres*1e2);
prof_qabs = prof_qabs*1e3; % g/m^3

% dimension [altitude(bottom-up),pixel]
prof_pres = prof_pres(end:-1:1,:,:);
prof_tmp = prof_tmp(end:-1:1,:,:);
prof_qabs = prof_qabs(end:-1:1,:,:);

Prof = rmfield(Prof,'atm_pres');
Prof = rmfield(Prof,'atm_tmp');
Prof = rmfield(Prof,'atm_q');
