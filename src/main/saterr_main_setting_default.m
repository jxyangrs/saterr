function saterr_main_setting_default
% default setting of error sources
%   noaa-19 amsu-a is used for testing
%
% Input:
%       setting a range of error sources, control configuration
% 
% Output:
%       customized settings
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% ================================================
%% setting
% ================================================
Setting.Rad.sensor = 'amsu-a'; 
Setting.Rad.spacecraft = 'n19'; 
Setting.pathroot_output = Path.path_saterr; 
Setting.step = 'step1';

display('Testing Intallation with noaa-19 amsu-a')