% =====================================================
% NEDT Vs window length
% =====================================================

% NEDT
figure(1)
subplot(3,1,1)
bar(NEDT_table_taw_noise(:,1))
title([upper(Rad.sensor),' Warmload NEDT'])
xlabel('Channel')
ylabel('NEDT (K)')

subplot(3,1,2)
bar(NEDT_table_tac_noise(:,1))
title([upper(Rad.sensor),' ColdSpace NEDT'])
xlabel('Channel')
ylabel('NEDT (K)')

subplot(3,1,3)
bar(NEDT_table_tas_noise(:,1))
title([upper(Rad.sensor),' Scene NEDT'])
xlabel('Channel')
ylabel('NEDT (K)')

outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_NEDT','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

% 1/f percentage
figure(2)
subplot(3,1,1)
bar(NEDT_table_taw_noise(:,2)*100)
title([upper(Rad.sensor),' Warmload 1/f Percentage'])
xlabel('Channel')
ylabel('1/f Per (%)')

subplot(3,1,2)
bar(NEDT_table_tac_noise(:,2)*100)
title([upper(Rad.sensor),' ColdSpace 1/f Percentage'])
xlabel('Channel')
ylabel('1/f Per (%)')

subplot(3,1,3)
bar(NEDT_table_tas_noise(:,2)*100)
title([upper(Rad.sensor),' Scene 1/f Percentage'])
xlabel('Channel')
ylabel('1/f Per (%)')

outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_NEDT.tasnoise','.png'];
print(2,'-dpng','-r150',[outpath,'/',outfile])

% NEDT stride
if exist('NEDT_stride_tas_total','var')
figure(3)
clf
[n1,n2] = size(NEDT_stride_tas_total);
c = colormap('lines');
h1 = plot(NEDT_stride_tas_total);
xlabel('Stride')
ylabel('NEDT (K)')
legend(strcat('Chan ',num2str((1:Rad.num_chan)')))

outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_NEDT_stride','.png'];
print(3,'-dpng','-r150',[outpath,'/',outfile])
end