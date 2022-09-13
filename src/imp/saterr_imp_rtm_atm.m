function saterr_imp_rtm_atm
% atmospheric up-downwelling
%
% Input:
%       default or customized profiles
% 
% Output:
%       tbup,               upwell brightness temperature (K),      [crosstrack,alongtrack,uniq-frequency]
%       tbdn,               downwell brightness temperature (K),    [crosstrack,alongtrack,uniq-frequency]
%       tau,                optical depth of atmosphere (Np),       [crosstrack,alongtrack,uniq-frequency]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

global  Orbit Prof VarDynamic


% -----------------------------
% atmospheric up-downwell
% -----------------------------
if Orbit.onoff==1 && Prof.onoff==1
    
    switch Prof.type
        case Prof.default
            [tbup,tbdn,tau] = rtm_atm_updnwell_profone;
            
        case {'customize','reanalysis'}
            [tbup,tbdn,tau] = rtm_atm_updnwell_profmult;
            
    end

    VarDynamic.tbup = tbup;
    VarDynamic.tbdn = tbdn;
    VarDynamic.tau = tau;
    
end











