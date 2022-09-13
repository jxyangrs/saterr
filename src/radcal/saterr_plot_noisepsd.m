% analyzing PSD

% taw_noise
M = taw_noise;
M = reshape(M,[],Rad.num_chan);

psd1 = [];
for nchan=1: Rad.num_chan
    [psd1(:,nchan),f1] = pwelch(M(:,nchan));
end

figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)
for nchan=1: Rad.num_chan
    
    [n1row,n2col] = plot_subplotnum_rectangle(Rad.num_chan);
    subplot(n1row,n2col,nchan);
    
    loglog(f1,psd1(:,nchan))
    grid on
    grid minor
    
    title(['Chan ',num2str(nchan)])
    xlabel('f (Hz)')
    ylabel('PSD')
end

outfile = [Rad.spacecraft,'-',upper(Rad.sensor),'_psd_taw.noise','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

% tas_noise
M = tas_noise;
M = reshape(M,[],Rad.num_chan);

psd1 = [];
for nchan=1: Rad.num_chan
    [psd1(:,nchan),f1] = pwelch(M(:,nchan));
end

figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)
for nchan=1: Rad.num_chan
    
    [n1row,n2col] = plot_subplotnum_rectangle(Rad.num_chan);
    subplot(n1row,n2col,nchan);
    
    loglog(f1,psd1(:,nchan))
    grid on
    grid minor
    
    title(['Chan ',num2str(nchan)])
    xlabel('f (Hz)')
    ylabel('PSD')
end

outfile = [Rad.spacecraft,'-',upper(Rad.sensor),'_psd_tas.noise','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

