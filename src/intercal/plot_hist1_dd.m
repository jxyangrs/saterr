% plotting basic statistics

ind_node = 1;

% avg_tb_dd
figure(1)
clf
bar(avg_tb_dd(:,:,ind_node))
xlim([0, size(avg_tb_dd(:,:,ind_node),1)+1])

xlabel('Channel')
ylabel('DD (K)')
title([str_tar_titlename,' TB DD (K)']);

outfile = [str_tar_savename,'-hist1-bar_tb_dd.png'];
print(1,'-dpng','-r300',[outpath,'/',outfile])

% hist1_tar_tb_obs
figure(1)
clf
set(gcf,'paperposition',[0 0 12 8])
x = Stat.BinTB;
y = hist1_tar_tb_obs(:,:,ind_node);
plot(x,y);
xlim([100 320])
xlabel([str_tar_titlename,' TB Obs (K)']);ylabel('No.');legend(cellstr(num2str(tar_sensor.chanind(:))));legend boxoff
outfile = [str_tar_savename,'-hist1-tar_tb_obs'];
print(1,'-dpng','-r300',[outpath,'/',outfile])
