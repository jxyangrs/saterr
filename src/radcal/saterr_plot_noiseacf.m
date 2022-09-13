% analyzing noise of ACF

% taw_noise
M = taw_noise;
M = reshape(M,[],Rad.num_chan);

N_ACF = 15;
corr1 = [];
for nchan=1: Rad.num_chan
    [corr1(:,nchan)] = autocorr(M(:,nchan),N_ACF);
end

figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)
for nchan=1: Rad.num_chan
    
    [n1row,n2col] = plot_subplotnum_rectangle(Rad.num_chan);
    subplot(n1row,n2col,nchan);
    
    plot(0:N_ACF,corr1(:,nchan))
    grid on
    grid minor
    
    title(['Chan ',num2str(nchan)])
end
xlabel('Lag')
ylabel('ACF')

outfile = [Rad.spacecraft,'-',upper(Rad.sensor),'_acf_taw.noise','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

% tas_noise
M = tas_noise;
M = reshape(M,[],Rad.num_chan);

N_ACF = 15;
corr1 = [];
for nchan=1: Rad.num_chan
    [corr1(:,nchan)] = autocorr(M(:,nchan),N_ACF);
end

figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)
for nchan=1: Rad.num_chan
    
    [n1row,n2col] = plot_subplotnum(Rad.num_chan);
    subplot(n1row,n2col,nchan);
    
    plot(0:N_ACF,corr1(:,nchan))
    grid on
    grid minor
    
    title(['Chan ',num2str(nchan)])
end
xlabel('Lag')
ylabel('ACF')

outfile = [Rad.spacecraft,'-',upper(Rad.sensor),'_acf_tas.noise','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

