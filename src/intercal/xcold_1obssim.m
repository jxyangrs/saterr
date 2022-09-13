function xcold_1obssim
% perform collcation and simulation
%
% Input:
% see section of Input
% path of input data, sub_setPathRawData
%
% Output:
% ..\data\1obs\year\files
%
% written by John Xun Yang, University of Michigan, johnxun@umich.edu, 03/2014
% revised by John Xun Yang, 8/17/2014: use amsr2 as reference radiometer
% revised by John Xun Yang, 8/28/2014: extend regions; amsr2-WindSat;
% revised by John Xun Yang, 9/2/2014: add sub_setRadName
% revised by John Xun Yang, 9/10/2014: move preprocss in xhot_0main
% revised by John Xun Yang, 9/19/2014: revise to xwater, from xhot
% revised by John Xun Yang, 12/28/2014: add variable-grid
% revised by John Xun Yang, 1/10/2015: change input syntax
% revised by John Xun Yang, 1/21/2015: simulation every 6-hour
% revised by John Xun Yang, 2/14/2015: remove 3sigma filter
% revised by John Xun Yang, 3/11/2015: update collocate
% revised by John Xun Yang, 3/15/2015: add H2O and wind output
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 6/21/2016: add atms and refine
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, 8/10/2016: refine as it is good to turn of filters

global DateBegin DateEnd % input
global RefRadData RefRadDataInfo RefRadSpc RefIndDD % reference radiometer
global TarRadData TarRadDataInfo TarRadSpc TarIndDD % target radiometer
global landMask LatMask LonMask % land filter
global ColTime ColGrid InNGrid % grid resolutionn
global TarRadRTM RefRadRTM AuxSet % reanalysis data for simulation
global PathRoot RunMode CodeFun IsSwapRad % root path, running mode, name of function, swap radiometer in analysis
global IndChanSelect CustomSim CustomRadSpc % setting for performing vicarious coldest TB method, select channels
global FilterSet % filters for TB

%% Input

% setup path of input raw data
% TarPathIn = sub_setPathRawData_ITE051_1998(TarRadDataInfo); 
% RefPathIn = sub_setPathRawData_ITE051_1998(RefRadDataInfo);
TarPathIn = sub_setPathRawData(TarRadDataInfo);
RefPathIn = sub_setPathRawData(RefRadDataInfo);
PathOut = [PathRoot,'1obssim/'];

% load landmask
load('landMask.mat'); % landMask,LatMask,LonMask

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
    for d=1: numdaily % read files within a day
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
        [tb,qual,eia,lat,lon,time] = sub_setRead1File(RefRadDataInfo,rfileinfo.path,rfileinfo.name(d),IndChanSelect.refind_default);
        if isempty(tb)
            continue
        end
        
        % size
        [n1,n2,n3] = size(tb); % [along-track,cross-track,channel]
        idxfil = false(n1,n2); % 1=bad;0=good
        
        %% basic filter
        % filter out land
        idx = sub_filterland(lat,lon); %0=water;1=land
        if sum(~idx(:))<=100
            continue
        end
        idxfil = idxfil | idx;
        % filter of quality flag
        idxfil = idxfil | qual;
        % filter of TB range
        idx = tb<=FilterSet.tbrange(1) | FilterSet.tbrange(2)<tb;
        idx = sum(idx,3);
        idxfil = idxfil | idx;
        % index of ascending/descending
        idx_asc = [ones(1,n2); diff(lat)] > 0; %1=ascending,0=descending
        % apply filter
        idx = ~idxfil;
        [lat,lon,time,idx_asc] = sub_filterInd2D(idx,lat,lon,time(:,ones(n2,1)),idx_asc);
        idx = idx(:,:,ones(n3,1));
        eia = eia(idx); eia = reshape(eia,[],n3);
        tb = tb(idx); tb = reshape(tb,[],n3);
        ncross = 1:n2;ncross = ncross(ones(n1,1),:);ncross = ncross(~idxfil);
        idxfil_1 = idxfil==0;
        if isempty(lat)
            continue
        end

        %% filters with ancillary data
        if FilterSet.aux
        % read geophysical parameters of reanalysis data
        idatehour = datestr(round(mean(time(:))*24/6)*6/24,'yyyymmddHH');
        if ~strcmp(idatehour,idatehour_last) % no need to read if not change
            [aux_Ts,aux_wind,aux_clw,aux_ice] = read_geo_reanalysis(AuxSet,idatehour);
            idatehour_last = idatehour;
        end
        idx1 = false(size(lat));
        % filter of surface temperature 
        if ~isempty(aux_Ts)
            [Ts1] = rtm_2geoField_prof2grid(lat,lon,aux_Ts,landMask); % allocate geophysical wind and Ts with reanalysis data
            idx = Ts1<273.15-2;
            idx1(idx) = 1;
        end
        % filter of clw 
        if ~isempty(aux_clw)
            [clw1] = rtm_2geoField_prof2grid(lat,lon,aux_clw,landMask); % allocate geophysical wind and Ts with reanalysis data
            idx = clw1>0;
            idx1(idx) = 1;
        end
        % filter of ice 
        if ~isempty(aux_ice)
            [ice1] = rtm_2geoField_prof2grid(lat,lon,aux_ice,landMask);
            idx = ice1>0;
            idx1(idx) = 1;
        end
        % apply filter
        idx = ~idx1;
        [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(idx,lat,lon,time,idx_asc,eia,tb,ncross);
        clear Ts1 clw1 ice1
        idxfil(idxfil_1) = idx1;
        idxfil_1 = idxfil==0;
        if isempty(lat)
            continue
        end        
        end
        
        %% filter of scanning-radiometer precipitation
        if FilterSet.conical_precipocean && strcmp(RefRadSpc.scantype,'conical')
            [~,tb19v,tb19h,tb37v,tb37h] = sub_tbChan(tb,RefRadSpc.chanstruni,'19V','19H','37V','37H');
            if ~(isempty(tb19v) || isempty(tb19h) || isempty(tb37v) || isempty(tb37h))
                idx1 = sub_filterPrecipocean(tb19v,tb19h,tb37v,tb37h);
                
                % apply filter
                idx = ~idx1;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(idx,lat,lon,time,idx_asc,eia,tb,ncross);

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
                [Ts1,wind1,landseaflag] = rtm_2geoField_prof2grid(lat,lon,aux_Ts,aux_wind,landMask);
                [m1,m2] = size(tb);
                Ts1 = Ts1';
                wind1 = wind1';
                landseaflag = landseaflag';
                
                % retrieval
                snowflag = zeros(m1,1);
                seaiceflag = zeros(m1,1);
                [wvp,clw,iwp,de,rr] = sub_retrieve_atms(landseaflag,snowflag,seaiceflag,tb,eia,wind1,Ts1);
                % apply filter
                idx = wvp>20 | clw>0 | iwp>0.1 | de>0.5 | rr>0;
                idx = ~idx;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(idx,lat,lon,time,idx_asc,eia,tb,ncross);
                
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
        [tb,qual,eia,lat,lon,time] = sub_setRead1File(TarRadDataInfo,tfileinfo.path,tfileinfo.name(d),IndChanSelect.tarind_default);
        if isempty(tb)
            continue
        end
        
        % size
        [n1,n2,n3] = size(tb); % [along-track,cross-track,channel]
        
        %% basic filter
        idxfil = false(n1,n2); % 1=bad;0=good
        % filter out land
        idx = sub_filterland(lat,lon); %0=water;1=land
        if sum(~idx(:))<=100
            continue
        end
        idxfil = idxfil | idx;
        % filter of quality flag
        idxfil = idxfil | qual;
        % filter of TB range
        idx = tb<=FilterSet.tbrange(1) | FilterSet.tbrange(2)<=tb;
        idx = sum(idx,3);
        idxfil = idxfil | idx;
        % index of ascending/descending
        idx_asc = [ones(1,n2); diff(lat)] > 0; %1=ascending,0=descending
        % apply filter
        idx = ~idxfil;
        [lat,lon,time,idx_asc] = sub_filterInd2D(idx,lat,lon,time(:,ones(n2,1)),idx_asc);
        idx = idx(:,:,ones(n3,1));
        eia = eia(idx); eia = reshape(eia,[],n3);
        tb = tb(idx); tb = reshape(tb,[],n3);
        ncross = 1:n2;ncross = ncross(ones(n1,1),:);ncross = ncross(~idxfil);
        idxfil_1 = idxfil==0;
        if isempty(lat)
            continue
        end

        %% filters with ancillary data
        if FilterSet.aux
        % read geophysical parameters of reanalysis data
        idatehour = datestr(round(mean(time(:))*24/6)*6/24,'yyyymmddHH');
        if ~strcmp(idatehour,idatehour_last) % no need to read if not change
            [aux_Ts,~,aux_clw,aux_ice] = read_geo_reanalysis(AuxSet,idatehour);
            idatehour_last = idatehour;
        end
        idx1 = false(size(lat));
        % filter of surface temperature 
        if ~isempty(aux_Ts)
            [Ts1] = rtm_2geoField_prof2grid(lat,lon,aux_Ts,landMask); % allocate geophysical wind and Ts with reanalysis data
            idx = Ts1<273.15-2;
            idx1(idx) = 1;
        end
        % filter of clw 
        if ~isempty(aux_clw)
            [clw1] = rtm_2geoField_prof2grid(lat,lon,aux_clw,landMask); % allocate geophysical wind and Ts with reanalysis data
            idx = clw1>0;
            idx1(idx) = 1;
        end
        % filter of ice 
        if ~isempty(aux_ice)
            [ice1] = rtm_2geoField_prof2grid(lat,lon,aux_ice,landMask);
            idx = ice1>0;
            idx1(idx) = 1;
        end
        % apply filter
        idx = ~idx1;
        [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(idx,lat,lon,time,idx_asc,eia,tb,ncross);
        clear Ts1 clw1 ice1
        idxfil(idxfil_1) = idx1;
        idxfil_1 = idxfil==0;
        if isempty(lat)
            continue
        end        
        end
        
        %% filter of scanning-radiometer precipitation
        if FilterSet.conical_precipocean && strcmp(TarRadSpc.scantype,'conical')
            [~,tb19v,tb19h,tb37v,tb37h] = sub_tbChan(tb,TarRadSpc.chanstruni,'19V','19H','37V','37H');
            if ~(isempty(tb19v) || isempty(tb19h) || isempty(tb37v) || isempty(tb37h))
                idx1 = sub_filterPrecipocean(tb19v,tb19h,tb37v,tb37h);
                
                % apply filter
                idx = ~idx1;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(idx,lat,lon,time,idx_asc,eia,tb,ncross);

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
                [Ts1,wind1,landseaflag] = rtm_2geoField_prof2grid(lat,lon,aux_Ts,aux_wind,landMask);
                [m1,m2] = size(tb);
                Ts1 = Ts1';
                wind1 = wind1';
                landseaflag = landseaflag';
                
                % retrieval
                snowflag = zeros(m1,1);
                seaiceflag = zeros(m1,1);
                [wvp,clw,iwp,de,rr] = sub_retrieve_atms(landseaflag,snowflag,seaiceflag,tb,eia,wind1,Ts1);
                % apply filter
                idx = wvp>20 | clw>0 | iwp>0.1 | de>0.5 | rr>0;
                idx = ~idx;
                [lat,lon,time,idx_asc,eia,tb,ncross] = sub_filterInd1D(idx,lat,lon,time,idx_asc,eia,tb,ncross);
                
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
    
    org_rtb = rtb;
    org_rlat = rlat;
    org_rlon = rlon;
    org_reia = reia;
    org_rtime = rtime;
    org_rncross = rncross;
    org_rasc = rasc;
    
    org_ttb = ttb;
    org_tlat = tlat;
    org_tlon = tlon;
    org_teia = teia;
    org_ttime = ttime;
    org_tncross = tncross;
    org_tasc = tasc;
    
    for igrid = 1: length(ColGrid)
        %% find collocated data
        [cID,mlat,mlon,mtime,rID,ridx,tID,tidx] = ...
            sub_collocate(ColTime(igrid),ColGrid(igrid),double(org_rlat),double(org_rlon),org_rtime,double(org_tlat),double(org_tlon),org_ttime);
        
        if isempty(cID)
            continue
        end
        rtb=org_rtb(ridx,:);rncross=org_rncross(ridx);reia=org_reia(ridx,:);rasc=org_rasc(ridx);rtime=org_rtime(ridx);rlat=org_rlat(ridx);rlon=org_rlon(ridx);
        ttb=org_ttb(tidx,:);tncross=org_tncross(tidx);teia=org_teia(tidx,:);tasc=org_tasc(tidx);ttime=org_ttime(tidx);tlat=org_tlat(tidx);tlon=org_tlon(tidx);
        
        % mean and std
        [mrnum,~,~,mrtb,mrtbstd] = sub_uniqmeanstd(rID,double(rtb));
        [mtnum,~,~,mttb,mttbstd] = sub_uniqmeanstd(tID,double(ttb));
        [~,~,~,mreia,mrncross,mrasc,mrtime,mrlat,mrlon] = sub_uniqmean(rID,reia,rncross,rasc,rtime,rlat,rlon);
        [~,~,~,mteia,mtncross,mtasc,mttime,mtlat,mtlon] = sub_uniqmean(tID,teia,tncross,tasc,ttime,tlat,tlon);
        
        % time and geo difference
        mtimedif = (mttime-mrtime)*24*60; % time difference, minutes
        
        %% simulation and filtering
        for isim=1: 1 % rough and accurate simulation
            
            auxDataTime = round(min(mtime)*24/6)/(24/6): 6/24: round(max(mtime)*24/6)/(24/6);
            rsimTB = NaN(size(mrtb));
            tsimTB = NaN(size(mttb));
            %         wind=NaN(size(mttb,1),1);clw=NaN(size(mttb,1),1);
            temp_time = round(mtime*24/6)/(24/6);
            for iauxtime=1: size(auxDataTime,2)
                idx = temp_time == auxDataTime(iauxtime);
                if sum(idx)>0
                    rsimTB1 = rtm_0main(RefRadRTM,mlat(idx),mlon(idx),mreia(idx,:),auxDataTime(iauxtime),AuxSet);
                    tsimTB1 = rtm_0main(TarRadRTM,mlat(idx),mlon(idx),mteia(idx,:),auxDataTime(iauxtime),AuxSet);
                    if isempty(tsimTB1)
                        continue
                    end
                    rsimTB(idx,:) = rsimTB1;
                    tsimTB(idx,:) = tsimTB1;
                    %                 wind(idx)=wind1;clw(idx,:)=clw1;
                end
            end
            
            %% filters for quality control
            idxfil = false(size(mrtb,1),1); % 1=bad,0=good
            % single and double difference
            rtbsd = mrtb - rsimTB;
            ttbsd = mttb - tsimTB;
            tbdd = ttbsd(:,TarIndDD)-rtbsd(:,RefIndDD);
            
            idx = sum(abs(rtbsd)>FilterSet.rtbsd,2);
            idxfil = idxfil | idx;
            idx = sum(abs(ttbsd)>FilterSet.ttbsd,2);
            idxfil = idxfil | idx;
            idx = sum(abs(tbdd)>FilterSet.tbdd,2);
            idxfil = idxfil | idx;
            
            % filter of NaN
            idx = isnan(rsimTB(:,1));
            idxfil = idxfil | idx;
            
            % apply filter
            idx = ~idxfil; % change to 1=good,0=bad
            [mtime,mlat,mlon,mrtb,mreia,mrtbstd,mrncross,mrasc,mrnum,mttb,mteia,mttbstd,mtncross,mtasc,mtnum,mtimedif,rsimTB,tsimTB] = ...
                sub_filterInd1D(idx,mtime,mlat,mlon,mrtb,mreia,mrtbstd,mrncross,mrasc,mrnum,mttb,mteia,mttbstd,mtncross,mtasc,mtnum,mtimedif,rsimTB,tsimTB);
            [rtbsd,ttbsd,tbdd] = sub_filterInd1D(idx,rtbsd,ttbsd,tbdd);
            %         [wind,clw] = sub_filterInd1D(idx,wind,clw);
        end
        
        %% tranform from double to single, except mtime
        mlat = single(mlat); mlon = single(mlon);
        mrtb = single(mrtb); mreia = single(mreia); mrtbstd = single(mrtbstd);mrncross=single(round(mrncross));mrasc=logical(round(mrasc));mrnum=single(mrnum);
        mttb = single(mttb); mteia = single(mteia); mttbstd = single(mttbstd);mtncross=single(round(mtncross));mtasc=logical(round(mtasc));mtnum=single(mtnum);
        mtimedif = single(mtimedif);
        
        % double to single
        rsimTB = single(rsimTB);
        tsimTB = single(tsimTB);
%         wind=single(wind);clw=single(clw);

        %% save daily collocated data
        
        outfile = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename,'-',CodeFun,'-1obs-',ndatestr(m,1:8),'.mat'];
        outpath = [PathOut,ndatestr(m,1:4),'/'];
        if ~exist(outpath,'dir')
            mkdir(outpath) % create directory if not existing
        end
        save([outpath,outfile], 'mtime','mlat','mlon',...
            'mrtb','mrncross','mrnum','mrasc',...
            'mttb','mtncross','mtnum','mtasc',...
            'mtimedif',...
            'rsimTB','tsimTB');%,...
    end
end


