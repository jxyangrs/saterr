function [tb_sim_daily] = read_sim_filesdaily(pathin,datestr1)
% read dailly simulation data
%
% Input:
%       TarRadDataInfo
%
% Output:
%       tb_sim_daily,        simulated tb,               [crosstrack,alongtrack,channel]
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/23/2019: original code

tb_sim_daily = [];

inpath = [pathin,'/',datestr1(1:4),'/',datestr1,'/'];
files = dir([inpath,'/','*.mat']);

num = size(files,1);
if num==0
    error(['empty files: ',inpath])
end

for ifile=1: size(files,1)
    infile = files(ifile).name;
    disp(infile)
    
    load([inpath,infile],'tb_mainlobe');

    % collect
    tb_sim_daily = cat(2,tb_sim_daily,tb_mainlobe);
end


