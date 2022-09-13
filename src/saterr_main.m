function saterr_main(varargin)
% Satellite Error Representation and Realization (SatERR) for diagnosing observation error and quantifying uncertainty propagation
%       The simulator can simulate a range of error sources for spaceborne radiometers (see saterr_set_listscsensor.m)
%
% Input:
%       Specify sensors, spacecrafts, and error sources.
%       See examples and program help for details.
%       All settings are made in scripts like "saterr_set_*.m" under the directory of "./src/set/", and saterr_main_setting.m
%       under "./src/main"
%
% Output:
%       counts,TA,TB, visualization
%
% Examples:
%       command examples:
%           saterr_main('install')    % installation
%       light simulation scenario:
%           saterr_main('step1')
%           saterr_main('step1',{'20190601','20190605'})
%           saterr_main('step2')
%       heavey simulatio scenario (e.g. Linux cluster w/ many cpu cores):
%           saterr_main('step1_a',{'20190601','20190605'})
%           saterr_main('step1_b_queue',{'20190601','20190605'})
%           qsub q_step1_b
%           saterr_main('step1_b',{'20190601','20190605'},[1,5])
%           saterr_main('step1_c',{'20190601','20190605'})
%           saterr_main('step2_a')
%           saterr_main('step2_b')    
%           saterr_main('step3_oo',{'20190601','20190605'})
%           saterr_main('step3_sd')
%           saterr_main('step3_dd')
%
% Computer environment:
%       MATLAB version 2016b or later, supporting implicit expand for arithmetic operation
%
% Version:
%       V1.0, April 2022
% 
% Author:
%       The SatERR Team
%       Point of Contact: Dr. John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu
%
% References:
%       GitHub:
%       https://github.com/jxyangrs/saterr
%       User manual:
%       https://github.com/jxyangrs/saterr/blob/main/manual_saterr.pdf
%       Literature:
%       SatERR: A Community Error Inventory for Satellite Observation Error Representation and Uncertainty Quantification
% 
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/14/2022: review

% preprocessing
close all
global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path CalPara
Setting=[];Rad=[];Noise=[];Const=[];Orbit=[];TimeVarying=[];TBsrc=[];WarmLoad=[];Reflector=[];MirrorCold=[];ScanBias=[];PolOffset=[];AP=[];VarDynamic=[];Prof=[];Faraday=[];Path=[];NGranuel=[];CalPara=[];

idir = which('saterr_main.m');
if ~isempty(idir)
    dir_pwd = strrep(idir,'saterr_main.m','');
    if strcmp(dir_pwd(end),'/')
        dir_pwd = dir_pwd(1:end-1);
    elseif strcmp(dir_pwd(end),'\')
        dir_pwd = dir_pwd(1:end-1);
    end
    if strcmp(dir_pwd(end-3:end),'/src')
        dir_pwd = dir_pwd(1:end-4);
    elseif strcmp(dir_pwd(end-3:end),'\src')
        dir_pwd = dir_pwd(1:end-4);
    end
    cd(dir_pwd)
end
addpath(genpath([dir_pwd,'/src']))
addpath(genpath([dir_pwd,'/data']))
Path.path_saterr = dir_pwd;

% ================================================
%% setting input and directory
% ================================================

% -----------------------------
% Input setting
% -----------------------------
% radiometer specification
Setting.Rad.sensor = 'amsu-a'; % e.g., demo/amus-a/mhs/amsr2/atms/customize; refer to saterr_set_listscsensor.m
Setting.Rad.spacecraft = 'metop-a'; % optional; e.g., n19 for amsu-a/mhs; gcom-w for amsr2; refer to saterr_set_listscsensor.m
% root path
Setting.pathroot_output = '/data/saterr'; % root path of output. e.g. Setting.pathroot_output=dir_pwd;

% step
Setting.step = varargin{1}; % Step1/Step2: Step1=simulation;Step2=calibration; Step_1a/b/c for extensive simulation

% reading input arguments
if nargin==1
    if strcmp(varargin{1},'install') Setting.install=1; else Setting.install=0; end % checking installation
elseif nargin==2
    Setting.date_range = varargin{2};
elseif nargin==3
    Setting.date_range = varargin{2}; % date range
    Setting.nsubset = varargin{3};   % subset range for step1_b
else
    error('input arguments > 3')
end

% ================================================
%% Setting error inventory
% ================================================
saterr_main_setting

% ================================================
%% Execute
% ================================================

switch Setting.step
    case {'step1','step1_a','step1_b','step1_b_queue','step1_c','step1_d'}
        % -----------------------------
        % Step 1: simulation: produce TOA TB, count
        % -----------------------------
        saterr_main_1sim
        
    case {'step2','step2_a','step2_b'}
        % -----------------------------
        % Step 2: calibration and visualization
        % -----------------------------
        saterr_main_2cal

    case {'step3_oo','step3_sd','step3_dd'}
        % -----------------------------
        % Step 3: intercalibration
        % -----------------------------
        saterr_main_3intercal
        
    otherwise
        error('Error in Setting.step')
end


