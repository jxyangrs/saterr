% receiver simulation
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/13/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/31/2020: APC etc
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 01/28/2020: reorganize

% setting
n_noisesub = 1; % 1=summup,2=noise_sub_1,noise_sub_2,...;       [cross-track,along-track,(sumup,noise1,noise2,...),channel]

% variables
cc_chan = []; % [crosstrack,alongtrack,channel,set]
cw_chan = [];
cs_chan = [];
tw_chan = [];
tc_chan = [];

% execute
disp('simulation starts')
disp('================================================')

% -------------------------
% noise and error budget
% -------------------------
saterr_imp_setpreloop

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
    % setting radiometer 
    % -------------------------
    saterr_imp_setrad
    
    % -------------------------
    % oscillation w/ orbit
    % -------------------------
    % warm-load variation
    [tw_cw_var,tw_PRT_var] = saterr_imp_oscil_PRT;
    tw_cw  = tw + tw_cw_var;
    tw_PRT = tw + tw_PRT_var;
    
    % gain variation
    [G_cc_ovar,G_cw_ovar,G_cs_ovar,G_null_ovar] = saterr_imp_oscil_gain;

    % receiver variation
    [Tr_cc_ovar,Tr_cw_ovar,Tr_cs_ovar] = saterr_imp_oscil_tr;
    
    % -------------------------
    % ta initializing
    % -------------------------
    saterr_imp_ta

    % -------------------------
    % warm-load emissivity
    % -------------------------
    Taw = saterr_imp_warmloademiss(Taw);

    % -------------------------
    % polarization offset
    % -------------------------
    Tas = saterr_imp_poloffset(Tas);
    
    % -------------------------
    % reflection off the reflector
    % -------------------------
    [Tas,Tac,Taw] = saterr_imp_reflc(Tas,Tac,Taw);
    
    % -------------------------
    % scan-dependent bias
    % -------------------------
    Tas = saterr_imp_scanbias(Tas);

    % -------------------------
    % cross polarization
    % -------------------------
    [Tas] = saterr_imp_crosspol(Tas);

    % -------------------------
    % Poisson noise for shot noise
    % -------------------------
    [Tas,Tac,Taw] = saterr_imp_poisson(Tas,Tac,Taw);

    % -------------------------
    % PRT noise
    % -------------------------
    tw_PRT = saterr_imp_noisePRT(tw_PRT);
    
    % -------------------------
    % populate counts
    % -------------------------
    saterr_imp_count
    
end

disp('simulation ends')
disp('================================================')

