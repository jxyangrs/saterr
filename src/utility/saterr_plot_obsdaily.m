function saterr_plot_obsdaily
% plot daily observation
%
% Input:
%       setting, radiometer and reanalysis data
%
% Output:
%       collocated profiles
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/06/2017: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/24/2017: accommodate ERA5
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/05/2019: refine

global Rad Prof Orbit Path
global landMask LatMask LonMask % land-sea mask

% =======================================================
% Input
% =======================================================
datebegin = Path.date.range{1};
dateend = Path.date.range{2};

sensor_datainfo.fileID = Path.sensor.fileID;
sensor_datainfo.sensor = Rad.sensor;
sensor_datainfo.spacecraft = Rad.spacecraft;
sensor_datainfo.level = Path.sensor.level;

% ---------------------------
% set up path
% ---------------------------
% set path of sensor data
pathin_sensor = Orbit.data.path;

% set up path of processing
pathout = [Path.cal.plot,'/','plot_obs'];


% =======================================================
% read satellite and reanalysis data and output profile files
% =======================================================
ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

for iday=1: size(ndatestr,1) % daily
    % ---------------------------
    % list daily satellite data
    % ---------------------------
    [fileinfo] = set_FileDaily(sensor_datainfo,pathin_sensor,ndatestr(iday,:));
    
    datestr1 = ndatestr(iday,:);
    
    % outpath
    outpath = [pathout,'/',datestr1(1:4),'/',datestr1(1:8)];
    if ~exist(outpath,'dir')
        mkdir(outpath) % create directory if not existing
    end
    
    % ---------------------------
    % read daily satellite data
    % ---------------------------
    [qual,tb,eia,lat,lon,time,azm,scanpos,scanangle,sc_h,sc_lat,sc_lon,len_orbit] = read_sat_filesdaily(sensor_datainfo,fileinfo);
    
    % ---------------------------
    % mark and screen out bad data
    % ---------------------------
    idx_screen = sum(qual,1)>0; % 0=good,1=bad
    [n1,n2,n3] = size(tb);
    idx = repmat(idx_screen,[1,1,n3]);
    tb(idx) = NaN;
    tb(tb==0) = NaN;
    clear idx
    
    % -------------------------
    % plot
    % -------------------------
    
    % tas of ascending
    M = tb;
    
    figure(1)
    clf
    set(gcf,'paperposition',[0 0 8 4]*1.2)
    
    for nchan=1: Rad.num_chan
        str_chan = num2str(nchan/1e2,'%.2f');
        str_chan = str_chan(3:4);
        
        plot_map_tb_ascdes(M(:,:,nchan),lat,lon,'asc');
        
        title(strrep([Rad.sensor, ' OBS TB Chan ',num2str(nchan)],'_',''));
        
        outfile = [Rad.spacecraft,'_',Rad.sensor, '_map_obs_tb_chan',str_chan,'.png'];
        print(1,'-dpng','-r150',[outpath,'/',outfile])
        clf
    end
    close(1)
    
end

