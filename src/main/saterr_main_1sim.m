function saterr_main_1sim
% forward simulation and generating TB, counts, TA
%
% Input:
%       sensor and error source settings
%
% Output:
%       TOA TB, counts
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector MirrorCold ScanBias PolOffset AP VarDynamic Prof Faraday Path

% ================================================
%% implementing simulation
% ================================================
disp('================================================')
disp('Simulating:')
disp('================================================')

switch Setting.step
    case {'step1'}
        % -----------------------------
        % moderate simulation
        % -----------------------------
        saterr_main_1sim_imp
        
    case {'step1_a','step1_b','step1_b_queue','step1_c','step1_d'}
        % -----------------------------
        % extensive simulation
        % -----------------------------
        switch Setting.step
            case 'step1_a'
                % collocating satellite FOV w/ reanalysis profiles (e.g. ERA5)
                saterr_main_1sim_more_profcollocate 
                
            case {'step1_b','step1_b_queue'}
                switch Setting.step
                    case 'step1_b_queue'
                        % writing script for qsub
                        saterr_main_1sim_more_prof_queue
                    case 'step1_b'
                        % RTM simulation
                        saterr_main_1sim_more_prof
                end
                
            case 'step1_c'
                % merging granules to orbits
                saterr_main_1sim_more_granule2orbit
                
            case 'step1_d'
                % ta to count
                saterr_main_1sim_more_count

            otherwise
                error('Setting.step is wrong')
        end
        
    otherwise
        error('Setting.step is wrong')
        
end

if Setting.install
    disp('SatERR Install Succeeded')
end