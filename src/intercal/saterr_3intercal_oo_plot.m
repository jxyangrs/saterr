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
outpath = [pathout,'/oo/','2plot','/'];
if ~exist(outpath,'dir')
    mkdir(outpath)
end

% setting common strings
str_tar_titlename = [tar_datainfo.spacecraft,' ',tar_datainfo.sensor,' ',ref_datainfo.spacecraft,' ',ref_datainfo.sensor];
str_tar_savename = [tar_datainfo.spacecraft,'_',tar_datainfo.sensor,'_',ref_datainfo.spacecraft,'_',ref_datainfo.sensor];

% ---------------------------
% map
% ---------------------------
plot_map_tb_dif

% ---------------------------
% TB dependence and regression
% ---------------------------
plot_hist2_tb_dif

% ---------------------------
% basic statistics
% ---------------------------
plot_hist1_oo

% ---------------------------
% along scan: a single figure
% ---------------------------
plot_crosstrack_oo


