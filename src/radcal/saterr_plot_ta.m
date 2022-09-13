% 2D colorful ta

figure(1);
clf
set(gcf,'paperposition',[0 0 8 4])

M = tas;
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
    title(strrep([upper(Rad.sensor), ' TA Chan ',num2str(nchan)],'_',''))
    title(h,'(K)')
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_ta_chan_',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end
