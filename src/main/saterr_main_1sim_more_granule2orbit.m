function saterr_main_1sim_more_granule2orbit
% merging granule data into orbital data
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

global Setting Rad Noise Const Orbit TimeVarying TBsrc WarmLoad Reflector ScanBias PolOffset AP VarDynamic Prof Faraday Path

% -------------------------
% info. of granuel files
% -------------------------
saterr_imp_prof_filessimgran

saterr_imp_prof_filessat

for nday=1: size(Path.date.ndatestr,1)
    ndatestr1 = Path.date.ndatestr(nday,:);
    
    % load daily granuel data
    ind = ind_day_simgran1(nday): ind_day_simgran2(nday);
    files_daily = files_simgran(ind);
    
    lat = [];
    lon = [];
    tb_mainlobe = [];
    tb_scene = [];
    
    disp('loading simulation data')
    for nfile=1: size(files_daily,1)
        inpath = [Path.sim.granuel,'/',ndatestr1(1:4),'/',ndatestr1,'/'];
        infile = files_daily(nfile).name;
        data = load([inpath,'/',infile]);
        disp(infile)
   
        lat = cat(2,lat,data.lat);
        lon = cat(2,lon,data.lon);
        tb_mainlobe = cat(3,tb_mainlobe,data.tb_mainlobe);
        if ~isempty(data.tb_scene)
            tb_scene = cat(3,tb_scene,data.tb_scene);
        end
    end
    
    % load daily orbital info
    inpath = [Path.sim.prof,'/',ndatestr1(1:4),'/',ndatestr1,'/'];
    fileID = ['info_daily_*',Path.sensor.spacecraft,'_',Path.sensor.name,'_',ndatestr1,'.mat'];
    fileinfo = dir([inpath,fileID]);
    infile = fileinfo.name;
    data = load([inpath,'/',infile]); % len_orbit,idx_screen,time_sc

    [ind_day_orbit1,ind_day_orbit2]= ind_startend_cum(data.len_orbit);
    
    % count for screening
    n = length(data.idx_screen);
    if sum(data.idx_screen)>0
        idx = ~data.idx_screen;
        [n1,n2,n3] = size(lat);lat1 = NaN(n1,n,n3);
        lat1(:,idx,:) = lat;lat = lat1;clear lat1;
        [n1,n2,n3] = size(lon);lon1 = NaN(n1,n,n3);
        lon1(:,idx,:) = lon;lon = lon1;clear lon1;
        [n1,n2,n3,n4] = size(tb_mainlobe);tb_mainlobe1 = NaN(n1,n2,n,n4);
        tb_mainlobe1(:,:,idx,:) = tb_mainlobe;tb_mainlobe = tb_mainlobe1;clear tb_mainlobe1;
        
        if ~isempty(tb_scene)
            [n1,n2,n3,n4] = size(tb_scene);tb_scene1 = NaN(n1,n2,n,n4);
            tb_scene1(:,:,idx,:) = tb_scene;tb_scene = tb_scene1;clear tb_scene1;
        end
    end
    
    % produce orbital data
    lat_org = lat;
    lon_org = lon;
    tb_mainlobe_org = tb_mainlobe;
    tb_scene_org = tb_scene;
    time_sc_org = data.time_sc;
    
    idx = ind_dayn==nday;
    files_sensor1 = files_sensor(idx);
    for nfile=1: size(files_sensor1,1)
        ind = ind_day_orbit1(nfile): ind_day_orbit2(nfile);
        lat = lat_org(:,ind,:);
        lon = lon_org(:,ind,:);
        tb_mainlobe = tb_mainlobe_org(:,:,ind,:);
        if ~isempty(tb_scene_org)
            tb_scene = tb_scene_org(:,:,ind,:);
        end
        time_sc = time_sc_org(ind);
        
        outpath = [Path.sim.orbit,'/',ndatestr1(1:4),'/',ndatestr1];
        if ~exist(outpath,'dir')
            mkdir(outpath)
        end
        outfile = ['sim_tb_',Path.sensor.spacecraft,'_',Path.sensor.name,'_',files_sensor1(nfile).name,'.mat'];
        save([outpath,'/',outfile],'lat','lon','tb_mainlobe','tb_scene','time_sc');
        disp(outfile)
    end
end
