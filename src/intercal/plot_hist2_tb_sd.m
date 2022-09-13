% plotting hist of tb_sd

% hist2
% common plot setting
clear plotstr
plotstr.titlecolorbar='No.';plotstr.outpath=outpath;
% hist2_ttb_tbdd for each channel
chans = 1: num_chan;
for ichan= 1: length(chans)%1: TarRadSpc.numchan
    nchan = chans(ichan);
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    plotstr.xlabel = [' TB (K)'];plotstr.ylabel=['O-B (K)'];
    plotstr.title=[tar_rad.spacecraft,' Chan. ',num2str(nchan)];
    plotstr.savename=[str_tar_savename,'-hist2-tb_tbsd_chan',str_chan];
    
    if nchan<4
        plotstr.ylim = [-10,10];
    elseif 5<=nchan && nchan<14
        plotstr.ylim = [-3,3];
    elseif 14<=nchan && nchan<16
        plotstr.ylim = [-5,5];
    elseif nchan==16
        plotstr.ylim = [-10,10];
    else
        plotstr.ylim = [-5,5];
    end
    
    z = hist2_tb_tbsd(:,:,nchan,1);
    z(z<5) = 0;
    sub_plotDirectHist2DFit(Stat.Bin_Hist2_TB,Stat.Bin_Hist2_TBSD,z,plotstr)
end