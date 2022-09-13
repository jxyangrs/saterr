% crosstrack dependence

% common setting
clear plotstr
plotstr.xlabel='Scan Position';plotstr.outpath=outpath;

% cross_tnum
figure(1)
clf
x = 1: tar_sensor.num_crosstrack;
y = cross_tar_num;
plot(x,y)
xlabel('Scan Position')
ylabel('No.')
outfile = [str_tar_savename,'-scan_num'];
print(1,'-dpng','-r150',[plotstr.outpath,'/',outfile,'.png'])
clf

% cross_tar_tb_dif
x = 1: tar_sensor.num_crosstrack;
y = cross_tar_tb_dif;
plotstr.xlabel='';plotstr.ylabel=[' TB Dif (K)'];plotstr.title=strcat('Chan. ',cellstr(num2str(tar_sensor.chanind(:))));plotstr.legend='';
plotstr.savename=[str_tar_savename,'-scan-subchan-tar_tb_dif'];
sub_plotCrossSubChan(x,y,plotstr);

% cross_tar_tb_dif_std
x = 1: tar_sensor.num_crosstrack;
y = cross_tar_tb_dif_std;
plotstr.xlabel='';plotstr.ylabel=[' TB SD STD (K)'];plotstr.title=strcat('Chan. ',cellstr(num2str(tar_sensor.chanind(:))));plotstr.legend='';
plotstr.savename=[str_tar_savename,'-scan-subchan-tar_tb_dif_std'];
sub_plotCrossSubChan(x,y,plotstr);

% cross_tar_tb_obs
x = 1: tar_sensor.num_crosstrack;
y = cross_tar_tb_obs;
plotstr.xlabel='';plotstr.ylabel=[' TB Obs (K)'];plotstr.title=strcat('Chan. ',cellstr(num2str(tar_sensor.chanind(:))));plotstr.legend='';
plotstr.savename=[str_tar_savename,'-scan-subchan-tar_tb_obs'];
sub_plotCrossSubChan(x,y,plotstr);


