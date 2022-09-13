function [tb_sim_daily] = read_data_cal_tatb_filesdaily(pathin)
% read dailly simulation data
%
% Input:
%       pathin
%
% Output:
%       tb_sim_daily,        simulated tb,               [crosstrack,alongtrack,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2019: original code

tb_sim_daily = [];

inpath = pathin;
files = dir([inpath,'/cal_tatb_','*.mat']);

num = size(files,1);
if num==0
    error(['empty files: ',inpath])
end

for ifile=1: size(files,1)
    infile = files(ifile).name;
    disp(infile)
    
    load([inpath,infile],'tbs');
    
    % collect
    tb_sim_daily = cat(2,tb_sim_daily,tbs);
end

tb_sim_daily = double(tb_sim_daily);


