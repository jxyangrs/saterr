% plot setting
%
%   map_tar_tb_dif
%   avg_tar_tb_dif_std
%   avg_tar_tb_dif


% ---------------------------
% map
% ---------------------------

if 1
    % setting
    [clat,clon] = plot_map_coastline(1);
    
    ind_node = 1; % use both oribt for c_range for easy comparision
    c_range = avg_tar_tb_dif_std(:,1,ind_node);
    c_range = c_range*2;c_range=[-c_range,c_range];
    c_range = bsxfun(@plus, c_range, avg_tar_tb_dif(:,1,ind_node)); % [channel,upper&lower]
    
    ind_node = 1; % 1=both,2=asc,3=des
    
    % plotting
    figure(1)
    clf
    set(gcf,'paperposition',[1 1 8 4]*1.2)
    for nchan=1: size(map_tar_tb_dif,3)
        
        str_chan = num2str(nchan/1e2,'%.2f');
        str_chan = str_chan(3:4);
        z = map_tar_tb_dif(:,:,nchan,ind_node);%zmean = nanmean(z(:));z=z-zmean;
        
        plotstr.titlecolorbar='(K)';
        plotstr.title={[str_tar_titlename,' TB Dif ','Chan ',num2str(nchan)]};
        plotstr.savename=[str_tar_savename,'-map-tar_tb_dif_chan',str_chan];
        pcolor(GridLon,GridLat,z)
        shading flat
        h = colorbar;
        
        caxis(c_range(nchan,:)); % c_range1 = c_range(nchan,:);caxis(c_range1);
        colormap('jet')
        
        hold on
        plot(clon,clat,'k');
        
        title(plotstr.title);
        title(h,plotstr.titlecolorbar)
        
        plotstr.outpath = outpath;
        print(1,'-dpng','-r150',[outpath,'/',plotstr.savename,'.png'])
        clf
    end
end
