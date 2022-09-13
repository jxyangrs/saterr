function saterr_main_1sim_more_prof_queue
% writing scripts for qsub
%
% Input:
%       setting, satellite, reanalysis
%
% Output:
%       q_step1_b
%       
% Description:
%       run qsub: qsub q_step1_b
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% ===================================================
% file information
% ===================================================

% -------------------------
% file infomation
% -------------------------
saterr_imp_prof_files

% ===================================================
% writing qsub file
% ===================================================

% -------------------------
% setting
% -------------------------

% setting how many CPU cores to use
ncore = 24*3;

%
njob = sum(num_filedaily);

pathcode = Path.path_saterr;
outpath = Path.path_saterr;
outfile = 'q_step1_b';

code_example = 'matlab -nodisplay -nodesktop -r "saterr_main(''step1_b'',{''20190601'',''20190603''},[Replace1 Replace2])" > log/log_Replace3.txt </dev/null &';

outpath_queue_log = [Path.path_saterr,'/','log'];
if ~exist(outpath_queue_log,'dir')
    mkdir(outpath_queue_log)
end
% -------------------------
% writing qsub file
% -------------------------
qsub_matlab_one(njob,ncore,pathcode,outpath,outfile,code_example)



