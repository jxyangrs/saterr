function saterr_main_1sim_more_profcollocate
% collocating observation and reanalysis data and outputing collocated profiles
%
% Input:
%       setting, radiometer and reanalysis data
%
% Output:
%       collocated profiles of every granule
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

ana_datainfo.name = Prof.ana.name;
ana_datainfo.path = Prof.ana.path;
ana_datainfo.fileID = Prof.ana.fileID;

sensor_datainfo.fileID = Path.sensor.fileID;
sensor_datainfo.sensor = Rad.sensor;
sensor_datainfo.spacecraft = Rad.spacecraft;
sensor_datainfo.level = Path.sensor.level;

% ---------------------------
% set up path
% ---------------------------
% set path of sensor data
pathin_sensor = Path.sensor.path;

% set up path of processing
pathout = Path.sim.prof;

% ---------------------------
% land-ocean mask
% ---------------------------
% option for selecting landsea mask; longitude [0,360)
opt_landseamask = 1; % 1=reanalysis mask,2=fixed 1-degree mask,3=fixed 0.1-degree mask

% ---------------------------
% setting granuel
% ---------------------------
% No. of alongtrack of granule for splitting satellite data
% e.g. 100= spliting satelite data to granuels of every 100 alongtrack
num_granule_alongtrack = 100;

% ---------------------------
% setting averaging window for reanalysis data
% ---------------------------
% averaging reanalysis data horizontally
% original/averaging: original=using original grid resolution, averaging=running average
% e.g. ERA-5 has a horizontal resolution of 0.25 degree, a 5-by-5 window is doing running-average with 1.25-by-1.25 degree
avg_opt = 'original'; % original/averaging
if strcmp(avg_opt,'averaging')
    avg_win = ones(3,3); % averaging windowing
end

% ---------------------------
% setting hourly step of reanalysis data
% ---------------------------
hourstep = 3; % 1=hourly data, 3=every 3-hour, 6=every 6-hour, etc.

% ---------------------------
% setting output profile format
% ---------------------------
opt_outfile = 'mat'; % mat/binary/nc

% ---------------------------
% preprocessing
% ---------------------------
switch opt_landseamask
    case 1 % reanalysis landsea mask
        % use reanalysis landsea mask
    case 2 % fixed landsea mask of 1-by-1 degree grid (fully removing land)
        load('landMask_ORNL_1degree.mat'); % LatMask,LonMask,landMask
    case 3 % fixed landsea mask of 0.1-by-0.1 degree grid (ORNL MODIS)
        load('landMask_ORNL_0.1degree.mat'); % LatMask,LonMask,landMask
    otherwise
        error('opt_landseamask is wrong')
end
LonMask = mod(LonMask,360); % LonMask ranging [0,360)

% ---------------------------
% sign for reading reanalysis data
% ---------------------------
DateAuxOld = 'na'; % determine if opening new auxiliary file; na=initilize;

% =======================================================
% read satellite and reanalysis data and output profile files
% =======================================================

ndatestr = datestr(datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1,'yyyymmdd');

for iday=1: size(ndatestr,1) % daily
    % ---------------------------
    % list daily satellite data
    % ---------------------------
    [fileinfo] = set_FileDaily(sensor_datainfo,pathin_sensor,ndatestr(iday,:));
    if fileinfo.united_filenum == 0
        error(['Sensor data not found: ',sensor_datainfo.spacecraft,' ',sensor_datainfo.sensor])
    end
    datestr1 = ndatestr(iday,:);
    datenum1 = datenum(datestr1,'yyyymmdd');
    
    % outpath
    outpath_prof = [pathout,'/',datestr1(1:4),'/',datestr1(1:8)];
    if ~exist(outpath_prof,'dir')
        mkdir(outpath_prof) % create directory if not existing
    end
    
    % ---------------------------
    % read daily satellite data
    % ---------------------------
    [qual,tb,eia,lat,lon,time,azm,scanpos,scanangle,sc_h,sc_lat,sc_lon,len_orbit] = read_sat_filesdaily(sensor_datainfo,fileinfo);
    time_sc = time(round(end/2),:);

    % ---------------------------
    % mark and screen out bad data
    % ---------------------------
    idx_screen = sum(qual,1)>0; % 0=good,1=bad
    idx = ~idx_screen;
    [qual,tb,eia,lat,lon,time,azm,scanpos,scanangle,sc_h,sc_lat,sc_lon] = ind_filter1D(2,idx,qual,tb,eia,lat,lon,time,azm,scanpos,scanangle,sc_h,sc_lat,sc_lon);
    [n1,n2,n3] = size(tb);
    nchannel = n3;

    % ---------------------------
    % granule number
    % ---------------------------
    [ind1_granule,ind2_granule] = ind_startend_bin(n2,num_granule_alongtrack);
    ngranule = size(ind1_granule,2);
    
    % ---------------------------
    % variable setup
    % ---------------------------
    tb_org = tb;
    lat_org = lat;
    lon_org = lon;
    time_org = time;
    qual_org = qual;
    eia_org = eia;
    scanpos_org = scanpos;
    azm_org = azm;
    scanangle_org = scanangle;
    sc_h_org = sc_h;
    sc_lat_org = sc_lat;
    sc_lon_org = sc_lon;
    
    % ---------------------------
    % go through granule: real granule, or splitting daily file into granules
    % ---------------------------
    for igranule=1: ngranule
        if ngranule>1
            disp(['Granule = ',num2str(igranule)])
        end
        % index
        ind = ind1_granule(igranule): ind2_granule(igranule);
        
        % reshape to 2D
        tb = tb_org(:,ind,:);
        lat = lat_org(:,ind);
        lon = lon_org(:,ind);
        time = time_org(:,ind);
        scanpos = scanpos_org(:,ind);
        qual = qual_org(:,ind);
        eia = eia_org(:,ind,:);
        azm = azm_org(:,ind,:);
        scanangle = scanangle_org(:,ind,:);
        sc_h = sc_h_org(:,ind);
        sc_lat = sc_lat_org(:,ind);
        sc_lon = sc_lon_org(:,ind);
        
        [n1,n2,n3] = size(lat);
        ncrosstrack=n1;nalongtrack=n2;
        lat = reshape(lat,[n1*n2,n3]);
        [n1,n2,n3] = size(lon);
        lon = reshape(lon,[n1*n2,n3]);
        [n1,n2,n3] = size(time);
        time = reshape(time,[n1*n2,n3]);
        [n1,n2,n3] = size(scanpos);
        scanpos = reshape(scanpos,[n1*n2,n3]);
        [n1,n2,n3] = size(qual);
        qual = reshape(qual,[n1*n2,n3]);
        
        [n1,n2,n3] = size(tb);
        tb = reshape(tb,[n1*n2,n3]);
        [n1,n2,n3] = size(eia);
        eia = reshape(eia,[n1*n2,n3]);
        [n1,n2,n3] = size(azm);
        azm = reshape(azm,[n1*n2,n3]);
        
        if size(time,1)<n1
            time = time(ones(n1,1),:);
        end
        
        % ===========================================================
        % reanalysis profile
        % ===========================================================
        
        % ---------------------------
        % locate reanalysis data
        % ---------------------------
        
        % hour step wrt reanalysis data
        t = time;
        t = t(:);
        if isempty(t)
            continue
        end
        
        % find the closest reanalysis file of every hourstep-hour
        idateaux = datestr(round(mean(t)*24/hourstep)*hourstep/24,'yyyymmddHH');
        
        % limit reanalysis to end of day
        if 1
            if datenum(idateaux,'yyyymmddHH')>=datenum1+1
                idateaux = datestr(datenum1+1-hourstep/24,'yyyymmddHH');
            end
        end
        
        % ---------------------------
        % read reanalysis data and interpolate if necessary
        % ---------------------------
        if ~strcmp(DateAuxOld,idateaux) % reduce reading auxiliary file
            % ---------------------------
            % load atmospheric and surface profiles
            % ---------------------------
            [aux_latgeo,aux_longeo,aux_atm_pres_interface,...
                aux_atm_pres_level,aux_atm_tmp_level,aux_atm_q_level,aux_sfc_ws,aux_sfc_tmp_skin,aux_sfc_pres,aux_sfc_sst]=...
                prof_atmsfc(ana_datainfo,idateaux);
            
            % ---------------------------
            % horizontally moving average
            % ---------------------------
            switch avg_opt
                case 'original'
                    % do nothing
                case 'averaging'
                    w = avg_win;
                    
                    [aux_sfc_ws,aux_sfc_tmp_skin,aux_atm_tmp_level,aux_atm_q_level,aux_atm_pres_interface,aux_atm_pres_level,aux_sfc_pres] = ...
                        movingavg_edge_lr(w, aux_sfc_ws,aux_sfc_tmp_skin,aux_atm_tmp_level,aux_atm_q_level,aux_atm_pres_interface,aux_atm_pres_level,aux_sfc_pres);
            end
            
            % ---------------------------
            % mark idateaux
            % ---------------------------
            DateAuxOld = idateaux;
        end
        
        % ---------------------------
        % profile to FOV
        % ---------------------------
        % profiles to FOV
        [sfc_pres,sfc_tmp_skin,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_humspc_level] = col_prof2grid_twice(lat,mod(lon,360),...
            aux_latgeo,aux_longeo,aux_sfc_tmp_skin,aux_sfc_ws,aux_sfc_pres,... % surface
            aux_atm_pres_interface,aux_atm_pres_level,aux_atm_tmp_level,aux_atm_q_level); % atmosphere
        
        % land-sea mask to FOV
        switch opt_landseamask
            case 1
                LatMask = aux_latgeo;
                LonMask = aux_longeo;
                landMask = zeros(size(aux_sfc_sst));
                idx = isnan(aux_sfc_sst);
                landMask(idx) = 1;
            case 2
                % loaded
            case 3
                % loaded
        end
        [landseaflag] = col_prof2grid(lat,mod(lon,360),LatMask,LonMask,landMask);
        
        % ===========================================================
        % output profiles
        % ===========================================================
        
        % ---------------------------
        % profile file format: prof_*.bin
        % ---------------------------
        str_igranule = sprintf('%.4f',igranule/1e4);
        str_igranule = str_igranule(3:end);
        % date starts with _d, e.g., _d20171130, for Fortran reading date
        iminsec1 = datestr(time(1),'yyyymmdd-HHMMSS');
        iminsec1 = iminsec1(10:end);
        iminsec2 = datestr(time(end),'yyyymmdd-HHMMSS');
        iminsec2 = iminsec2(10:end);
        outfile = ['prof_',sensor_datainfo.spacecraft,'_',sensor_datainfo.sensor,'_',ana_datainfo.name,...
            '_granule_',str_igranule,'_d',datestr1,'_t',iminsec1,'_e',iminsec2,'.mat'];
        
        % ---------------------------
        % output variables
        % atm_humspc(kg/kg)
        % order of data, [lat(increase),lon(increase),altitude(increase)]
        % ---------------------------
        atm_pres_interface = atm_pres_interface/1e2; % mbar
        atm_pres_level = atm_pres_level/1e2; % mbar
        
        npixel = ncrosstrack*nalongtrack;
        nlevel = size(atm_pres_level,1);
        
        atm_pres_interface = atm_pres_interface(end:-1:1,:);
        atm_pres_level = atm_pres_level(end:-1:1,:);
        atm_tmp_level = atm_tmp_level(end:-1:1,:);
        atm_humspc_level = atm_humspc_level(end:-1:1,:);
        
        % ---------------------------
        % write profile files
        % ---------------------------
        outpath = outpath_prof;
        switch opt_outfile
            case 'mat'
                % MAT file 
                prof_write_4sim_mat(outpath,outfile,...
                    npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
                    lat,lon,eia,azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp_skin,sfc_ws,...
                    atm_pres_interface,atm_pres_level,atm_tmp_level,atm_humspc_level,landseaflag);
            case 'binary'
                % binary file
                prof_write_4sim_bin(outpath,outfile,...
                    npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
                    lat,lon,eia,azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp_skin,sfc_ws,...
                    atm_pres_interface,atm_pres_level,atm_tmp_level,atm_humspc_level,landseaflag);

            case 'nc'
                % nc file
                prof_write_4sim_nc(outpath,outfile,...
                    npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
                    lat,lon,eia,azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp_skin,sfc_ws,...
                    atm_pres_interface,atm_pres_level,atm_tmp_level,atm_humspc_level,landseaflag);
        end
        
    end
    % ---------------------------
    % write daily file info
    % ---------------------------
    outfile = ['info_daily_',sensor_datainfo.spacecraft,'_',sensor_datainfo.sensor,'_',datestr1,'.mat'];
    outpath = outpath_prof;
    prof_write_dailyinfo(outpath,outfile,len_orbit,idx_screen,time_sc);
    
end

