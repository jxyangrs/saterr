% plotting basic statistics

% avg_tar_tb_sd
figure(1)
clf
bar(avg_tar_tb_sd)
xlim([0, size(avg_tar_tb_sd,1)+1])

xlabel('Channel')
ylabel('O-B (K)')
title([str_tar_titlename,' TB O-B (K)']);

outfile = [str_tar_savename,'-hist1-bar_tb_sd.png'];
print(1,'-dpng','-r300',[outpath,'/',outfile])

% hist1_tar_tb_sd
figure(1)
clf
set(gcf,'paperposition',[0 0 12 8])
x = Stat.BinTBSD;
y = hist1_tar_tb_sd;
plot(x,y);
xlim([-10 10])
xlabel([str_tar_titlename,' TB Dif (K)']);ylabel('No.');legend(cellstr(num2str(tar_rad.chanind(:))));legend boxoff

outfile = [str_tar_savename,'-hist1-tar_tb_sd.png'];
print(1,'-dpng','-r300',[outpath,'/',outfile])

% hist1_tar_tb_obs
figure(1)
clf
set(gcf,'paperposition',[0 0 12 8])
x = Stat.BinTB;
y = hist1_tar_tb_obs;
plot(x,y);
xlim([100 320])
xlabel([str_tar_titlename,' TB Obs (K)']);ylabel('No.');legend(cellstr(num2str(tar_rad.chanind(:))));legend boxoff
outfile = [str_tar_savename,'-hist1-tar_tb_obs'];
print(1,'-dpng','-r300',[outpath,'/',outfile])
