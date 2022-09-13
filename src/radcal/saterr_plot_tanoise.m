% 2D colorful ta noise

figure(1);
clf
set(gcf,'paperposition',[0 0 8 4])

M = tas_noise;
[n1,n2,n3] = size(M);
n = n1*2;
if n<n2
    M = M(:,1:n,:);
end

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    M1 = M(:,:,nchan);
    pcolor(M1)
    shading flat
    h = colorbar;
    set(gca,'DataAspectRatio',[1,1,1])
    caxis([-3,3]*std(M1(:))+mean(M1(:)))
    
    xlabel('Along Track')
    ylabel('Cross Track')
    title(strrep([upper(Rad.sensor), ' Noise Chan ',num2str(nchan)],'_',''))
    title(h,'(K)')
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_tas.noise_chan_',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end