% plotting observation-observation intercalibration
%
% Input:
%       observation-observation results
%
% Output:
%       avg_tb_dd,          double difference (K),              [channel,1,node]
%       avg_tar_tb_obs,     target tb (K),                      [channel,1,node]
%       day_num,            daily data no.,                     [1,day,node]
%       day_tb_dd,          daily dd (K),                       [channel,day,node]
%       day_tar_tb_obs,     daily target tb (K),                [channel,day,node]
%       hist1_tb_dd,        histogram of dd (K),                [tb bin,channel,node]
%       hist1_tar_tb_obs,   histogram of target tb (K),         [tb bin,channel,node]
%       cross_tb_dd,        scan-dependent dd (K),              [crosstrack,channel,node]
%       cross_tar_tb_obs,   scan-dependent target tb (K),       [crosstrack,channel,node]
%       cross_tb_dd_std,    scan-dependent dd std (K),          [crosstrack,channel,node]
%       map_tb_dd,          mapped dd (K),                      [lat,lon,node]
%       
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/21/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/28/2020: major refine


% ---------------------------
% statistics
% ---------------------------
[tar_std_tb_obs,tar_mean_tb_obs,tar_maxlike_tb_obs] = stat_stdhist(Stat.BinTB(:),hist1_tar_tb_obs);

% all mean
w = bsxfun(@rdivide,day_num,sum(day_num,2)); % weight of each day
avg_tb_dd = sum(bsxfun(@times,day_tb_dd,w),2);
avg_tar_tb_obs = sum(bsxfun(@times,day_tar_tb_obs,w),2);

w = day_num./sum(day_num,2);
avg_tb_dd_std = sqrt(sum(bsxfun(@times,day_tb_dd_std.^2,w),2));

% ---------------------------
% along scan
% ---------------------------
cross_tb_dd = bsxfun(@rdivide,cross_tb_dd,cross_tar_num);
cross_tar_tb_obs = bsxfun(@rdivide,cross_tar_tb_obs,cross_tar_num);

x = bsxfun(@rdivide,cross_tb_dd2,cross_tar_num);
x = x-cross_tb_dd.^2;
x(x<0) = NaN;
cross_tb_dd_std = sqrt(x);

% ---------------------------
% map 
% ---------------------------
map_tb_dd = bsxfun(@rdivide,map_tb_dd,map_tar_gridnum);

% ---------------------------
% output
% ---------------------------
day_num = single(day_num);
day_tb_dd = single(day_tb_dd);
day_tb_dd_std = single(day_tb_dd_std);
day_tar_tb_obs = single(day_tar_tb_obs);

hist1_tb_dd = single(hist1_tb_dd);
hist1_tar_tb_obs = single(hist1_tar_tb_obs);

map_tb_dd = single(map_tb_dd);

cross_tar_tb_obs = single(cross_tar_tb_obs);
cross_tb_dd = single(cross_tb_dd);
cross_tb_dd_std = single(cross_tb_dd_std);

outfile = [tar_datainfo_obs.spacecraft,'_',tar_datainfo_obs.sensor,'_',ref_datainfo_obs.spacecraft,'_',ref_datainfo_obs.sensor,'_intercal_dd','_',ndatestr(1,:),'_',ndatestr(end,:),'.mat'];
outpath = [pathout,'/dd/','1data'];
if ~exist(outpath,'dir')
    mkdir(outpath) % create directory if not existing
end

save([outpath,'/',outfile],...
    'ndatestr','FilterCal',...
    'avg_tb_dd','avg_tar_tb_obs',...
    'day_num','day_tb_dd','day_tb_dd_std','day_tar_tb_obs',...
    'hist1_tb_dd','hist1_tar_tb_obs',...
    'cross_tb_dd','cross_tar_tb_obs','cross_tb_dd_std',...
    'map_tb_dd',...
    'Stat')

disp('============output===============');
disp(outfile)
