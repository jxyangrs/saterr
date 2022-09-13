function saterr_imp_receiver
% receiver internal processing
% 
% Input:
%       incoming radiance and calibration system
% 
% Output:
%       VarDynamic.tc_chan_out,     cold-space temperature,     [crosstrack,alongtrack,channel]       
%       VarDynamic.tw_chan_out,     warm-load temperature,      [crosstrack,alongtrack,channel]
%       VarDynamic.cc_chan_out,     cold-space count,       	[crosstrack,alongtrack,channel]
%       VarDynamic.cw_chan_out,     warm-load count,            [crosstrack,alongtrack,channel]
%       VarDynamic.cs_chan_out,     scene count,                [crosstrack,alongtrack,channel]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/31/2020: APC etc
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: reorganize

global Rad Noise VarDynamic AP

% -------------------------
% setting
% -------------------------
n_noisesub = 1; % 1=summup,2=noise_sub_1,noise_sub_2,...;       [cross-track,along-track,(sumup,noise1,noise2,...),channel]

% -------------------------
% variables
% -------------------------
% input
Tas_chan = VarDynamic.Tas_chan;
Tac_chan = VarDynamic.Tac_chan;
Taw_chan = VarDynamic.Taw_chan;
tc_chan = VarDynamic.tc_chan;
tw_cw_chan = VarDynamic.tw_cw_chan;
tw_PRT_chan = VarDynamic.tw_PRT_chan;

VarDynamic = rmfield(VarDynamic,'Tas_chan');
VarDynamic = rmfield(VarDynamic,'Tac_chan');
VarDynamic = rmfield(VarDynamic,'Taw_chan');
VarDynamic = rmfield(VarDynamic,'tw_cw_chan');
VarDynamic = rmfield(VarDynamic,'tw_PRT_chan');

% output
ind_startend = Rad.alongtrack_orbit_ind_startend(Rad.norbit,:);
n2 = ind_startend(2) - ind_startend(1) + 1;
n3=Rad.num_chan;

n1=Rad.ind_CT_num(2);
cc_chan_out = NaN(n1,n2,n3); % [crosstrack,alongtrack,channel,set]
tc_chan_out = NaN(1,n2,n3); 
n1=Rad.ind_CT_num(3);
cw_chan_out = NaN(n1,n2,n3);
tw_chan_out = NaN(1,n2,n3);
n1=Rad.ind_CT_num(1);
cs_chan_out = NaN(n1,n2,n3);

% -------------------------
% additive noise
% -------------------------
saterr_imp_noiseadditive

% -------------------------
% noise and error budget
% -------------------------
AP.tb.tbscene = [];
for nchan = 1: Rad.num_chan
    disp(['Channel ',num2str(nchan)])
    VarDynamic.nchan = nchan;
    % -------------------------
    % setting noise
    % -------------------------
    if Noise.addnoise.onoff==1
        noise_sumup = Noise.addnoise.noise_subset(:,:,n_noisesub,nchan); % [cross-track,along-track,(sumup,noise1,noise2,...),channel]
        noise_ts = noise_sumup;
    else
        noise_ts = 0;
    end
    
    % -------------------------
    % ta initializing
    % -------------------------
    indpol = Rad.chanpol_ind(nchan);
    taw = Taw_chan(:,:,nchan);
    tac = Tac_chan(:,:,nchan);
    tas = permute(Tas_chan(indpol,:,:,nchan),[2,3,4,1]);
    tc = tc_chan(:,:,nchan);
    tw_cw = tw_cw_chan(:,:,nchan);
    tw_PRT = tw_PRT_chan(:,:,nchan);
    
    AP.tb.tbscene(:,:,nchan) = tas;
    % -------------------------
    % orbital oscillation of receiver state
    % -------------------------
    
    % gain variation
    [G_cc_ovar,G_cw_ovar,G_cs_ovar,G_null_ovar] = saterr_imp_oscil_gain;

    % receiver variation
    [Tr_cc_ovar,Tr_cw_ovar,Tr_cs_ovar] = saterr_imp_oscil_tr;

    % -------------------------
    % shot noise
    % -------------------------
    [tas,tac,taw] = saterr_imp_poisson(tas,tac,taw);

    % -------------------------
    % PRT noise
    % -------------------------
    tw_PRT = saterr_imp_noisePRT(tw_PRT);
    
    % -------------------------
    % populate counts
    % -------------------------
    saterr_imp_count
    
end

% -------------------------
% crosstalk
% -------------------------
saterr_imp_crosstalk

% -------------------------
% output
% -------------------------
VarDynamic.tc_chan_out = tc_chan_out;
VarDynamic.tw_chan_out = tw_chan_out;
VarDynamic.cc_chan_out = cc_chan_out;
VarDynamic.cw_chan_out = cw_chan_out;
VarDynamic.cs_chan_out = cs_chan_out;
VarDynamic.tas = tas;
