function saterr_main_setting
% overall setting of sensor, spacecraft, orbit, error sources and control configuration
%   Users can customize these settings for specific error sources and configuration
%
% Input:
%       setting a range of error sources, control configuration
% 
% Output:
%       settings for subsequent simulation
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% -----------------------------
% installation
% -----------------------------
if Setting.install
    saterr_main_setting_default
end

% ================================================
%% setting
% ================================================

% -----------------------------
% Input setting
% -----------------------------

% parsing input and preprocessing
saterr_parse_input

% directory and scheme
saterr_set_path_scheme

% -----------------------------
% radiometer basics
% -----------------------------

% radiometer basic specification
saterr_set_radspc

% radiometer channel specification
saterr_set_radspc_chan

% radiometer advanced specification
saterr_set_radspc_adv

% --parsing
saterr_parse_radspc

% radiometer front-end setting
saterr_set_rad_fe

% radiometer spectral response
saterr_set_rad_sr

% receiver nonlinearity
saterr_set_nonlinear

% -----------------------------
% orbit and scanning geometry
% -----------------------------

% set scanning angle
saterr_set_scanning

% set orbit and measurement geometry
saterr_set_geoorbit

% set attitude offset
saterr_set_attitudeoffset

% -----------------------------
% radiometer noise
% -----------------------------

% additive noise
saterr_set_noiseadditive

% signal-dependent noise
saterr_set_noisesigdep

% scene temperature dependence
saterr_set_tmpdep

% rng control
saterr_set_noiserng

% PRT noise
saterr_set_noisePRT

% -----------------------------
% radiometer time-varying state change
% -----------------------------
% orbital oscillation, jump
saterr_set_oscil

% -----------------------------
% antenna pattern, target, etc.
% -----------------------------

% antenna pattern
saterr_set_antennapattern

% modes and far field TB
saterr_set_modefarfieldTB

% cross polarization
saterr_set_crosspol

% polarization angle offset
saterr_set_poloffset

% cross talk
saterr_set_crosstalk

% -----------------------------
% onboard error sources: 
% -----------------------------

% reflector emission
saterr_set_reflcemiss

% warm-load error
saterr_set_warmloaderror

% cold-space mirror
saterr_set_conic_mirrorcold

% FOV intrusion 
saterr_set_fovintrusion

% instrument intereference
saterr_set_interference

% -----------------------------
% radiative transfer
% -----------------------------
% atmospheric profile
saterr_set_profile

% Faraday rotation
saterr_set_faraday

% -----------------------------
% review
% -----------------------------
saterr_set_review

