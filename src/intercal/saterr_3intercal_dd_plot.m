% plotting observation-observation intercalibration
%
% Input:
%       observation-observation results
%
% Output:
%       intercalibration results
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/21/2016: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/28/2020: major refine

% ---------------------------
% plot setting
% ---------------------------
outpath = [pathout,'/dd/','2plot','/'];
if ~exist(outpath,'dir')
    mkdir(outpath)
end

% setting common strings
str_intercal_titlename = [tar_datainfo_obs.spacecraft,' ',tar_datainfo_obs.sensor,' ',ref_datainfo_obs.spacecraft,' ',ref_datainfo_obs.sensor];
str_intercal_savename = [tar_datainfo_obs.spacecraft,'_',tar_datainfo_obs.sensor,'_',ref_datainfo_obs.spacecraft,'_',ref_datainfo_obs.sensor];

str_tar_titlename = [tar_datainfo_obs.spacecraft,' ',tar_datainfo_obs.sensor];
str_tar_savename = [tar_datainfo_obs.spacecraft,'_',tar_datainfo_obs.sensor];

% ---------------------------
% map
% ---------------------------
plot_map_tb_dd

% ---------------------------
% TB dependence and regression
% ---------------------------
plot_hist2_tb_dd

% ---------------------------
% basic statistics
% ---------------------------
plot_hist1_dd

% ---------------------------
% along scan: a single figure
% ---------------------------
plot_crosstrack_dd


