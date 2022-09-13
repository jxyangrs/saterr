% ========================================================
%% process and output data
% ========================================================

% ---------------------------
% statistics
% ---------------------------
[tar_std_tb_sd,tar_mean_tb_sd,tar_maxlike_tb_sd] = stat_stdhist(Stat.BinTBSD',hist1_tar_tb_dif);

% all mean
w = bsxfun(@rdivide,day_num,sum(day_num,2)); % weight of each day
avg_tar_tb_dif = sum(bsxfun(@times,day_tar_tb_dif,w),2);
avg_tar_tb_obs = sum(bsxfun(@times,day_tar_tb_obs,w),2);

w = day_num./sum(day_num,2);
avg_tar_tb_dif_std = sqrt(sum(bsxfun(@times,day_tar_tb_dif_std.^2,w),2));

% ---------------------------
% along scan
% ---------------------------
cross_tar_tb_dif = bsxfun(@rdivide,cross_tar_tb_dif,cross_tar_num);
cross_tar_tb_obs = bsxfun(@rdivide,cross_tar_tb_obs,cross_tar_num);

% cross std
temp = bsxfun(@rdivide,cross_tar_tb_dif2,cross_tar_num);
t=temp-cross_tar_tb_dif.^2;t(t<0)=NaN;
cross_tar_tb_dif_std = sqrt(t);

% ---------------------------
% map 
% ---------------------------
map_tar_tb_dif = bsxfun(@rdivide,map_tar_tb_dif,map_tar_gridnum);

% ---------------------------
% output
% ---------------------------
day_num = single(day_num);
day_tar_tb_dif = single(day_tar_tb_dif);
day_tar_tb_obs = single(day_tar_tb_obs);

hist1_tar_tb_dif = single(hist1_tar_tb_dif);
hist1_tar_tb_obs = single(hist1_tar_tb_obs);

map_tar_tb_dif = single(map_tar_tb_dif);

cross_tar_tb_dif = single(cross_tar_tb_dif);
cross_tar_tb_dif_std = single(cross_tar_tb_dif_std);


outfile = [tar_datainfo.spacecraft,'_',tar_datainfo.sensor,'_',ref_datainfo.spacecraft,'_',ref_datainfo.sensor,'_intercal_oo','_',ndatestr(1,:),'_',ndatestr(end,:),'.mat'];
outpath = [pathout,'/oo/','1data'];
if ~exist(outpath,'dir')
    mkdir(outpath) % create directory if not existing
end

save([outpath,'/',outfile],...
    'ndatestr','FilterCal',...
    'avg_tar_tb_dif',...
    'avg_tar_tb_obs','avg_tar_tb_dif_std',...
    'day_num','day_tar_tb_dif','day_tar_tb_dif_std','day_tar_tb_obs',...
    'hist1_tar_tb_dif','hist1_tar_tb_obs',...
    'cross_tar_tb_dif','cross_tar_tb_dif_std','cross_tar_tb_obs',...
    'map_tar_tb_dif',...
    'Stat')

disp('============output===============');
disp(outfile)
