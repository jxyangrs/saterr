function saterr_main_1sim_imp
% simulating TOA TB, counts
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path

% ===================================================
%% simulation
% ===================================================
ndatestr = datestr(datenum(Path.date.range(1),'yyyymmdd'): datenum(Path.date.range(2),'yyyymmdd')-1,'yyyymmdd');
Path.date.ndatestr = ndatestr;

for nday=1: size(Path.date.ndatestr,1)
    disp(['Date ',Path.date.ndatestr(nday,:)])
    Path.date.nday = nday;
    
    % -------------------------
    % orbital scanning geometry
    % -------------------------
    saterr_imp_scanning
    
    saterr_imp_orbitscanning
    
    for norbit=1: Rad.num_orbit
        disp(['Orbit ',num2str(norbit)])
        
        Rad.norbit = norbit;
        saterr_imp_orbitsingle
        
        saterr_imp_attitudeoffset
        
        saterr_imp_faradayangle
        
        % -------------------------
        % radiative transfer
        % -------------------------
        % target/surface
        saterr_imp_targetTB
        
        % profile
        saterr_imp_prof_read4singleorbit
        
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
        
        % -------------------------
        % receiver
        % -------------------------
        % scene
        saterr_imp_receiverpre_tas
        
        % cold and warm reference target
        saterr_imp_receiverpre_tcw
        
        % receiver
        saterr_imp_receiver
        
        % =====================================================
        %% output
        % =====================================================
        saterr_imp_simioout
        
    end
    
end