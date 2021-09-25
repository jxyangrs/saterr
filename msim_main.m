function msim_main(varargin)
% Microwave-radiometer SIMulator (MSIM) for diagnosing and characterizing noise and error budget 
%       The simulator can mimic a spaceborne total power radiometer w/ focus on RFIC noise and a range of error sources
%       Step1. simulating counts; Step2. converting count to antenna temperature (TA) and visualization
%
% Input:
%       Flexible setup and combination. See Examples and Program Layout for details.
%       All settings are made in scripts of "msim_set_*.m" under the directory of "./src/set/"
%
% Output:
%       count, TA, visualization
%
% Examples:
%     Step 1. simulation
%     a) simulation w/ orbital oscillation (w/ additive 1 K noise of 1/f and thermal noise, half half)
%       Setting.Rad.sensor = 'Demo_Oscillation'; % Demo_Oscillation/Demo_89GHz/MHS/Customize
%       Setting.Rad.spacecraft = ''; % optional, Metop-A
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     b) simulation w/ noise in a orbit of MHS 89 GHz (w/ additive 1 K noise of 1/f and thermal noise, half half)
%       Setting.Rad.sensor = 'Demo_89GHz'; % Demo_Oscillation/Demo_89GHz/MHS/Customize
%       Setting.Rad.spacecraft = ''; % optional, Metop-A
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     c) simulation for NOAA-19 MHS (w/ empirical noise)
%       Setting.Rad.sensor = 'MHS'; % Simple/MHS/Customize
%       Setting.Rad.spacecraft = 'Metop-A'; % optional
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     d) customize simulation w/ your own parameters. Make changes accordingly in section of Settings
%       Setting.Rad.sensor = 'Customize'; %
%       Setting.Rad.spacecraft = ''; % optional, Simple/NPP/N20/Metop-A/Metop-C
%       Setting.PathRoot = '.\demo\';
%       Setting.outfile = 'msim_1sim_test.mat';
%
%     Step 2. calibration converting count to TA
%
% Program layout:
%                                                      rootpath
%                                  _______________________|________________________________
%                                  |                                        |             |
%                              src (source code)                           data          demo
%                                  |                                        |             |
%                                  |                                   sample orbits    examples
%     _____________________________|__________________________________________________________________________________________            
%     |            |              |             |           |             |          |            |              |           |    
%    set         parse           imp           main        noise         orbit      rtm           pol          utility     others   
%     |            |              |             |           |             |          |             |             |           |
%    setup     parse setup    implement      sim/cal    generating     orbit&geo  radiative    polarization    ancillary   additional modules    
%     |                                                   noise                    transfer      related                    (e.g. IGRF)
%     |
%   (setup and make all changes in scripts in the directory)
%
% Computer environment:
%       MATLAB version 2016b or later, supporting implicit expand for arithmetic operation
%
% Version:
%       V1.0, Feb. 2020
% 
% Author:
%       Dr. John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, Feb. 2020
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

% preprocessing
close all
global Setting Rad Noise Const Orbit Oscil TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path NGranuel
Setting=[];Rad=[];Noise=[];Const=[];Orbit=[];Oscil=[];TBsrc=[];WarmLoad=[];Reflector=[];ScanBias=[];PolOffset=[];AP=[];VarDynamic=[];Prof=[];Faraday=[];Path=[];NGranuel=[];

idir = which('msim_main.m');
if ~isempty(idir)
    dir_pwd = strrep(idir,'msim_main.m','');
    cd(strrep(idir,'msim_main.m',''))
end
addpath(genpath([dir_pwd,'/src']))
addpath(genpath([dir_pwd,'/data']))

% ================================================
%% setting
% ================================================

% -----------------------------
% Input setting
% -----------------------------
% radiometer specification
Setting.Rad.sensor = 'MHS'; % Demo_Oscillation/AMSU-A/MHS/AMSR2/SMAP/ATMS/Customize
Setting.Rad.spacecraft = 'Metop-A'; % optional for Demo_Oscillation; NOAA-19 for AMSU-A/MHS; GCOM-W for AMSR2

% root path
Setting.PathRoot = 'D:/John/research/task_output/msim'; %'.\demo'; % root path of output for Step 1 and 2
% Setting.PathRoot = '/data/jyang/task_output/msim'; %'.\demo'; % root path of output for Step 1 and 2
if ~isempty(varargin)
    Opt_Granuel=varargin{1};
    NGranuel = Opt_Granuel;
end

% execute
Setting.step = 'Step2'; % Step1/Step2: Step1=simulation;Step2=calibration; Step_1a/b/c for extensive simulation

% ================================================
%% setting
% ================================================
msim_main_setting

% ================================================
%% Execute
% ================================================

switch Setting.step
    case {'Step1','Step1_a','Step1_b','Step1_c'}
        % -----------------------------
        % Step 1: simulation: produce count
        % -----------------------------
        msim_main_1sim
        
    case {'Step2','Step2_a','Step2_b'}
        % -----------------------------
        % Step 2: calibration: count to TA
        % -----------------------------
        msim_main_2cal

    otherwise
        error('Error in Setting.step')
end


