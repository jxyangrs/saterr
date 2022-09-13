function saterr_set_interference
% setting for interference due to onboard instrument
% an additive scan bias is applied
%
% Input:
%       setting onboard instrument intereference
%
% Output:
%       tb,      interference TB,        [crosstrack,channel]
%
% Description:
%       an additve scan-dependent bias is modelled for onboard instrument intereference
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code

global ScanBias Rad

% -----------------------------
% setting
% -----------------------------
ScanBias.interference.onoff = 0; % 0=off,1=on

if ScanBias.interference.onoff==1
    % -----------------------------
    % additve scan-dependent bias due to instrument intereference
    % tb,   additive bias (K),      [crosstrack,channel]
    % -----------------------------
    
    % example
    n1 = Rad.ind_CT_num(1);
    n2 = Rad.num_chan;
    tb = repmat(0.5*sin(2*pi/n1*(1:n1)'),[1,n2]);  % size [crosstrack,channel]
    
    % -----------------------------
    % parse
    % -----------------------------
    saterr_parse_interference
end


