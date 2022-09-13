function ta_out = saterr_cal_conic_refl_main(ta_in)
% correcting for main reflector emission of conical-scanning radiometer
%
% Input:
%       ta_in,          w/ reflector emission,       [crosstrack,alongtrack,channel]
%       CalPara.
%
% Output:
%       ta_out,         w/o reflector emission,      [crosstrack,alongtrack,channel]
%
% Description:
%       ta_out = (ta_in - Trefl*emissivity)./(1-emissivity);
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code

global CalPara Rad

if CalPara.reflector.onoff ==1
    Trefl = CalPara.reflector.emission.tmp;     % scalar
    E = CalPara.reflector.emission.E;           % [Stokes,channel]
    
    ta_out = [];
    for nchan=1: Rad.num_chan
        % channel pol
        indpol = Rad.chanpol_ind(nchan);
        
        ta1 = ta_in(:,:,nchan);
        E1 = E(:,nchan);
        E1 = E1(indpol);
        ta1 = (ta1 - E1.*Trefl) ./ (1-E1);
        ta_out(:,:,nchan) = ta1;
    end
    
else
    ta_out = ta_in;
end

