function saterr_main_1sim_more_prof
% implementing simulation w/ satellite and reanalysis data
%
% Input:
%       setting, satellite, reanalysis
%
% Output:
%       TOA tb of every granule
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% ===================================================
%% simulation
% ===================================================

% -------------------------
% file infomation
% -------------------------
saterr_imp_prof_files

if ~isempty(Path.process.nsubset)
    if Path.process.nsubset(end)> size(files_prof,1)
        files_prof = files_prof(Path.process.nsubset(1):end);
    else
        files_prof = files_prof(Path.process.nsubset(1):Path.process.nsubset(end));
    end
end
ind_dayn1 = ind_dayn(Path.process.nsubset(1):Path.process.nsubset(end));

% -------------------------
% going through files
% -------------------------
for nfile=1: size(files_prof,1)
    % -------------------------
    % loading observational data
    % -------------------------
    inpath = [pathin_root,'/',Path.date.ndatestr(ind_dayn1(nfile),1:4),'/',Path.date.ndatestr(ind_dayn1(nfile),:),'/'];
    infile = files_prof(nfile).name;
    disp(infile)
    
    saterr_imp_prof_load(inpath,infile);
    
    saterr_imp_prof_ini
    
    % -------------------------
    % parsing for granuel data
    % -------------------------
    saterr_parse_granuel
    
    
    % -------------------------
    % orbital scanning geometry
    % -------------------------
    saterr_imp_scanning
    
    saterr_imp_orbitscanning
    
    saterr_imp_attitudeoffset
    
    saterr_imp_faradayangle
    
    % -------------------------
    % radiative transfer
    % -------------------------
    % target/surface
    saterr_imp_targetTB_prof
    
    % atmosphere
    saterr_imp_rtm_atm
    
    % TOA TB
    saterr_imp_TOAtb
    
    % Faraday rotation
    saterr_imp_faradaystokes
    
    % channel Stokes
    saterr_imp_band2chan
    
    % -------------------------
    % Antenna pattern weighting
    % -------------------------
    % tb of mainlobe/sidelobe/spillover
    saterr_imp_TB_mainsidespillover
    
    % far field TB
    saterr_imp_farfieldTB
    
    % =====================================================
    %% output
    % =====================================================
    saterr_imp_simioout_more_toatb
    
end
