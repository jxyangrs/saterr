function Tas = saterr_imp_interference(Tas)
% implementing instrument interference
%
% Input:
%       Tas,      Stokes before instrument interference,    [Stokes,crosstrack,along-track]
% 
% Output:
%       Tas,      Stokes w/ instrument interference,        [Stokes,crosstrack,along-track]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/21/2019: original code

global Rad ScanBias VarDynamic

nchan = VarDynamic.nchan;
indpol = Rad.chanpol_ind(nchan);

if ScanBias.interference.onoff==1
    
    d(1,:) = ScanBias.interference.tb(:,nchan);
    Tas(indpol,:,:) = Tas(indpol,:,:) + d;

end
