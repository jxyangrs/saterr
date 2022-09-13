function saterr_main_2cal_more_1cal
% calibration and analysis for extensive data
%
% Input:
%       count
%
% Output:
%       TA, visualization
%
% Author:
%       Dr. John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, Feb. 2020
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% -----------------------------
% file info
% -----------------------------
saterr_imp_file_more_count

% -----------------------------
% calibration
% -----------------------------
for iday=1: size(Path.date.ndatestr,1)
    ndatestr1 = Path.date.ndatestr(iday,:);
    
    % load daily granuel data
    ind = ind_filedaily1(iday): ind_filedaily2(iday);
    files_daily = files_simorbit(ind);
    
    for ifile=1: size(files_daily,1)
        inpath = [pathin_root,'/',ndatestr1(1:4),'/',ndatestr1,'/'];
        infile = files_daily(ifile).name;
        load([inpath,'/',infile]); % tc,tw,cc,cw,cs,lat,lon,time_sc,tb_mainlobe,tb_scene,Rad,Noise,TimeVarying,Warmload,Reflector,MirrorCold,ScanBias,PolOffset,Faraday,Path
        
        if isempty(tb_scene)
            AP.tb.tbscene = double(tb_mainlobe);
        else
            AP.tb.tbscene = double(tb_scene);
        end
        AP.tb.mainlobe = double(tb_mainlobe);
       
        % -----------------------------
        % calibration parameters setting
        % -----------------------------
        saterr_cal_para

        % -----------------------------
        % calibration
        % -----------------------------
        saterr_cal_count2ta
        
        saterr_cal_ta2tb
        
        saterr_cal_nedt
        
        saterr_cal_output_more
    end
    
end
