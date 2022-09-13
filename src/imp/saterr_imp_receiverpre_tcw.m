function saterr_imp_receiverpre_tcw
% incidence radiance right before entering receiver feedhorn
% 
% Input:
%       cold-space and warm-load setting
% 
% Output:
%       VarDynamic.Tac_chan,        Stokes of cold-space,               [crosstrack,alongtrack,channel]
%       VarDynamic.Taw_chan,        Stokes of warm-load,                [crosstrack,alongtrack,channel]
%       VarDynamic.tc_chan,         temperature of cold-space,          [crosstrack,alongtrack,channel]
%       VarDynamic.tw_cw_chan,      temperature w/ orbital oscillation, [crosstrack,alongtrack,channel]
%       VarDynamic.tw_PRT_chan,     temperature of PRT,                 [crosstrack,alongtrack,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/31/2020: APC etc
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: reorganize

global Rad VarDynamic
% -------------------------
% noise and error budget
% -------------------------

% -------------------------
% Tac & Taw reflected off the reflector
% -------------------------
Tac_chan = [];
Taw_chan = [];

tw_cw_chan = [];
tw_PRT_chan = [];

tc_chan = [];
tw_chan = [];

for nchan = 1: Rad.num_chan
    VarDynamic.nchan = nchan;
    
    % -------------------------
    % Tc,Tw initializing
    % -------------------------
    saterr_imp_initcw

    % -------------------------
    % oscillation w/ orbit
    % -------------------------
    % warm-load oscillation
    [tw_cw_var,tw_PRT_var] = saterr_imp_oscil_PRT;
    tw_cw  = tw + tw_cw_var;
    tw_PRT = tw + tw_PRT_var;
    
    tw_cw_chan(:,:,nchan) = tw_cw;
    tw_PRT_chan(:,:,nchan) = tw_PRT;
    
    Taw(1,:,:) = tw_cw;
    Taw(2,:,:) = tw_cw;
    
    % -------------------------
    % cold-space mirror error for conical-scanning
    % -------------------------
    Tac = saterr_imp_conic_mirrorcold(Tac);

    % -------------------------
    % warm-load error
    % -------------------------
    Taw = saterr_imp_warmloaderror(Taw);

    % -------------------------
    % reflection off the reflector
    % -------------------------
    [Tac,Taw] = saterr_imp_reflc_tacw(Tac,Taw);
    indpol = Rad.chanpol_ind(nchan);
    
    Tac_chan(:,:,nchan) = squeeze(Tac(indpol,:,:));
    Taw_chan(:,:,nchan) = squeeze(Taw(indpol,:,:));
    
    tc_chan(:,:,nchan) = tc;
    tw_chan(:,:,nchan) = tw;
end

% -------------------------
% output
% -------------------------
VarDynamic.Tac_chan = Tac_chan;
VarDynamic.Taw_chan = Taw_chan;
VarDynamic.tc_chan = tc_chan;
VarDynamic.tw_cw_chan = tw_cw_chan;
VarDynamic.tw_PRT_chan = tw_PRT_chan;

