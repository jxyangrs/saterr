% plot count

% time series
M = cs;

figure(1);
clf
set(gcf,'paperposition',[0 0 8 4])
for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    y = (M(:,:,nchan));
    plot(y(:))
    
    xlabel('Scan Position')
    ylabel('Count')
    title(strrep([upper(Rad.sensor), ' CS Chan ',num2str(nchan)],'_',''))
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_cs_1D_chan_',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end

% 2D colorful count
figure(1);
set(gcf,'paperposition',[0 0 8 4])

M = cs;
[n1,n2,n3] = size(M);
n = n1*2;
if n<n2
    M = M(:,1:n,:);
end

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    pcolor(M(:,:,nchan))
    shading flat
    h = colorbar;
    set(gca,'DataAspectRatio',[1,1,1])
    
    xlabel('Along Track')
    ylabel('Cross Track')
    title(strrep([upper(Rad.sensor), ' CS Chan ',num2str(nchan)],'_',''))
    title(h,'(Count)')
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_cs_chan_',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end

