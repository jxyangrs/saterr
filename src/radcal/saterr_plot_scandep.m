% scan dependence


% -------------------------
% ta
% -------------------------
figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)

M = tas;
for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    y = mean(M(:,:,nchan),2);
    [n1row,n2col] = plot_subplotnum(Rad.num_chan);
    subplot(n1row,n2col,nchan);
    
    plot(y);
    xlim([1,length(y)]);
    
    grid on
    xlabel('Scan Position')
    ylabel('TA (K)')
    title(['Chan ',num2str(nchan)])
end
outfile = [Rad.spacecraft,'_',upper(Rad.sensor),'_scandep_tas','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

% -------------------------
% tas_bias
% -------------------------
figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)

M = tas_bias;
for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    y = mean(M(:,:,nchan),2);
    [n1row,n2col] = plot_subplotnum(Rad.num_chan);
    subplot(n1row,n2col,nchan);

    plot(y);
    xlim([1,length(y)]);
    
    grid on
    xlabel('Scan Position')
    ylabel('TA Bias (K)')
    title(['Chan ',num2str(nchan)])
end
outfile = [Rad.spacecraft,'_',upper(Rad.sensor),'_scandep_tas.bias','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])

% -------------------------
% tas_noise
% -------------------------
figure(1)
clf
set(gcf,'paperposition',[0 0 8 6]*1.2)

M = tas_noise;
for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    y = mean(M(:,:,nchan),2);
    [n1row,n2col] = plot_subplotnum(Rad.num_chan);
    subplot(n1row,n2col,nchan);

    plot(y)
    xlim([1,length(y)]);
    
    grid on
    xlabel('Scan Position')
    ylabel('TA Noise (K)')
    title(['Chan ',num2str(nchan)])
end
outfile = [Rad.spacecraft,'_',upper(Rad.sensor),'_scandep_tas.noise','.png'];
print(1,'-dpng','-r150',[outpath,'/',outfile])
