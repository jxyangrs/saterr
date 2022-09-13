% writing script for qsub
% 
% Input:
%       N
% 
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/11/2017: original code


% -------------------------
% setting
% -------------------------

% ----setting computing resource
njob = 150;
ncore = 24*2;
PPN = 24; % core per node, ppn
WallTime = 12; % hour

% ----setting path, code
filehead = 'q_step1_b';
code_example = 'matlab -nodisplay -nodesktop -r "saterr(''step1_b'',''20190601'',''20190603'',[Replace1 Replace2])" > log/log_1.txt </dev/null &';
outpath_queue = Setting.PathRoot;

% -------------------------
% execution 
% -------------------------
outpath_log = [outpath_queue,'/','log']; % directory of log files


nbin = ceil(njob/ncore);
[ind1,ind2] = ind_startend_bin(njob,nbin);

% header
outfile = ['bash_',fileqsub,'_',num2str(iq)];
fid = fopen([outpath_queue,outfile],'w');
fprintf(fid,'%s\n','#!/bin/bash');
fprintf(fid,'%s\n',['#PBS -l walltime=',WallTime]);
fprintf(fid,'%s\n',['#PBS -l nodes=1:ppn=',num2str(iq_numcore)]);
fprintf(fid,'%s\n','#PBS -V');
fprintf(fid,'%s\n',['cd ',CodePath]);

% each core
for ic=1: ncore
    temp_code = code_example;
    
    temp_code = strrep(temp_code,'Replace1',num2str(ind1(ic)));
    temp_code = strrep(temp_code,'Replace2',num2str(ind2(ic)));

    fprintf(fid,'%s\n',temp_code);
end

% tail
fprintf(fid,'%s\n','wait');
fprintf(fid,'%s\n','exit');
fclose(fid);




