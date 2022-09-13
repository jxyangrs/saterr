function saterr_main_2cal_less
% calibration and analysis for moderate data
%
% Input:
%       simulation results
%
% Output:
%       calibration, visualization
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path

% =====================================================
% calibration
% =====================================================
ndatestr = datestr(datenum(Path.date.range(1),'yyyymmdd'): datenum(Path.date.range(2),'yyyymmdd')-1,'yyyymmdd');

for nday = 1: size(ndatestr,1)
    % -----------------------------
    % setting date
    % -----------------------------
    ndatestr1 = ndatestr(nday,:);
    inpath = [Path.sim.count,'/',ndatestr1(1:4),'/',ndatestr1];
    outpath = [Path.cal.output,'/',ndatestr1(1:4),'/',ndatestr1];
    
    fileID = ['sim_count_',Path.sensor.spacecraft,'.',Path.sensor.name,'*'];
    
    files = dir([inpath,'/',fileID]);
    
    % outpath
    if ~exist(outpath,'dir')
        mkdir(outpath)
    end
    
    % -----------------------------
    % read data
    % -----------------------------
    for nfile=1: size(files,1)
        infile = files(nfile).name;
        disp(infile)
        
        saterr_cal_read_count
        
        saterr_cal_para
        
        % -----------------------------
        % calibration
        % -----------------------------
        saterr_cal_count2ta
        
        saterr_cal_ta2tb
        
        saterr_cal_nedt
        
        saterr_cal_output
    end
    
end


% =====================================================
% loading count, ta, tb in the date range
% =====================================================
saterr_cal_read_counttatb_less

% =====================================================
% plot
% =====================================================

% -------------------------
% map scene
% -------------------------
saterr_plot_map_scene

% -------------------------
% noise
% -------------------------
% noise NEDT
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
% 2D colorful count, TA
% -------------------------

% scene ta noise
saterr_plot_tanoise

% scene ta
saterr_plot_ta

% scene count
saterr_plot_count


% -------------------------
% Faraday rotation
% -------------------------
saterr_plot_faraday

close all

return




