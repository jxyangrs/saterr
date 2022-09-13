% map plot of scene
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2019: original code

% -------------------------
% input
% -------------------------
if Orbit.onoff~=1
    return
end

switch Path.scheme
    case 'A'
        lat = fov_lat;
        lon = fov_lon;
        
    case 'B'
        lat = fov_lat;
        lon = fov_lon;
        
end

% -------------------------
% plot setting
% -------------------------
[clat,clon] = plot_map_coastline(1);

% -------------------------
% plot
% -------------------------

% tas of ascending
M = tas;

figure(1)
clf
set(gcf,'paperposition',[0 0 8 4]*1.2)

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'asc');
    
    title(strrep([upper(Rad.sensor), ' TA Asc Chan ',num2str(nchan)],'_',''));
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_map_tas_asc_chan',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end
close(1)

% tas of both
M = tas;

figure(1)
clf
set(gcf,'paperposition',[0 0 8 4]*1.2)

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'both');
    
    title(strrep([upper(Rad.sensor), ' TA Chan ',num2str(nchan)],'_',''));
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_map_tas_both_chan',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end
close(1)

% tas_noise
M = tas_noise;

figure(1)
clf
set(gcf,'paperposition',[0 0 8 4]*1.2)

for nchan=1: Rad.num_chan
    str_chan = num2str(nchan/1e2,'%.2f');
    str_chan = str_chan(3:4);
    
    plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'both');
    
    title(strrep([upper(Rad.sensor), ' TA Noise Chan ',num2str(nchan)],'_',''));
    
    outfile = [Rad.spacecraft,'_',upper(Rad.sensor), '_map_tas.noise_chan',str_chan,'.png'];
    print(1,'-dpng','-r150',[outpath,'/',outfile])
    clf
end
close(1)
