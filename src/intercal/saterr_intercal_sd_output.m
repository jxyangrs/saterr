% ========================================================
%% process and output data
% ========================================================

% ---------------------------
% statistics
% ---------------------------
[tar_std_tar_tb_sd,tar_mean_tar_tb_sd,tar_maxlike_tar_tb_sd] = stat_stdhist(Stat.BinTBSD',hist1_tar_tb_sd);

% all mean
w = bsxfun(@rdivide,day_num,sum(day_num,2)); % weight of each day
avg_tar_tb_sd = sum(bsxfun(@times,day_tar_tb_sd,w),2);
avg_tar_tb_obs = sum(bsxfun(@times,day_tar_tb_obs,w),2);
avg_tar_tb_sim = sum(bsxfun(@times,day_tar_tb_sim,w),2);

w = day_num./sum(day_num,2);
avg_tar_tb_sd_std = sqrt(sum(bsxfun(@times,day_tar_tb_sd_std.^2,w),2));

% ---------------------------
% along scan
% ---------------------------
cross_tar_tb_sd = bsxfun(@rdivide,cross_tar_tb_sd,cross_tar_num);
cross_tar_tb_obs = bsxfun(@rdivide,cross_tar_tb_obs,cross_tar_num);

% cross std
temp = bsxfun(@rdivide,cross_tar_tb_sd2,cross_tar_num);
t=temp-cross_tar_tb_sd.^2;t(t<0)=NaN;
cross_tar_tb_sd_std = sqrt(t);

% ---------------------------
% map 
% ---------------------------
map_tar_tb_sd = bsxfun(@rdivide,map_tar_tb_sd,map_tar_gridnum);

% ---------------------------
% output
% ---------------------------
day_num = single(day_num);
day_tar_tb_sd = single(day_tar_tb_sd);
day_tar_tb_obs = single(day_tar_tb_obs);
day_tar_tb_sim = single(day_tar_tb_sim);

hist1_tar_tb_sd = single(hist1_tar_tb_sd);
hist1_tar_tb_obs = single(hist1_tar_tb_obs);
hist1_tar_tb_sim = single(hist1_tar_tb_sim);
hist1landsea_tar_tb_obs = single(hist1landsea_tar_tb_obs);
hist1landsea_tar_tb_sim = single(hist1landsea_tar_tb_sim);
hist1sea_tar_tb_obs = single(hist1sea_tar_tb_obs);
hist1sea_tar_tb_sim = single(hist1sea_tar_tb_sim);

map_tar_tb_sd = single(map_tar_tb_sd);

cross_tar_tb_sd = single(cross_tar_tb_sd);
cross_tar_tb_sd_std = single(cross_tar_tb_sd_std);


outfile = [Rad.spacecraft,'_',Rad.sensor,'_intercal_sd','_',ndatestr(1,:),'_',ndatestr(end,:),'.mat'];
save([outpath,'/',outfile],...
    'ndatestr','FilterCal',...
    'avg_tar_tb_sd',...
    'avg_tar_tb_obs','avg_tar_tb_sim','avg_tar_tb_sd_std',...
    'day_num','day_tar_tb_sd','day_tar_tb_sd_std','day_tar_tb_obs','day_tar_tb_sim',...
    'hist1_tar_tb_sd','hist1_tar_tb_obs','hist1_tar_tb_sim','hist1landsea_tar_tb_obs','hist1landsea_tar_tb_sim','hist1sea_tar_tb_obs','hist1sea_tar_tb_sim',...
    'cross_tar_tb_sd','cross_tar_tb_sd_std','cross_tar_tb_obs',...
    'map_tar_tb_sd',...
    'Stat')

disp('============output===============');
disp(outfile)
