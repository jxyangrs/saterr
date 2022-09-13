function [tac,taw,tas] = saterr_cal_ct_refl_main(tac,taw,tas,cs,cc,cw)
% correcting for main reflector emission of crosstrack radiometer
%
% Input:
%       tac,          w/ reflector emission,       [crosstrack,alongtrack,channel]
%       tac,          w/ reflector emission,       [crosstrack,alongtrack,channel]
%       tac,          w/ reflector emission,       [crosstrack,alongtrack,channel]
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
    ccm_chan = mean(cc,1);
    cwm_chan = mean(cw,1);
    
    tas_new = [];
    tac_new = [];
    taw_new = [];
    
    for nchan=1: Rad.num_chan
        % count
        cs1 = cs(:,:,nchan);
        cc1 = ccm_chan(:,:,nchan);
        cw1 = cwm_chan(:,:,nchan);
        
        % channel pol
        indpol = Rad.chanpol_ind(nchan);
        
        E1 = E(:,nchan);
        Ev = E1(1);
        Eh = E1(2);
        
        % tac
        tac1 = tac(:,:,nchan);
        theta = Rad.scan.cc_angscan;
        theta = mean(theta);
        
        dtac1 = Eh*(Trefl-tac1) + (Trefl-tac1)*(Ev-Eh)*sind(theta).^2;
        tac1 = tac1 + dtac1;
        
        % taw
        taw1 = taw(:,:,nchan);
        theta = Rad.scan.cw_angscan;
        theta = mean(theta);
        
        dtaw1 = Eh*(Trefl-tac1) + (Trefl-taw1)*(Ev-Eh)*sind(theta).^2;
        taw1 = taw1 + dtaw1;
        
        % tas
        tas1 = tas(:,:,nchan);
        theta = Rad.scan.cs_angscan;
        
        switch indpol
            case 1
                a0 = (-Trefl*Ev*(1+(1-Ev)*sin(theta).^2)) ./ ((1-Ev)*(1-Ev*sin(theta).^2));
                a1 = 1./((1-Ev)*(1-Ev*sin(theta).^2));
            case 2
                a0 = (-Trefl*Eh*(1+(1-Eh)*cos(theta).^2)) ./ ((1-Eh)*(1-Eh*cos(theta).^2));
                a1 = 1./((1-Ev)*(1-Ev*cos(theta).^2));
                
        end
        tas1 = a0 + a1.*tas1;
        
        % concanate
        tas_new(:,:,nchan) = tas1;
        tac_new(:,:,nchan) = tac1;
        taw_new(:,:,nchan) = taw1;
        
    end
    tas = tas_new;
    tac = tac_new;
    taw = taw_new;
    
end
