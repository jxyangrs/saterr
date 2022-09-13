% crosstrack dependence

% node
ind_node = 1; % 1=both,2=ascending,3=desending

% common setting
clear plotstr
plotstr.xlabel='Scan Position';plotstr.outpath=outpath;

% cross_tnum
figure(1)
clf
x = 1: tar_sensor.num_crosstrack;
y = cross_tar_num(:,:,ind_node);
plot(x,y)
xlabel('Scan Position')
ylabel('No.')
outfile = [str_intercal_savename,'-scan_num'];
print(1,'-dpng','-r150',[plotstr.outpath,'/',outfile,'.png'])
clf

% cross_tb_dd
x = 1: tar_sensor.num_crosstrack;
y = cross_tb_dd(:,:,ind_node);
plotstr.xlabel='';plotstr.ylabel=[' TB DD (K)'];plotstr.title=strcat('Chan. ',cellstr(num2str(tar_sensor.chanind(:))));plotstr.legend='';
plotstr.savename=[str_tar_savename,'-scan-subchan-tb_dd'];
sub_plotCrossSubChan(x,y,plotstr);

% cross_tb_dd_std
x = 1: tar_sensor.num_crosstrack;
y = cross_tb_dd_std(:,:,ind_node);
plotstr.xlabel='';plotstr.ylabel=[' TB DD STD (K)'];plotstr.title=strcat('Chan. ',cellstr(num2str(tar_sensor.chanind(:))));plotstr.legend='';
plotstr.savename=[str_tar_savename,'-scan-subchan-tb_dd_std'];
sub_plotCrossSubChan(x,y,plotstr);

% cross_tar_tb_obs
x = 1: tar_sensor.num_crosstrack;
y = cross_tar_tb_obs;
plotstr.xlabel='';plotstr.ylabel=[' TB Obs (K)'];plotstr.title=strcat('Chan. ',cellstr(num2str(tar_sensor.chanind(:))));plotstr.legend='';
plotstr.savename=[str_tar_savename,'-scan-subchan-tar_tb_obs'];
sub_plotCrossSubChan(x,y,plotstr);


