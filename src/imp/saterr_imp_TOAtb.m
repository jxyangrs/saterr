function saterr_imp_TOAtb
% top-of-atmosphere TB
%
% Input:
%       VarDynamic.tbup,               upwell brightness temperature (K),       [crosstrack,alongtrack,uniq-frequency]
%       VarDynamic.tbdn,               downwell brightness temperature (K),     [crosstrack,alongtrack,uniq-frequency]
%       VarDynamic.tau,                optical depth of atmosphere (Np),        [crosstrack,alongtrack,uniq-frequency]
%       VarDynamic.tb_mainlobe,        reference far-field TB (K),              [Stokes,crosstrack,alongtrack,uniq-frequency]
%       VarDynamic.E_mainlobe,         target/surface emissivity (K),           [Stokes,crosstrack,alongtrack,uniq-frequency]
%       Orbit.fov.eia,                 Earth incidence angle (degree),          [crosstrack,alongtrack]
%       Const.Tcosmic,                 cosmic temperature (degree),             [crosstrack,alongtrack]
% 
% Output:
%       VarDynamic.Tas,                TOA TB (under ionosphere),               [Stokes,crosstrack,alongtrack,uniq-frequency]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/01/2019: original code

global  Orbit Prof VarDynamic Const

% -----------------------------
% TOA TB
% -----------------------------
Tcosmic = Const.Tcosmic;

if Orbit.onoff==1 && Prof.onoff==1
    
    % variables
    tbup = VarDynamic.tbup;
    tbdn = VarDynamic.tbdn;
    tau = VarDynamic.tau;
    [n1,n2,n3] = size(tbup);
    tas = VarDynamic.tb_mainlobe;
    E = VarDynamic.E_mainlobe;
    
    eia = Orbit.fov.eia;
    eia = eia(:,:,ones(n3,1));
    
    Tas = [];
    
    % TOA TB
    n = size(tas);
    
    tbsfc = reshape(tas(1,:,:,:),n(2:end));
    reflc1 = 1-reshape(E(1,:,:,:),n(2:end));
    tb = rtm_toa(eia,tbsfc,reflc1,tbup,tbdn,tau,Tcosmic);
    Tas(1,:,:,:) = tb;
    
    tbsfc = reshape(tas(2,:,:,:),n(2:end));
    reflc1 = 1-reshape(E(2,:,:,:),n(2:end));
    tb = rtm_toa(eia,tbsfc,reflc1,tbup,tbdn,tau,Tcosmic);
    Tas(2,:,:,:) = tb;
    
    tbsfc = reshape(tas(3,:,:,:),n(2:end));
    reflc1 = 1-reshape(E(3,:,:,:),n(2:end));
    tb = rtm_toa(eia,tbsfc,reflc1,0,0,tau,0);
    Tas(3,:,:,:) = tb;
    
    tbsfc = reshape(tas(4,:,:,:),n(2:end));
    reflc1 = 1-reshape(E(4,:,:,:),n(2:end));
    tb = rtm_toa(eia,tbsfc,reflc1,0,0,tau,0);
    Tas(4,:,:,:) = tb;

    % output
    VarDynamic.Tas = Tas;
    
    VarDynamic = rmfield(VarDynamic,'tbup');
    VarDynamic = rmfield(VarDynamic,'tbdn');
    VarDynamic = rmfield(VarDynamic,'tau');
    VarDynamic = rmfield(VarDynamic,'tb_mainlobe');
    VarDynamic = rmfield(VarDynamic,'E_mainlobe');
end


