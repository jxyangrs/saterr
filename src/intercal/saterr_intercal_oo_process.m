% filtering for intercalibration single difference
% 
% follow-on outer-loop processing is needed

% =======================================================
%% setting
% =======================================================

% ---------------------------
% match channel
% ---------------------------
tar_tb_obs = tar_tb_obs(:,:,match_tar_chanind);
tar_eia = tar_eia(:,:,match_tar_chanind);
tar_azm = tar_azm(:,:,match_tar_chanind);

ref_tb_obs = ref_tb_obs(:,:,match_ref_chanind);
ref_eia = ref_eia(:,:,match_ref_chanind);
ref_azm = ref_azm(:,:,match_ref_chanind);

% =======================================================
%% filtering
% =======================================================
saterr_intercal_oo_filter

% =======================================================
% collocating
% =======================================================
saterr_intercal_oo_collocate

% =======================================================
% counting statistics through days
% =======================================================
saterr_intercal_oo_stats

