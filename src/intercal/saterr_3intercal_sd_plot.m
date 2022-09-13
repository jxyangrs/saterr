% plotting single-difference intercalibration
%
% Input:
%       single-difference results
%
% Output:
%       intercalibration results
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/21/2016: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/28/2020: major refine

% ---------------------------
% plot setting
% ---------------------------
outpath = [pathout,'/','2plot','/'];
if ~exist(outpath,'dir')
    mkdir(outpath)
end

% setting common strings
str_tar_titlename = [tar_rad.spacecraft,' ',tar_rad.sensor];
str_tar_savename = [tar_rad.spacecraft,'_',tar_rad.sensor];

% ---------------------------
% map
% ---------------------------
plot_map_tb_sd

% ---------------------------
% TB dependence and regression
% ---------------------------
plot_hist2_tb_sd

% ---------------------------
% basic statistics
% ---------------------------
plot_hist1_sd

% ---------------------------
% along scan: a single figure
% ---------------------------
plot_crosstrack_sd


