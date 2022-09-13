function saterr_imp_receiverpre_tas
% incidence radiance going through reflector and getting to the receiver
% 
% Input:
%       VarDynamic.Tas,        [Stokes(V,H,3,4),crosstrack,alongtrack,channel]
% 
% Output:
%       VarDynamic.Tas_chan,   [Stokes(V/QV,H/QH,3,4),crosstrack,alongtrack,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/31/2020: APC etc
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: reorganize

global Rad VarDynamic AP

% -------------------------
% polarization twist angle offset
% -------------------------
saterr_imp_poloffset

% -------------------------
% Tas before entering feedhorn
% -------------------------
Tas_chan = VarDynamic.Tas;
VarDynamic = rmfield(VarDynamic,'Tas');

Tas_chan2 = NaN(size(Tas_chan));
for nchan = 1: Rad.num_chan
    VarDynamic.nchan = nchan;
    
    Tas = Tas_chan(:,:,:,nchan);

    % -------------------------
    % cross polarization
    % -------------------------
    Tas = saterr_imp_crosspol(Tas);

    % -------------------------
    % reflection through the reflector
    % -------------------------
    Tas = saterr_imp_reflc_tas(Tas);

    % -------------------------
    % spillover
    % -------------------------
    tb_spillover = AP.tb.spillover(:,:,:,nchan);
    Tas = saterr_imp_spillover(Tas,tb_spillover,nchan);

    % -------------------------
    % FOV intrusion
    % -------------------------
    Tas = saterr_imp_fovintrusion(Tas);

    % -------------------------
    % instrument intereference
    % -------------------------
    Tas = saterr_imp_interference(Tas);

    % -------------------------
    % output
    % -------------------------
    Tas_chan2(:,:,:,nchan) = Tas;
    
end

Tas_chan = Tas_chan2;
clear Tas_chan2

% -------------------------
% output
% -------------------------
VarDynamic.Tas_chan = Tas_chan;

