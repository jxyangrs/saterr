function qsub_matlab_one(njob,ncore,PathCode,outpath,outfile,code_example)
% writing one single script for qsub
% 
% Input:
%         njob,             no. of job
%         ncore,            no. of cpu core
%         njob,             no. of job
%         PathCode,         directory of EROS code
%         outpath,          output path
%         outfile,          output file
%         code_example,     code syntax
% 
% Output:
%         njob = sum(num_filedaily);
%         ncore = 24*2;
%         pathcode = Path.path_saterr;
%         outpath = Path.path_saterr;
%         outfile = 'q_step1_b';
%         code_example = 'matlab -nodisplay -nodesktop -r "saterr(''step1_b'',''20190601'',''20190603'',[Replace1 Replace2])" > log/log_1.txt </dev/null &';
%         outpath_queue = Path.pathroot;
%         qsub_matlab_one(njob,ncore,PathCode,outpath,outfile,code_example)
% 
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/11/2017: original code


% -------------------------
% setting PBSnode
% -------------------------
PPN = 24; % core per node, ppn
WallTime = 24; % hour

% -------------------------
% num_job 
% -------------------------
nnode = ceil(ncore/PPN);
[ind1,ind2] = ind_startend_binnum(njob,ncore);

% -------------------------
% write out qsub script
% -------------------------
% header
fid = fopen([outpath,'/',outfile],'w');
fprintf(fid,'%s\n','#!/bin/bash');
fprintf(fid,'%s\n',['#PBS -l walltime=',num2str(WallTime),':00:00']);
fprintf(fid,'%s\n',['#PBS -l nodes=',num2str(nnode),':ppn=',num2str(PPN)]);
fprintf(fid,'%s\n',['cd ',PathCode]);

% each core
for ic=1: ncore
    temp_code = code_example;
    
    temp_code = strrep(temp_code,'Replace1',num2str(ind1(ic)));
    temp_code = strrep(temp_code,'Replace2',num2str(ind2(ic)));
    temp_code = strrep(temp_code,'Replace3',num2str(ic));

    fprintf(fid,'%s\n',temp_code);
end

% tail
fprintf(fid,'%s\n','wait');
fprintf(fid,'%s\n','exit');
fclose(fid);
