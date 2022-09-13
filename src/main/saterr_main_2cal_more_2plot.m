function saterr_main_2cal_more_2plot
% plotting and analyzing calibration results
%
% Input:
%       count
%
% Output:
%       TA, visualization
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path


% =====================================================
% loading count, ta, tb in the date range
% =====================================================
saterr_cal_read_counttatb_more


% =====================================================
% plot simulation
% =====================================================

% -------------------------
% map scene
% -------------------------
saterr_plot_map_scene

% -------------------------
% noise
% -------------------------
% noise NEDT
saterr_cal_nedt
saterr_plot_nedt

% noise PSD
saterr_plot_noisepsd

% noise autocorr
saterr_plot_noiseacf

% noise PCA
saterr_plot_noisepca

% -------------------------
% scan dependence
% -------------------------
saterr_plot_scandep


% -------------------------
% Faraday rotation
% -------------------------
saterr_plot_faraday

close all

