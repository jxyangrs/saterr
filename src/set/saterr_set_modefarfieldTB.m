function saterr_set_modefarfieldTB
% setting radiometer mode and far-field TB sources for mainlobe, sidelobe, spillover
%
%
% Input:
%       setting 
%
% Output:
%       three modes,    nominal/maneuver/TVAC/staring/customize 
%                       Nominal=normal on-orbit operation,Maneuver=spaccraft maneuver,TVAC=Thermal Vacuum
%                       Chamber,Staring=radiometer staring,customize=user defined
%       targets of far-field
%
% Description:
%       sources of TB can be found in saterr_set_TBsource.m, saterr_set_TBsource_sidelobe.m
%       near-field emission such as reflector emission is set in saterr_set_reflcemiss.m
%       For Scheme B, AP.tbsrc.mainlobe is dependent on reanalysis data. AP.tbsrc.sidelobe and AP.tbsrc.spillover are still
%       valid
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/06/2019: add customize option
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/23/2019: Stokes
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/06/2019: external sample

global AP Setting Path TBsrc

% -------------------------
% Setting TB sources of mainlobe, sidelobe, spillover
% radiometer measurement mode:
% Nominal:      mainlobe=ocean/land,spillover=cosmic
% Maneuver:     mainlobe=cosmic,spillover=ocean/land
% TVAC:         mainlobe=Controlled Temperature,spillover=Controlled Temperature
% saterr_set_TBsource.m
% -------------------------

% tb source of mainlobe     0/constant/ocean/land/cosmic/waveform/TVAC;
% tb source of sidelobe:    customize_Table/customize_Function_Mainlobe/Same_As_Mainlobe/0;
% tb source of spillover:   0/constant/ocean/land/cosmic/waveform/TVAC;

AP.mode = 'nominal'; % nominal/maneuver/TVAC/staring/customize
switch AP.mode
    case 'nominal'
        AP.tbsrc.mainlobe = 'ocean';
        AP.tbsrc.sidelobe = 'zero'; % 'customize_SideFuncMain';
        AP.tbsrc.spillover = 'cosmic';
        
    case 'maneuver'
        AP.tbsrc.mainlobe = 'cosmic';
        AP.tbsrc.sidelobe = 'cosmic'; % customize_SideFuncMain/cosmic
        AP.tbsrc.spillover = 'ocean';
        
    case 'TVAC'
        % 0/constant/ocean/land/cosmic/waveform/linear
        % specific target setting in saterr_set_TBsource.m
        
        AP.tbsrc.mainlobe = 'constant';
        AP.tbsrc.sidelobe = 'same_as_mainlobe';
        AP.tbsrc.spillover = 'same_as_mainlobe';
        
    case 'staring'
        AP.tbsrc.mainlobe = 'constant';
        AP.tbsrc.sidelobe = 'cosmic';
        AP.tbsrc.spillover = 'cosmic';
        
    case 'customize'
        AP.tbsrc.mainlobe = 'waveform';
        AP.tbsrc.sidelobe = 'waveform';
        AP.tbsrc.spillover = 'waveform';
        
end

% -------------------------
% customize tb sidelobe setting when choosing customize_Table/customize_Function_Mainlobe
% -------------------------
switch AP.tbsrc.sidelobe
    case {'customize_table','customize_sidefuncmain','constant'}
        saterr_set_TBsource_sidelobe
    case 'zero'
        % do nothing
end

% -----------------------------
% parse
% -----------------------------

saterr_parse_farfieldTB
