function saterr_main_2cal
% calibration and analysis
%
% Input:
%       count
%
% Output:
%       TA, visualization
%
% Author:
%       John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu: Feb. 2020
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% ================================================
%% implementing simulation
% ================================================
disp('================================================')
disp('Calibration: from count to ta to tb')
disp('================================================')

switch Setting.step
    case {'step2'}
        % -----------------------------
        % calculation for moderate simulation
        % -----------------------------
        saterr_main_2cal_less
        
    case {'step2_a'}
        % -----------------------------
        % calculation for extensive simulation
        % step2_a
        % -----------------------------
        saterr_main_2cal_more_1cal
        
    case {'step2_b'}
        % -----------------------------
        % calculation for extensive simulation
        % step2_b
        % -----------------------------
        saterr_main_2cal_more_2plot
        
    otherwise
        error('Setting.step is wrong')
        
end

