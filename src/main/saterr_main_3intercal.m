function saterr_main_3intercal
% single-sensor O-B, or multiple-sensor intercalibration
%
% Input:
%       observation and simulation
%
% Output:
%       intercalibration analysis
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting

switch Setting.step
    case {'step3_oo'}
        % comparing observation with observation
        saterr_3intercal_oo
        
    case {'step3_sd'}
        % analyzing single difference (observation-simulation, or o-b)
        saterr_3intercal_sd
        
    case {'step3_dd'}
        % analyzing double difference
        saterr_3intercal_dd
        
    otherwise
        error('Setting.step is wrong')
        
end




