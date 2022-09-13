function xcold_1obs
% perform collcation for observation
%
% Input:
% see section of Input
% path of input data, sub_setPathRawData
%
% Output:
% ..\data\1obs\year\files
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 6/21/2016: add atms and refine
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/10/2016: refine as it is good to turn of filters
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/22/2016: do observation only and substitude degree with distance
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 8/20/2017: adapt to CRTM
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/27/2017: file rename,debug

global DateBegin DateEnd % input
global RefRadData RefRadDataInfo RefRadSpc RefIndDD % reference radiometer
global TarRadData TarRadDataInfo TarRadSpc TarIndDD % target radiometer
global landMask LatMask LonMask % land filter
global ColTime ColGrid InNGrid % grid resolutionn
global TarRadRTM RefRadRTM AuxSet % reanalysis data for simulation
global PathRoot RunMode CodeFun IsSwapRad % root path, running mode, name of function, swap radiometer in analysis
global IndChanSelect CustomSim CustomRadSpc % setting for performing vicarious coldest TB method, select channels
global FilterSet % filters for TB
global PLat PLon % polynomial scale for degree2dist

%% Input

% setup path of input raw data
% TarPathIn = sub_setPathRawData_ITE051_1998(TarRadDataInfo); 
% RefPathIn = sub_setPathRawData_ITE051_1998(RefRadDataInfo);
TarPathIn = setting_PathRawData(TarRadDataInfo);
RefPathIn = setting_PathRawData(RefRadDataInfo);
PathOut = [PathRoot,'1obs/'];

% load landmask
load('landMask-ORNL.mat'); % landMask,LatMask,LonMask

%% Execute

% setting
idatehour_last = 'initialized'; % for reading ancillary data

% produce string date
ndatestr = datestr(datenum(DateBegin,'yyyymmdd'): datenum(DateEnd,'yyyymmdd'), 'yyyymmdd');
% ndatestr = ndatestr(end:-1:1,:);
%read in raw data
numdate = size(ndatestr,1);
for m=1:numdate
    
    %% set up file path
    [tfileinfo] = sub_setFileDaily(TarRadDataInfo,TarPathIn,ndatestr(m,:));
    [rfileinfo] = sub_setFileDaily(RefRadDataInfo,RefPathIn,ndatestr(m,:));
    
    if (tfileinfo.united_filenum==0) || (rfileinfo.united_filenum==0)
        continue
    end
    
    %% read reference radiometer data

    % daily variable
    rtb = single([]);
    reia = single([]);
    rlat = single([]);
    rlon = single([]);
    rtime = [];
    rncross = single([]);
    rasc = logical([]); % index of ascending/descending,1=asc,0=des
    % read daily data
    numdaily = rfileinfo.united_filenum;
    for d=1: 1%numdaily % read files within a day
        % show each input file
        if rfileinfo.groupnum==1
            fprintf('%s\n', rfileinfo.name(d).united);
        elseif rfileinfo.groupnum>1
            temp = fieldnames(rfileinfo.name(d));
            for ifield=2: size(temp,1)
                fprintf('%s\n', getfield(rfileinfo.name(d),temp{ifield}));
            end
        end
        
        % read single file
        [tb,qual,eia,lat,lon,time] = set_Read1File(RefRadDataInfo,rfileinfo.path,rfileinfo.name(d),IndChanSelect.refind_default);
        if isempty(tb)
            continue
        end
        
        [n1,n2,n3] = size(tb); % [along-track,cross-track,channel]
        ncross = (1:n1)';
        ncross = ncross(:,ones(n2,1));
        if length(size(eia))<3
            eia = eia(:,:,ones(n3,1));
        end
        
        %% basic filter
        idxfil = false(n1,n2); % 1=bad;0=good
        % filter of land
        if FilterSet.landmask
            idx = sub_filterland(lat,lon); %0=water;1=land
            if sum(~idx(:))<=100
                continue
            end
            idxfil = idxfil | idx;
        end
        % filter of quality flag
        idxfil = idxfil | qual;
        % filter of TB range
        idx = tb<=FilterSet.tbrange(1) | FilterSet.tbrange(2)<tb;
        idx = sum(idx,3);
        idxfil = idxfil | idx;
        % index of ascending/descending
        idx_asc = [ones(n1,1),diff(lat,1,2)] > 0; %1=ascending,0=descending
        % apply filter
        idx = ~idxfil;
        [lat,lon,time,idx_asc] = sub_filterInd2D(idx,lat,lon,time(ones(n1,1),:),idx_asc);
        ncross = ncross(~idxfil);
        idx = idx(:,:,ones(n3,1));
        tb = tb(idx); tb = reshape(tb,[],n3);
        eia = eia(idx); eia = reshape(eia,[],n3);
        
        if isempty(lat)
            continue
        end

        %% filters with ancillary data
        if FilterSet.aux
        % read geophysical parameters of reanalysis data
        idatehour = datestr(round(mean(time(:))*24/6)*6/24,'yyyymmddHH');
        if ~strcmp(idatehour,idatehour_last) % no need to read if not change
            [aux_lat,aux_lon,aux_H,aux_Ts,aux_wind,aux_clwc,aux_ice] = read_geo_reanalysis(AuxSet,idatehour);
            idatehour_last = idatehour;
        end
        idx1 = false(size(lat));
        % filter of surface temperature 
        if ~isempty(aux_Ts)
            [Ts1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,aux_Ts); % allocate geophysical wind and Ts with reanalysis data

            idx = Ts1<273.15-2;
            idx1(idx) = 1;
        end
        % filter of clw 
        if ~isempty(aux_clwc)
            dH = diff(aux_H,1,3);
            dH = cat(3,dH,dH(:,:,end));
            cum_clwc = sum(aux_clwc.*dH,3);
            [cum_clwc1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,cum_clwc); % allocate geophysical wind and Ts with reanalysis data
            idx = cum_clwc1>0.03;
            idx1(idx) = 1;
        end
        % filter of ice 
        if ~isempty(aux_ice)
            [aux_ice1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,aux_ice);
            idx = aux_ice1>0;
            idx1(idx) = 1;
        end
        % apply filter
        idx = ~idx1;
        [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(1,idx,lat,lon,time,idx_asc,eia,tb,ncross);
        clear Ts1 cum_clwc1 aux_ice1
        if isempty(lat)
            continue
        end        
        end
        
        %% filter of conical-scanning-radiometer precipitation
        if FilterSet.conical_precipocean && strcmp(RefRadSpc.scantype,'conical')
            [~,tb19v,tb19h,tb37v,tb37h] = sub_tbChan(tb,RefRadSpc.chanstruni,'19V','19H','37V','37H');
            if ~(isempty(tb19v) || isempty(tb19h) || isempty(tb37v) || isempty(tb37h))
                idx1 = sub_filterPrecipocean(tb19v,tb19h,tb37v,tb37h);
                
                % apply filter
                idx = ~idx1;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(1,idx,lat,lon,time,idx_asc,eia,tb,ncross);

                idxfil(idxfil_1) = idx1;
                idxfil_1 = idxfil==0;
                if isempty(lat)
                    continue
                end
            end
        end
        
        %% filter with retrieving and screening of water vapor, rain rate for cross-track scanning radiometers such as atms
        % wvp, clw, iwp, de, rr
        % total precipitable water (mm), cloud liquid water path (mm), cloud ice water path(mm), cloud ice effective diameter (mm), surface rain rate (mm/h)
        if FilterSet.cross_precipocean && strcmp(RefRadSpc.scantype,'cross-track')
            % filter of retrieval
            if ~(isempty(aux_Ts) || isempty(aux_wind) || isempty(lat))
                [Ts1,wind1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,aux_Ts,aux_wind);
                Ts1 = Ts1';
                wind1 = wind1';
                landseaflag = sub_filterland(lat,lon);
                
                [m1,m2] = size(tb);
                
                % retrieval
                snowflag = zeros(m1,1);
                seaiceflag = zeros(m1,1);
                [wvp,clw,iwp,de,rr] = cal_retrieve_atms(landseaflag,snowflag,seaiceflag,tb,eia,wind1,Ts1);
                % apply filter
                idx = wvp>20 | clw>0 | iwp>0.1 | de>0.5 | rr>0;
                idx = ~idx;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(1,idx,lat,lon,time,idx_asc,eia,tb,ncross);
                
                idxfil(idxfil_1) = idx;
                idxfil_1 = idxfil==0;
                
                if isempty(lat)
                    continue
                end
            end
        end
        
        % collect daily data
        tb = tb(:,IndChanSelect.refind);
        eia = eia(:,IndChanSelect.refind);
        rtb = [rtb; tb];
        reia = [reia; eia];
        rlat = [rlat; lat];
        rlon = [rlon; lon];
        rtime = [rtime; time];
        rncross = [rncross;ncross];
        rasc = [rasc;idx_asc];
    end

    if isempty(rtb)
        continue;
    end

    %% read Target data

    % set up daily varibles
    ttb = single([]);
    tlat = single([]);
    tlon = single([]);
    teia = single([]);
    ttime = double([]);
    tncross = single([]);
    tasc = logical([]); % 1=ascending,0=descending
    % read daily data
    numdaily = tfileinfo.united_filenum;
    for d = 1: numdaily
        % show each input file
        if tfileinfo.groupnum==1
            fprintf('%s\n', tfileinfo.name(d).united);
        elseif tfileinfo.groupnum>1
            temp = fieldnames(tfileinfo.name(d));
            for ifield=2: size(temp,1)
                fprintf('%s\n', getfield(tfileinfo.name(d),temp{ifield}));
            end
        end
        
        % read data
        [tb,qual,eia,lat,lon,time] = set_Read1File(TarRadDataInfo,tfileinfo.path,tfileinfo.name(d),IndChanSelect.tarind_default);
        if isempty(tb)
            continue
        end
        
        [n1,n2,n3] = size(tb); % [along-track,cross-track,channel]
        ncross = (1:n1)';
        ncross = ncross(:,ones(n2,1));
        if length(size(eia))<3
            eia = eia(:,:,ones(n3,1));
        end
        
        %% basic filter
        idxfil = false(n1,n2); % 1=bad;0=good
        % filter of land
        if FilterSet.landmask
            idx = sub_filterland(lat,lon); %0=water;1=land
            if sum(~idx(:))<=100
                continue
            end
            idxfil = idxfil | idx;
        end
        % filter of quality flag
        idxfil = idxfil | qual;
        % filter of TB range
        idx = tb<=FilterSet.tbrange(1) | FilterSet.tbrange(2)<tb;
        idx = sum(idx,3);
        idxfil = idxfil | idx;
        % index of ascending/descending
        idx_asc = [ones(n1,1),diff(lat,1,2)] > 0; %1=ascending,0=descending
        % apply filter
        idx = ~idxfil;
        [lat,lon,time,idx_asc] = sub_filterInd2D(idx,lat,lon,time(ones(n1,1),:),idx_asc);
        ncross = ncross(~idxfil);
        idx = idx(:,:,ones(n3,1));
        tb = tb(idx); tb = reshape(tb,[],n3);
        eia = eia(idx); eia = reshape(eia,[],n3);
        
        if isempty(lat)
            continue
        end

        %% filters with ancillary data
        if FilterSet.aux
        % read geophysical parameters of reanalysis data
        idatehour = datestr(round(mean(time(:))*24/6)*6/24,'yyyymmddHH');
        if ~strcmp(idatehour,idatehour_last) % no need to read if not change
            [aux_lat,aux_lon,aux_H,aux_Ts,aux_wind,aux_clwc,aux_ice] = read_geo_reanalysis(AuxSet,idatehour);
            idatehour_last = idatehour;
        end
        idx1 = false(size(lat));
        % filter of surface temperature 
        if ~isempty(aux_Ts)
            [Ts1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,aux_Ts); % allocate geophysical wind and Ts with reanalysis data

            idx = Ts1<273.15-2;
            idx1(idx) = 1;
        end
        % filter of clw 
        if ~isempty(aux_clwc)
            dH = diff(aux_H,1,3);
            dH = cat(3,dH,dH(:,:,end));
            cum_clwc = sum(aux_clwc.*dH,3);
            [cum_clwc1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,cum_clwc); % allocate geophysical wind and Ts with reanalysis data
            idx = cum_clwc1>0.03;
            idx1(idx) = 1;
        end
        % filter of ice 
        if ~isempty(aux_ice)
            [aux_ice1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,aux_ice);
            idx = aux_ice1>0;
            idx1(idx) = 1;
        end
        % apply filter
        idx = ~idx1;
        [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(1,idx,lat,lon,time,idx_asc,eia,tb,ncross);
        clear Ts1 cum_clwc1 aux_ice1
        if isempty(lat)
            continue
        end        
        end
        
        %% filter precipitation for conical-scanning radiometer
        if FilterSet.conical_precipocean && strcmp(TarRadSpc.scantype,'conical')
            [~,tb19v,tb19h,tb37v,tb37h] = sub_tbChan(tb,TarRadSpc.chanstruni,'19V','19H','37V','37H');
            if ~(isempty(tb19v) || isempty(tb19h) || isempty(tb37v) || isempty(tb37h))
                idx1 = sub_filterPrecipocean(tb19v,tb19h,tb37v,tb37h);
                
                % apply filter
                idx = ~idx1;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(1,idx,lat,lon,time,idx_asc,eia,tb,ncross);

                idxfil(idxfil_1) = idx1;
                idxfil_1 = idxfil==0;
                if isempty(lat)
                    continue
                end
            end
        end
        
        %% filter with retrieving and screening of water vapor, rain rate for cross-track scanning radiometers such as atms
        % wvp, clw, iwp, de, rr
        % total precipitable water (mm), cloud liquid water path (mm), cloud ice water path(mm), cloud ice effective diameter (mm), surface rain rate (mm/h)
        if FilterSet.cross_precipocean && strcmp(TarRadSpc.scantype,'cross-track')
            % filter of retrieval
            if ~(isempty(aux_Ts) || isempty(aux_wind) || isempty(lat))
                [Ts1,wind1] = rtm_2geoField_prof2grid(lat,lon,aux_lat,aux_lon,aux_Ts,aux_wind);
                Ts1 = Ts1';
                wind1 = wind1';
                landseaflag = sub_filterland(lat,lon);
                
                [m1,m2] = size(tb);
                
                % retrieval
                snowflag = zeros(m1,1);
                seaiceflag = zeros(m1,1);
                [wvp,clw,iwp,de,rr] = cal_retrieve_atms(landseaflag,snowflag,seaiceflag,tb,eia,wind1,Ts1);
                % apply filter
                idx = wvp>20 | clw>0 | iwp>0.1 | de>0.5 | rr>0;
                idx = ~idx;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(1,idx,lat,lon,time,idx_asc,eia,tb,ncross);
                
                idxfil(idxfil_1) = idx;
                idxfil_1 = idxfil==0;
                
                if isempty(lat)
                    continue
                end
            end
        end
        
        % collect daily data
        tb = tb(:,IndChanSelect.tarind);
        eia = eia(:,IndChanSelect.tarind);
        ttb = [ttb;tb];
        tlat = [tlat;lat];
        tlon = [tlon;lon];
        teia = [teia;eia];
        ttime = [ttime;time];
        tncross = [tncross;ncross];
        tasc = [tasc;idx_asc];
    end
    if isempty(ttb)
        continue;
    end
    
    [rlon_dist,rlat_dist1] = dist_earthxy(0,0,rlat,rlon);
    rlon_dist=rlon_dist(:);
    rlat_dist=rlat_dist1(:);
    [tlon_dist,tlat_dist] = dist_earthxy(0,0,tlat,tlon);
    tlon_dist=tlon_dist(:);
    tlat_dist=tlat_dist(:);
    
    %% find collocated data
    [cID,mlat,mlon,mtime,rID,ridx,tID,tidx] = ...
        sub_collocate_dist(ColTime,ColGrid,double(rlat_dist),double(rlon_dist),rtime,double(tlat_dist),double(tlon_dist),ttime);
    
    if isempty(cID)
        continue
    end
    rtb=rtb(ridx,:);rncross=rncross(ridx);reia=reia(ridx,:);rasc=rasc(ridx);rtime=rtime(ridx);rlat=rlat(ridx);rlon=rlon(ridx);
    ttb=ttb(tidx,:);tncross=tncross(tidx);teia=teia(tidx,:);tasc=tasc(tidx);ttime=ttime(tidx);tlat=tlat(tidx);tlon=tlon(tidx);
    
    % mean and std
    [mrnum,~,~,mrtb,mrtbstd] = sub_uniqmeanstd(rID,double(rtb));
    [mtnum,~,~,mttb,mttbstd] = sub_uniqmeanstd(tID,double(ttb));
    [~,~,~,mreia,mrncross,mrasc,mrtime,mrlat,mrlon] = sub_uniqmean(rID,reia,rncross,rasc,rtime,rlat,rlon);
    [~,~,~,mteia,mtncross,mtasc,mttime,mtlat,mtlon] = sub_uniqmean(tID,teia,tncross,tasc,ttime,tlat,tlon);
    
    % time and geo difference
    mtimedif = (mttime-mrtime)*24*60; % time difference, minutes
    
    %% tranform from double to single, except mtime
    mlat = single(mlat); mlon = single(mlon);
    mrlat=single(mrlat);mrlon=single(mrlon);
    mtlat=single(mtlat);mtlon=single(mtlon);
    mrtb = single(mrtb); mreia = single(mreia); mrtbstd = single(mrtbstd);mrncross=single(round(mrncross));mrasc=logical(round(mrasc));mrnum=single(mrnum);
    mttb = single(mttb); mteia = single(mteia); mttbstd = single(mttbstd);mtncross=single(round(mtncross));mtasc=logical(round(mtasc));mtnum=single(mtnum);
    mtimedif = single(mtimedif);
    
    %% save daily collocated data
    
    outfile = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename,'-',CodeFun,'-1obs-',ndatestr(m,1:8),'.mat'];
    outpath = [PathOut,ndatestr(m,1:4),'/'];
    if ~exist(outpath,'dir')
        mkdir(outpath) % create directory if not existing
    end
    save([outpath,outfile],...
        'mrtime','mrlat','mrlon','mrtb','mrncross','mrnum','mrasc','mreia',...
        'mttb','mtncross','mtnum','mtasc','mtlat','mtlon','mteia',...
        'mtimedif');%,...
end


