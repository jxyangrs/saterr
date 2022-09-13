function Tac = saterr_imp_conic_mirrorcold(Tac)
% implementing cold-space mirror for conical scanning radiometers
% The cold-space mirror, separated from the main reflector, can have error due to emission
%
% Input:
%       Tac,                        cold-space antenna temperature (K),         [1,channel]
%       MirrorCold.error.slope,     slope,                                      [1,channel]
%       MirrorCold.error.bias,      intercept (K),                              [1,channel]
%
% Output:
%       Tac,            w/ error,                                   [1,channel]
%
% Descriptions:
%       The error is
%               Tac' = Tac*slope + intercept
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/31/2019: original code

global MirrorCold VarDynamic Rad

switch Rad.scantype
    case 'conical'
        nchan = VarDynamic.nchan;
        
        if MirrorCold.error.onoff==1
            
            Tac(1,:,:) = Tac(1,:,:)*MirrorCold.error.slope(nchan) + MirrorCold.error.intercept(nchan);
            
            Tac(2,:,:) = Tac(2,:,:)*MirrorCold.error.slope(nchan) + MirrorCold.error.intercept(nchan);
            
        end
end