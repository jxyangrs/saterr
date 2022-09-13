function xcold_2cal
% apply inter-calibration
%
% Input: time period
% DateBegin, string of start of dates
% DateEnd, string of end of dates
%
% Output: monthly or daily cross-track bias
%
% Example:
%
% Folder Layout Requirement:
%
% written by John Xun Yang, University of Michigan, johnxun@umich.edu, 01/2014
% revised by John Xun Yang, 9/21/2014: revise all sub plot function
% revised by John Xun Yang, 12/28/2014: add variable-grid
% revised by John Xun Yang, 3/16/2015: map of tbsd, tbdd, wind, H2O
% revised by John Xun Yang, 4/22/2015: 2D plot of wind, H2O; time series at different regions
% revised by John Xun Yang, 5/14/2015: refine

close all

global DateBegin DateEnd % input
global RefRadData RefRadDataInfo RefRadSpc RefIndDD % reference radiometer
global TarRadData TarRadDataInfo TarRadSpc TarIndDD % target radiometer
global landMask LatMask LonMask % land filter
global ColTime ColGrid InNGrid % grid resolution
global AuxSet % reanalysis data for simulation
global PathRoot RunMode CodeFun IsFuzzy IsSwapRad % root path, running mode, name of function, versions, swap radiometer in analysis

%% Input

% input and ouput path
PathIn1 = [PathRoot,'1obssim\']; % path of observation and simulation data
PathOut = [PathRoot,'2cal\'];

% Bin TB
BinTB = 60:0.5:300;
BinTBDD = -10:0.2:10;
BinHist1TBstd = 0:0.5:10;

RangeWindInfo.min=0;RangeWindInfo.max=50;RangeWindInfo.step=1;
RangeH2OdenInfo.min=0;RangeH2OdenInfo.max=300;RangeH2OdenInfo.step=1;
RangeLatInfo.min=-90;RangeLatInfo.max=90;RangeLatInfo.step=1;
RangeLonInfo.min=0;RangeLonInfo.max=359;RangeLonInfo.step=1;
RangeSSTInfo.min=265;RangeSSTInfo.max=320;RangeSSTInfo.step=1;

BinWind = RangeWindInfo.min : RangeWindInfo.step : RangeWindInfo.max; % m/s
BinH2Oden = RangeH2OdenInfo.min : RangeH2OdenInfo.step : RangeH2OdenInfo.max; % g/m^3
BinLat = RangeLatInfo.min : RangeLatInfo.step : RangeLatInfo.max; % g/m^3
BinLon = RangeLonInfo.min : RangeLonInfo.step : RangeLonInfo.max; % g/m^3
BinSST = RangeSSTInfo.min : RangeSSTInfo.step : RangeSSTInfo.max; % K

% MediTB = [170;92;193;123.50;219;212.50;152;260.50;229.50;260.50;229.50]'; % from cdf_ttb, medi_tb
MediTB = [168 84 169 85 175 91 196 120 219 163 218 155 258 226 258 226]; % for amsr2
n=length(MediTB);MediTB = [ones(1,n)*60;MediTB;ones(1,n)*300]; % [range,channel]

NumDir = 3; % direction of orbit, 3=[both/asc/des],1=[both]

% grid resolution of map
GridMap = 1;

% output ttb-dd for cold-warm 
OptXcoldwarm = 1;

%% execute

% collect daily data and process
for igrid = 1: length(InNGrid) % different grids
    ngrid = InNGrid(igrid);
    %% Execute
    % determine the time interval
    ndatestr = datestr(datenum(DateBegin,'yyyymmdd'): datenum(DateEnd,'yyyymmdd'), 'yyyymmdd');
    numday = size(ndatestr,1);
    
    %% set up variables
    
    % daily variables
	n1=RefRadSpc.numchan;n2=numday;n3=NumDir; % [channel,day,dir]
    day_rtb = NaN(n1,n2,n3);
    day_rtbstd = NaN(n1,n2,n3);
    day_rsimTB = NaN(n1,n2,n3);
	n1=TarRadSpc.numchan;
    day_ttb = NaN(n1,n2,n3);
    day_ttbstd = NaN(n1,n2,n3);
    day_tsimTB = NaN(n1,n2,n3);
    day_num = zeros(1,n2,n3); 
    day_time = NaN(1,n2,n3);
	day_H2Oden = NaN(1,n2,n3); 
	day_wind = NaN(1,n2,n3); 
	day_sst = NaN(1,n2,n3);
	
	n1=length(RangeWindInfo.min : RangeWindInfo.step : RangeWindInfo.max);n2=length(TarIndDD);n3=numday;n4=NumDir;% [rangeBin,channel,day,dir]
	daybin_windDD = NaN(n1,n2,n3,n4);
	n1=length(RangeH2OdenInfo.min : RangeH2OdenInfo.step : RangeH2OdenInfo.max);
	daybin_H2OdenDD = NaN(n1,n2,n3,n4);
	n1=length(RangeLatInfo.min : RangeLatInfo.step : RangeLatInfo.max);
	daybin_latDD = NaN(n1,n2,n3,n4);
	n1=length(RangeLonInfo.min : RangeLonInfo.step : RangeLonInfo.max);
	daybin_lonDD = NaN(n1,n2,n3,n4);
	n1=length(RangeSSTInfo.min : RangeSSTInfo.step : RangeSSTInfo.max);
	daybin_sstDD = NaN(n1,n2,n3,n4);

	n1=length(RangeWindInfo.min : RangeWindInfo.step : RangeWindInfo.max);n2=length(TarIndDD);n3=numday;n4=NumDir;% [rangeBin,channel,day,dir]
	daybin_windTSD = NaN(n1,n2,n3,n4);
	daybin_windRSD = NaN(n1,n2,n3,n4);
	n1=length(RangeH2OdenInfo.min : RangeH2OdenInfo.step : RangeH2OdenInfo.max);
	daybin_H2OdenTSD = NaN(n1,n2,n3,n4);
	daybin_H2OdenRSD = NaN(n1,n2,n3,n4);
	n1=length(RangeLatInfo.min : RangeLatInfo.step : RangeLatInfo.max);
	daybin_latTSD = NaN(n1,n2,n3,n4);
	daybin_latRSD = NaN(n1,n2,n3,n4);
	n1=length(RangeLonInfo.min : RangeLonInfo.step : RangeLonInfo.max);
	daybin_lonTSD = NaN(n1,n2,n3,n4);
	daybin_lonRSD = NaN(n1,n2,n3,n4);
	n1=length(RangeSSTInfo.min : RangeSSTInfo.step : RangeSSTInfo.max);
	daybin_sstTSD = NaN(n1,n2,n3,n4);
	daybin_sstRSD = NaN(n1,n2,n3,n4);
	
	n1 = length(BinH2Oden);n2=numday;n3=NumDir; % [hist,day,dir]
	dayhist_H2Oden = zeros(n1,n2,n3);
	n1 = length(BinWind);
	dayhist_wind = zeros(n1,n2,n3);
 	n1 = length(BinLat);
	dayhist_lat = zeros(n1,n2,n3);
	n1 = length(BinLon);
	dayhist_lon = zeros(n1,n2,n3);
	n1 = length(BinSST);
	dayhist_sst = zeros(n1,n2,n3);
   
    n1 = length(BinTB);n2=RefRadSpc.numchan;n3=NumDir; % [hist,channel,dir]
    hist1_rtb=zeros(n1,n2,n3);
	hist1_rsimTB=zeros(n1,n2,n3);
    n1 = length(BinHist1TBstd);
    h_rtbstd=zeros(n1,n2,n3);
    
    n1 = length(BinTB);n2=TarRadSpc.numchan;n3=NumDir;
    hist1_ttb=zeros(n1,n2,n3);
	hist1_tsimTB=zeros(n1,n2,n3);
    n1 = length(BinHist1TBstd);
    hist1_ttbstd=zeros(n1,n2,n3);

    n1 = length(BinTBDD);n2=length(TarIndDD);n3=NumDir;
    hist1_tbdd=zeros(n1,n2,n3);
    hist1_ttbsd=zeros(n1,n2,n3);

    n1 = length(BinTBDD);n2=length(BinTB);n3=length(TarIndDD);n4=NumDir; % [DD,TB,channel,dir]
    hist2_ttb_tbdd = zeros(n1,n2,n3,n4);
    hist2_ttb_ttbsd = zeros(n1,n2,n3,n4);
    hist2_rtb_rtbsd = zeros(n1,n2,n3,n4);
	n2=length(BinWind);
	hist2_wind_tbdd = zeros(n1,n2,n3,n4);
	hist2_wind_ttbsd = zeros(n1,n2,n3,n4);
	hist2_wind_rtbsd = zeros(n1,n2,n3,n4);
	n2=length(BinH2Oden);
	hist2_H2Oden_tbdd = zeros(n1,n2,n3,n4);
	hist2_H2Oden_ttbsd = zeros(n1,n2,n3,n4);
	hist2_H2Oden_rtbsd = zeros(n1,n2,n3,n4);
	n2=length(BinSST);
	hist2_sst_tbdd = zeros(n1,n2,n3,n4);
	hist2_sst_ttbsd = zeros(n1,n2,n3,n4);
	hist2_sst_rtbsd = zeros(n1,n2,n3,n4);
	
    n1 = length(BinLat);n2=length(BinLon);n3=length(TarIndDD);n4=NumDir; % [lat,lon,channel-DD,dir]
    map_tbdd = zeros(n1,n2,n3,n4);
    map_gridnum = zeros(n1,n2,1,n4);
    n3=TarRadSpc.numchan; % [lat,lon,channel,dir]
    map_ttb = zeros(n1,n2,n3,n4);
    map_ttbsd = zeros(n1,n2,n3,n4);
    map_wind = zeros(n1,n2,1,n4);
    map_H2Oden = zeros(n1,n2,1,n4);
    map_sst = zeros(n1,n2,1,n4);
    
    % along scan
    refncross = [1: RefRadSpc.numcross]';
    day_rcrossnum = zeros(RefRadSpc.numcross,1,numday,NumDir); % [cross,channel-1,day,dir]
    day_rcrosstb = NaN(RefRadSpc.numcross,RefRadSpc.numchan,numday,NumDir); % [cross,channel,day,dir]
    day_rcrosstbsim = NaN(RefRadSpc.numcross,RefRadSpc.numchan,numday,NumDir);
    
    tarncross = [1: TarRadSpc.numcross]';
    day_tcrossnum = zeros(TarRadSpc.numcross,1,numday,NumDir);
    day_tcrosstb = NaN(TarRadSpc.numcross,TarRadSpc.numchan,numday,NumDir);
    day_tcrosstbsim = NaN(TarRadSpc.numcross,TarRadSpc.numchan,numday,NumDir);
    
    day_crosstbdd = NaN(TarRadSpc.numcross,length(TarIndDD),numday,NumDir);
    day_crosstbdifobs = NaN(TarRadSpc.numcross,length(TarIndDD),numday,NumDir);
    day_crossttbsd = NaN(TarRadSpc.numcross,TarRadSpc.numchan,numday,NumDir);
    day_crossrtbsd = NaN(RefRadSpc.numcross,RefRadSpc.numchan,numday,NumDir);
    
    tbrange_crosstbdd = zeros(TarRadSpc.numcross,length(TarIndDD),size(MediTB,1)-1); % [cross,channel,tb-range]
    tbrange_tcrossnum = zeros(TarRadSpc.numcross,length(TarIndDD),size(MediTB,1)-1); 
    tbrange_crossttb = zeros(TarRadSpc.numcross,length(TarIndDD),size(MediTB,1)-1);
	
    %% collect daily data
    
    for m=1: numday
        % input path
        inpath1 = [PathIn1,ndatestr(m,1:4),'\'];
        if ~IsFuzzy
            infile1 = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename,'-',CodeFun,'-1obs-grid',num2str(ColGrid(ngrid)),'-',ndatestr(m,:),'.mat'];
        elseif IsFuzzy
            infile1 = [TarRadDataInfo.rad,'*',RefRadDataInfo.rad,'*-',CodeFun,'-1obs-grid',num2str(ColGrid(ngrid)),'-',ndatestr(m,:),'.mat'];
        else
            error('IsFuzzy value wrong')
        end
        if IsSwapRad && strcmp(RunMode,'step2')
            infile1 = [RefRadDataInfo.filename,'-',TarRadDataInfo.filename,'-',CodeFun,'-1obs-grid',num2str(ColGrid(ngrid)),'-',ndatestr(m,:),'.mat'];
        end
        fileinfo1 = dir([inpath1,infile1]);
        if isempty(fileinfo1)
            continue
        end
        iobs = load([inpath1,fileinfo1.name]);
        
        if IsSwapRad && strcmp(RunMode,'step2')
            fieldold = {'mlat';'mlon';'mtime';'mrnum';'mrtb';'mrtbstd';'mtnum';'mttb';'mttbstd';'mrncross';'mrasc';'mtncross';'mtasc';'mtimedif';'rsimTB';'tsimTB';'H2Oden';'wind';'sst';'ttbsurf';'clw';'ttbup';'ttbdn';'ttau'};
            fieldnew = {'mlat';'mlon';'mtime';'mtnum';'mttb';'mttbstd';'mrnum';'mrtb';'mrtbstd';'mtncross';'mtasc';'mrncross';'mrasc';'mtimedif';'tsimTB';'rsimTB';'H2Oden';'wind';'sst';'ttbsurf';'clw';'ttbup';'ttbdn';'ttau'}; % some fields keep the same
            n = size(fieldold,1);
            temp = iobs;
            clear iobs;
            for i= 1: n
                [iobs.(fieldnew{i})] = temp.(fieldold{i});
            end
            clear temp
        end
        
        % quality filter
        idxfil = false(size(iobs.mrtb,1),1); % 1=bad,0=good
        rtbsd = iobs.mrtb - iobs.rsimTB;
        ttbsd = iobs.mttb - iobs.tsimTB;
        tbdd = ttbsd(:,TarIndDD)-rtbsd(:,RefIndDD);
%         idx = sum(abs(rtbsd)>10,2);
%         idxfil = idxfil | idx;
%         idx = sum(abs(ttbsd)>10,2);
%         idxfil = idxfil | idx;
        idx = sum(abs(tbdd)>15,2);
        idxfil = idxfil | idx;
        clear tbdd rtbsd ttbsd % claim
        % apply filter
        idx = ~idxfil; % change to 1=good,0=bad
        [iobs.mtime,iobs.mlat,iobs.mlon,iobs.mrtb,iobs.mrtbstd,iobs.mrncross,iobs.mrasc,iobs.mrnum,iobs.mttb,iobs.mttbstd,iobs.mtncross,iobs.mtasc,iobs.mtnum,iobs.mtimedif,iobs.rsimTB,iobs.tsimTB] = ...
            sub_filterInd1D(idx,iobs.mtime,iobs.mlat,iobs.mlon,iobs.mrtb,iobs.mrtbstd,iobs.mrncross,iobs.mrasc,iobs.mrnum,iobs.mttb,iobs.mttbstd,iobs.mtncross,iobs.mtasc,iobs.mtnum,iobs.mtimedif,iobs.rsimTB,iobs.tsimTB);
        
        for idir=1: NumDir % [dir]
            switch idir % index
                case 1
                    idx = true(size(iobs.mtasc,1),1);
                case 2
                    idx = iobs.mtasc;
                case 3
                    idx = ~iobs.mtasc;
            end
            if sum(idx)<=2
                continue;
            end
            tbdd = (iobs.mttb(idx,TarIndDD)-iobs.tsimTB(idx,TarIndDD))-(iobs.mrtb(idx,RefIndDD)-iobs.rsimTB(idx,RefIndDD));
            rtbsd = iobs.mrtb - iobs.rsimTB;
            ttbsd = iobs.mttb - iobs.tsimTB;

            % daily
            day_num(:,m,idir) = sum(idx);day_time(:,m,idir)=mean(iobs.mtime(idx,:),1);
            day_rtb(:,m,idir) = mean(iobs.mrtb(idx,:),1);day_rtbstd(:,m,idir)=mean(iobs.mrtbstd(idx,:),1);day_rsimTB(:,m,idir)=mean(iobs.rsimTB(idx,:),1);
            day_ttb(:,m,idir) = mean(iobs.mttb(idx,:),1);day_ttbstd(:,m,idir)=mean(iobs.mttbstd(idx,:),1);day_tsimTB(:,m,idir)=mean(iobs.tsimTB(idx,:),1);
			day_H2Oden(:,m,idir) = mean(iobs.H2Oden(idx,:),1);
			day_wind(:,m,idir) = mean(iobs.wind(idx,:),1);
			day_sst(:,m,idir) = mean(iobs.sst(idx,:),1);
			
            % daily temporal 2D
			[~,~,~,daybin_H2OdenDD(:,:,m,idir)] = sub_meanRangeVar(RangeH2OdenInfo,iobs.H2Oden(idx,:),tbdd);
			[~,~,~,daybin_windDD(:,:,m,idir)] = sub_meanRangeVar(RangeWindInfo,iobs.wind(idx,:),tbdd);
			[~,~,~,daybin_latDD(:,:,m,idir)] = sub_meanRangeVar(RangeLatInfo,iobs.mlat(idx,:),tbdd);
			[~,~,~,daybin_lonDD(:,:,m,idir)] = sub_meanRangeVar(RangeLonInfo,iobs.mlon(idx,:),tbdd);
			[~,~,~,daybin_sstDD(:,:,m,idir)] = sub_meanRangeVar(RangeSSTInfo,iobs.sst(idx,:),tbdd);

			[~,~,~,daybin_H2OdenTSD(:,:,m,idir)] = sub_meanRangeVar(RangeH2OdenInfo,iobs.H2Oden(idx,:),ttbsd(:,TarIndDD));
			[~,~,~,daybin_windTSD(:,:,m,idir)] = sub_meanRangeVar(RangeWindInfo,iobs.wind(idx,:),ttbsd(:,TarIndDD));
			[~,~,~,daybin_latTSD(:,:,m,idir)] = sub_meanRangeVar(RangeLatInfo,iobs.mlat(idx,:),ttbsd(:,TarIndDD));
			[~,~,~,daybin_lonTSD(:,:,m,idir)] = sub_meanRangeVar(RangeLonInfo,iobs.mlon(idx,:),ttbsd(:,TarIndDD));
			[~,~,~,daybin_sstTSD(:,:,m,idir)] = sub_meanRangeVar(RangeSSTInfo,iobs.sst(idx,:),ttbsd(:,TarIndDD));

			[~,~,~,daybin_H2OdenRSD(:,:,m,idir)] = sub_meanRangeVar(RangeH2OdenInfo,iobs.H2Oden(idx,:),rtbsd(:,RefIndDD));
			[~,~,~,daybin_windRSD(:,:,m,idir)] = sub_meanRangeVar(RangeWindInfo,iobs.wind(idx,:),rtbsd(:,RefIndDD));
			[~,~,~,daybin_latRSD(:,:,m,idir)] = sub_meanRangeVar(RangeLatInfo,iobs.mlat(idx,:),rtbsd(:,RefIndDD));
			[~,~,~,daybin_lonRSD(:,:,m,idir)] = sub_meanRangeVar(RangeLonInfo,iobs.mlon(idx,:),rtbsd(:,RefIndDD));
			[~,~,~,daybin_sstRSD(:,:,m,idir)] = sub_meanRangeVar(RangeSSTInfo,iobs.sst(idx,:),rtbsd(:,RefIndDD));

			dayhist_H2Oden(:,m,idir) = histc(iobs.H2Oden(idx,:),BinH2Oden,1);
			dayhist_wind(:,m,idir) = histc(iobs.wind(idx,:),BinWind,1);
			dayhist_lat(:,m,idir) = histc(iobs.mlat(idx,:),BinLat,1);
			dayhist_lon(:,m,idir) = histc(iobs.mlon(idx,:),BinLon,1);
			dayhist_sst(:,m,idir) = histc(iobs.sst(idx,:),BinSST,1);
			
			% along-scan
            [crossnum,ncross,~,crosstb] = sub_uniqmean(iobs.mrncross(idx),iobs.mrtb(idx,:));
            [~,~,idxcross] = intersect(ncross,refncross);
            day_rcrossnum(idxcross,1,m,idir) = crossnum;
            day_rcrosstb(idxcross,:,m,idir) = crosstb;
            
            [~,ncross,~,crosstb] = sub_uniqmean(iobs.mrncross(idx),iobs.rsimTB(idx,:));
            [~,~,idxcross] = intersect(ncross,refncross);
            day_rcrosstbsim(idxcross,:,m,idir) = crosstb;
            
            [crossnum,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),iobs.mttb(idx,:));
            [~,~,idxcross] = intersect(ncross,tarncross);
            day_tcrossnum(idxcross,1,m,idir) = crossnum;
            day_tcrosstb(idxcross,:,m,idir) = crosstb;
            
            [~,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),iobs.tsimTB(idx,:));
            [~,~,idxcross] = intersect(ncross,tarncross);
            day_tcrosstbsim(idxcross,:,m,idir) = crosstb;
            
            [~,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),tbdd);
            [~,~,idxcross] = intersect(ncross,tarncross);
            day_crosstbdd(idxcross,:,m,idir) = crosstb;
            
            tbdifobs = (iobs.mttb(idx,TarIndDD)-iobs.mrtb(idx,RefIndDD));
            [~,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),tbdifobs);
            [~,~,idxcross] = intersect(ncross,tarncross);
            day_crosstbdifobs(idxcross,:,m,idir) = crosstb;
            
            ttbsd = (iobs.mttb(idx,:)-iobs.tsimTB(idx,:));
            [~,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),ttbsd);
            [~,~,idxcross] = intersect(ncross,tarncross);
            day_crossttbsd(idxcross,:,m,idir) = crosstb;
            
            rtbsd = (iobs.mrtb(idx,:)-iobs.rsimTB(idx,:));
            [~,ncross,~,crosstb] = sub_uniqmean(iobs.mrncross(idx),rtbsd);
            [~,~,idxcross] = intersect(ncross,refncross);
            day_crossrtbsd(idxcross,:,m,idir) = crosstb;
            
            % histogram
            hist1_rtb(:,:,idir) = hist1_rtb(:,:,idir)+histc(iobs.mrtb(idx,:),BinTB,1);h_rtbstd(:,:,idir) = h_rtbstd(:,:,idir)+histc(iobs.mrtbstd(idx,:),BinHist1TBstd,1);hist1_rsimTB(:,:,idir) = hist1_rsimTB(:,:,idir)+histc(iobs.rsimTB(idx,:),BinTB,1);
            hist1_ttb(:,:,idir) = hist1_ttb(:,:,idir)+histc(iobs.mttb(idx,:),BinTB,1);hist1_ttbstd(:,:,idir) = hist1_ttbstd(:,:,idir)+histc(iobs.mttbstd(idx,:),BinHist1TBstd,1);hist1_tsimTB(:,:,idir) = hist1_tsimTB(:,:,idir)+histc(iobs.tsimTB(idx,:),BinTB,1);
            hist1_tbdd(:,:,idir) = hist1_tbdd(:,:,idir)+histc(tbdd,BinTBDD,1);
            hist1_ttbsd(:,:,idir) = hist1_ttbsd(:,:,idir)+histc(ttbsd(:,TarIndDD),BinTBDD,1);
            for ichan = 1: length(TarIndDD) % tbdd
                x = iobs.mttb(idx,TarIndDD(ichan));
                y = tbdd(:,ichan);
                ihist2d  = sub_hist2(x,y,BinTB,BinTBDD);
                hist2_ttb_tbdd(:,:,ichan,idir) = hist2_ttb_tbdd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % ttbsd
                x = iobs.mttb(idx,TarIndDD(ichan));
                y = x - iobs.tsimTB(idx,TarIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinTB,BinTBDD);
                hist2_ttb_ttbsd(:,:,ichan,idir) = hist2_ttb_ttbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(RefIndDD) % rtbsd
                x = iobs.mrtb(idx,RefIndDD(ichan));
                y = x - iobs.rsimTB(idx,RefIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinTB,BinTBDD);
                hist2_rtb_rtbsd(:,:,ichan,idir) = hist2_rtb_rtbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % wind-tbdd
                x = iobs.wind(idx,:);
                y = tbdd(:,ichan);
                ihist2d  = sub_hist2(x,y,BinWind,BinTBDD);
                hist2_wind_tbdd(:,:,ichan,idir) = hist2_wind_tbdd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % wind-ttbsd
                x = iobs.wind(idx,:);
                y = iobs.mttb(idx,TarIndDD(ichan)) - iobs.tsimTB(idx,TarIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinWind,BinTBDD);
                hist2_wind_ttbsd(:,:,ichan,idir) = hist2_wind_ttbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(RefIndDD) % wind-rtbsd
                x = iobs.wind(idx,:);
                y = iobs.mrtb(idx,RefIndDD(ichan)) - iobs.rsimTB(idx,RefIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinWind,BinTBDD);
                hist2_wind_rtbsd(:,:,ichan,idir) = hist2_wind_rtbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % H2Oden-tbdd
                x = iobs.H2Oden(idx,:);
                y = tbdd(:,ichan);
                ihist2d  = sub_hist2(x,y,BinH2Oden,BinTBDD);
                hist2_H2Oden_tbdd(:,:,ichan,idir) = hist2_H2Oden_tbdd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % H2Oden-ttbsd
                x = iobs.H2Oden(idx,:);
                y = iobs.mttb(idx,TarIndDD(ichan)) - iobs.tsimTB(idx,TarIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinH2Oden,BinTBDD);
                hist2_H2Oden_ttbsd(:,:,ichan,idir) = hist2_H2Oden_ttbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(RefIndDD) % H2Oden-rtbsd
                x = iobs.H2Oden(idx,:);
                y = iobs.mrtb(idx,RefIndDD(ichan)) - iobs.rsimTB(idx,RefIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinH2Oden,BinTBDD);
                hist2_H2Oden_rtbsd(:,:,ichan,idir) = hist2_H2Oden_rtbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % sst-tbdd
                x = iobs.sst(idx,:);
                y = tbdd(:,ichan);
                ihist2d  = sub_hist2(x,y,BinSST,BinTBDD);
                hist2_sst_tbdd(:,:,ichan,idir) = hist2_sst_tbdd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(TarIndDD) % sst-ttbsd
                x = iobs.sst(idx,:);
                y = iobs.mttb(idx,TarIndDD(ichan)) - iobs.tsimTB(idx,TarIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinSST,BinTBDD);
                hist2_sst_ttbsd(:,:,ichan,idir) = hist2_sst_ttbsd(:,:,ichan,idir)+ihist2d;
            end
            for ichan = 1: length(RefIndDD) % sst-rtbsd
                x = iobs.sst(idx,:);
                y = iobs.mrtb(idx,RefIndDD(ichan)) - iobs.rsimTB(idx,RefIndDD(ichan));
                ihist2d  = sub_hist2(x,y,BinSST,BinTBDD);
                hist2_sst_rtbsd(:,:,ichan,idir) = hist2_sst_rtbsd(:,:,ichan,idir)+ihist2d;
            end
			
			% map
            [gridlat,gridlon,gridz,gridnum]  = sub_gridMapMean(GridMap,iobs.mlat(idx),iobs.mlon(idx),tbdd);
            map_tbdd(:,:,:,idir) = map_tbdd(:,:,:,idir)+bsxfun(@times,gridz,gridnum);
            map_gridnum(:,:,1,idir) = map_gridnum(:,:,1,idir)+gridnum;
            [gridlat,gridlon,gridz,gridnum]  = sub_gridMapMean(GridMap,iobs.mlat(idx),iobs.mlon(idx),iobs.mttb(idx,:));
            map_ttb(:,:,:,idir) = map_ttb(:,:,:,idir)+bsxfun(@times,gridz,gridnum);
            [gridlat,gridlon,gridz,gridnum]  = sub_gridMapMean(GridMap,iobs.mlat(idx),iobs.mlon(idx),ttbsd);
            map_ttbsd(:,:,:,idir) = map_ttbsd(:,:,:,idir)+bsxfun(@times,gridz,gridnum);
            [gridlat,gridlon,gridz,gridnum]  = sub_gridMapMean(GridMap,iobs.mlat(idx),iobs.mlon(idx),iobs.wind(idx,:));
            map_wind(:,:,:,idir) = map_wind(:,:,:,idir)+bsxfun(@times,gridz,gridnum);
            [gridlat,gridlon,gridz,gridnum]  = sub_gridMapMean(GridMap,iobs.mlat(idx),iobs.mlon(idx),iobs.H2Oden(idx,:));
            map_H2Oden(:,:,:,idir) = map_H2Oden(:,:,:,idir)+bsxfun(@times,gridz,gridnum);
			[gridlat,gridlon,gridz,gridnum]  = sub_gridMapMean(GridMap,iobs.mlat(idx),iobs.mlon(idx),iobs.sst(idx,:));
            map_sst(:,:,:,idir) = map_sst(:,:,:,idir)+bsxfun(@times,gridz,gridnum);
        end
        
        % TB range dependent DD
        tbdd = (iobs.mttb(:,TarIndDD)-iobs.tsimTB(:,TarIndDD))-(iobs.mrtb(:,RefIndDD)-iobs.rsimTB(:,RefIndDD));
        ttb = iobs.mttb(:,TarIndDD);
        for itb=1: size(MediTB,1)-1
            for ichan=1:length(TarIndDD)
                idx = MediTB(itb,TarIndDD(ichan))<=ttb(:,ichan) & ttb(:,ichan)<MediTB(itb+1,TarIndDD(ichan));
                if sum(idx)>0
                    [crossnum,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),tbdd(idx,ichan));
                    [~,~,idxcross] = intersect(ncross,tarncross);
                    tbrange_crosstbdd(idxcross,ichan,itb) = tbrange_crosstbdd(idxcross,ichan,itb) + crosstb.*crossnum;
                    tbrange_tcrossnum(idxcross,ichan,itb) = tbrange_tcrossnum(idxcross,ichan,itb) + crossnum;
                    [~,ncross,~,crosstb] = sub_uniqmean(iobs.mtncross(idx),iobs.mttb(idx,TarIndDD(ichan)));
                    [~,~,idxcross] = intersect(ncross,tarncross);
                    tbrange_crossttb(idxcross,ichan,itb) = tbrange_crossttb(idxcross,ichan,itb) + crosstb.*crossnum;
                end
            end
        end

        % display date
        fprintf([ndatestr(m,:),'\n'])
    end
    
    day_rtbsd = day_rtb - day_rsimTB;
    day_ttbsd = day_ttb - day_tsimTB;
    day_tbdd = day_ttbsd(TarIndDD,:,:)-day_rtbsd(RefIndDD,:,:);
    
    map_tbdd = bsxfun(@rdivide,map_tbdd,map_gridnum);
    map_ttb = bsxfun(@rdivide,map_ttb,map_gridnum);
    map_ttbsd = bsxfun(@rdivide,map_ttbsd,map_gridnum);
    map_wind = bsxfun(@rdivide,map_wind,map_gridnum);
    map_H2Oden = bsxfun(@rdivide,map_H2Oden,map_gridnum);
    map_sst = bsxfun(@rdivide,map_sst,map_gridnum);
    
    % all mean
    w = bsxfun(@rdivide,day_num,sum(day_num,2)); % weight of each day
    rp_tbdd = nansum(bsxfun(@times,day_tbdd,w),2);
    rp_rtbsd = nansum(bsxfun(@times,day_rtbsd,w),2);
    rp_ttbsd = nansum(bsxfun(@times,day_ttbsd,w),2);
    rp_rtb = nansum(bsxfun(@times,day_rtb,w),2);
    rp_ttb = nansum(bsxfun(@times,day_ttb,w),2);
    rp_difobs = rp_ttb(TarIndDD,:) - rp_rtb(RefIndDD,:);
    
    w = bsxfun(@rdivide,day_rcrossnum,sum(day_rcrossnum,3));
    rp_rcrosstb = nansum(bsxfun(@times,day_rcrosstb,w),3);
    rp_rcrosstbsim = nansum(bsxfun(@times,day_rcrosstbsim,w),3);
    rp_crossrtbsd = nansum(bsxfun(@times,day_crossrtbsd,w),3);
    
    w = bsxfun(@rdivide,day_tcrossnum,sum(day_tcrossnum,3));
    rp_tcrosstb = nansum(bsxfun(@times,day_tcrosstb,w),3);
    rp_tcrosstbsim = nansum(bsxfun(@times,day_tcrosstbsim,w),3);
    
    rp_crosstbdd = nansum(bsxfun(@times,day_crosstbdd,w),3);
    rp_crosstbdifobs = nansum(bsxfun(@times,day_crosstbdifobs,w),3);
    rp_crossttbsd = nansum(bsxfun(@times,day_crossttbsd,w),3);
    
    % filter of 3 sigma
    %     FilSigma = 3;
    %     idxfil = sub_filterIndSigma(FilSigma,rtbsd,ttbsd,tbdd,rtbstd,ttbstd);
    %     [rtb,rtbsd,rtbstd,rnum,rasc,rncross, ttb,ttbsd,ttbstd,tnum,tasc,tncross,lat,lon,time,tbdd] = ...
    %         sub_filterInd1D(~idxfil,rtb,rtbsd,rtbstd,rnum,rasc,rncross,ttb,ttbsd,ttbstd,tnum,tasc,tncross,lat,lon,time,tbdd);
    
    % DD Vs TB
    for ichan=1: length(TarIndDD)
        [p1,p2] = sub_fit2Dpoly1(BinTB,BinTBDD,hist2_ttb_tbdd(:,:,ichan,1));
        fitp_tbdd(ichan,1)=p1;
        fitp_tbdd(ichan,2)=p2;
    end
    % ttbsd Vs TB
    for ichan=1: length(TarIndDD)
        [p1,p2] = sub_fit2Dpoly1(BinTB,BinTBDD,hist2_ttb_ttbsd(:,:,ichan,1));
        fitp_ttbsd(ichan,1)=p1;
        fitp_ttbsd(ichan,2)=p2;
    end
    % median 50 percentile TB
    cdf_ttb = cumsum(hist1_ttb,1);
    cdf_ttb = bsxfun(@rdivide,cdf_ttb,cdf_ttb(end,:,:));
    [n1,n2,n3] = size(cdf_ttb);
    cdf_ttb = reshape(cdf_ttb,n1,[]);
    [~,idx] = min(abs(cdf_ttb-0.5),[],1);
    medi_tb = reshape(BinTB(idx),n2,n3);
    % tb-range cross DD
    tbrange_crosstbdd = tbrange_crosstbdd./tbrange_tcrossnum;
    tbrange_crossttb = tbrange_crossttb./tbrange_tcrossnum;
    % outpath
    outpath = [PathOut,'grid',num2str(ColGrid(ngrid)),'\'];
    if ~exist(outpath,'dir')
        mkdir(outpath) % create directory if not existing
    end
    outfile = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename,'-',CodeFun,'-2cal-grid',num2str(ColGrid(ngrid)),'-',DateBegin,'-',DateEnd,'.mat'];
    save([outpath,outfile],'rp_rtb','rp_rtbsd','rp_ttb','rp_ttbsd','rp_tbdd','rp_difobs','fitp_tbdd','fitp_ttbsd','medi_tb')
    if OptXcoldwarm==1
        outfile = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename,'-',CodeFun,'-2cal-grid',num2str(ColGrid(ngrid)),'-xcoldwarm-',DateBegin,'-',DateEnd,'.mat'];
        save([outpath,outfile],'hist2_ttb_tbdd','hist2_rtb_rtbsd')%,...
    end
%     return
    
    %% plot setting
    
    % setting common strings
    strsavenameX = [TarRadDataInfo.filename,'-',RefRadDataInfo.filename];
    strX = [TarRadDataInfo.rad,' ',TarRadDataInfo.platform,'-',RefRadDataInfo.rad,' ',RefRadDataInfo.platform];
    strX = strrep(strX,' Uni','');
    strRef = [RefRadDataInfo.rad,' ',RefRadDataInfo.platform];
    strRef = strrep(strRef,' Uni','');
    strTar = [TarRadDataInfo.rad,' ',TarRadDataInfo.platform];
    strTar = strrep(strTar,' Uni','');
    
	%% debug plot
    % scan position
	% common setting
	plotstr.xlabel='Scan Position';plotstr.outpath=outpath;
    % Tar tb
    ncross = tarncross; crosstb=rp_tcrosstb(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr;
    plotstr.ylabel=[strTar,' TB (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-ttb-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB DD
    ncross = tarncross; crosstb=rp_crosstbdd(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB obs-obs
    ncross = tarncross; crosstb=rp_crosstbdifobs(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB Obs-Obs (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdifobs-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TTBSD
    ncross = tarncross; crosstb=rp_crossttbsd(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr;plotstr.xlabel='Scan Position';plotstr.outpath=outpath;
    plotstr.ylabel=[strTar,' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-ttbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % RTBSD
    ncross = refncross; crosstb=rp_crossrtbsd(:,:,1,1);
    plotstr.StrChan=RefRadSpc.chanstr;
    plotstr.ylabel=[strRef,' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-rtbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB DD asc/des
    ncross = tarncross; crosstb=squeeze(rp_crosstbdd(:,:,1,2:3));
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdd-ascdes-',DateBegin,'-',DateEnd];plotstr.legend={'Asc','Des'};
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB DD tbrange
    temp = squeeze(sum(tbrange_crossttb.*tbrange_tcrossnum,1)./sum(tbrange_tcrossnum,1));temp = sub_num2cellstr(round(temp));temp=strcat('TB_{mean}=',temp);
    ncross = tarncross; crosstb=bsxfun(@minus,tbrange_crosstbdd,nanmean(tbrange_crosstbdd,1));
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB DD variability (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdd-tbrange-',DateBegin,'-',DateEnd];plotstr.legend=temp;
    sub_plotCrossSubChan(ncross,crosstb,plotstr);  
	%% 
	
	% basic statistics
    % hist1 DD 
    figure(1)
    plot(BinTBDD,hist1_tbdd(:,:,1));
    xlabel([strX,' TB DD (K)']);ylabel('No.');legend(TarRadSpc.chanstr{TarIndDD});legend boxoff
    print(1,'-dpng','-r300',[outpath,strsavenameX,'-',CodeFun,'-hist1-tbdd','-',DateBegin,'-',DateEnd])
    close 1
    % hist1 SD 
    figure(1)
    plot(BinTBDD,hist1_ttbsd(:,:,1));
    xlabel([TarRadDataInfo.rad,' TB SD (K)']);ylabel('No.');legend(TarRadSpc.chanstr{TarIndDD});legend boxoff
    print(1,'-dpng','-r300',[outpath,strsavenameX,'-',CodeFun,'-hist1-tbsd','-',DateBegin,'-',DateEnd])
    close 1
    
    % scan position
	% common setting
	plotstr.xlabel='Scan Position';plotstr.outpath=outpath;
    % Tar tb
    ncross = tarncross; crosstb=rp_tcrosstb(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr;
    plotstr.ylabel=[strTar,' TB (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-ttb-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB DD
    ncross = tarncross; crosstb=rp_crosstbdd(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB obs-obs
    ncross = tarncross; crosstb=rp_crosstbdifobs(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB Obs-Obs (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdifobs-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TTBSD
    ncross = tarncross; crosstb=rp_crossttbsd(:,:,1,1);
    plotstr.StrChan=TarRadSpc.chanstr;plotstr.xlabel='Scan Position';plotstr.outpath=outpath;
    plotstr.ylabel=[strTar,' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-ttbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % RTBSD
    ncross = refncross; crosstb=rp_crossrtbsd(:,:,1,1);
    plotstr.StrChan=RefRadSpc.chanstr;
    plotstr.ylabel=[strRef,' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-rtbsd-',DateBegin,'-',DateEnd];
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB DD asc/des
    ncross = tarncross; crosstb=squeeze(rp_crosstbdd(:,:,1,2:3));
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdd-ascdes-',DateBegin,'-',DateEnd];plotstr.legend={'Asc','Des'};
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    % TB DD tbrange
    temp = squeeze(sum(tbrange_crossttb.*tbrange_tcrossnum,1)./sum(tbrange_tcrossnum,1));temp = sub_num2cellstr(round(temp));temp=strcat('TB_{mean}=',temp);
    ncross = tarncross; crosstb=bsxfun(@minus,tbrange_crosstbdd,nanmean(tbrange_crosstbdd,1));
    plotstr.StrChan=TarRadSpc.chanstr(TarIndDD);
    plotstr.ylabel=[strX,' TB DD variability (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-scan-subchan-tbdd-tbrange-',DateBegin,'-',DateEnd];plotstr.legend=temp;
    sub_plotCrossSubChan(ncross,crosstb,plotstr);
    
    % time series mean
    x = datenum(ndatestr,'yyyymmdd');
	% day_tbdd
    y = day_tbdd(:,:,1); y=y';
    tsplotstr.Rad=strX; tsplotstr.datebegin=DateBegin; tsplotstr.dateend=DateEnd; 
    tsplotstr.outpath=outpath; tsplotstr.StrChan=TarRadSpc.chanstr(TarIndDD);tsplotstr.ylabel=[strX,' TB DD']; tsplotstr.savename=[strsavenameX,'-',CodeFun,'-time-tbdd-',DateBegin,'-',DateEnd];plotstr.datetick='mmm';
    sub_plottimeseries(x,y,tsplotstr)
	% day_ttb
    y = day_ttb(:,:,1); y=y';
    tsplotstr.Rad=strX; tsplotstr.datebegin=DateBegin; tsplotstr.dateend=DateEnd; 
    tsplotstr.outpath=outpath; tsplotstr.StrChan=TarRadSpc.chanstr;tsplotstr.ylabel=[strTar,' TB']; tsplotstr.savename=[strsavenameX,'-',CodeFun,'-time-ttb-',DateBegin,'-',DateEnd];plotstr.datetick='mmm';
    sub_plottimeseries(x,y,tsplotstr)
	% day_ttbsd
    y = day_ttbsd(:,:,1); y=y';
    tsplotstr.Rad=strX; tsplotstr.datebegin=DateBegin; tsplotstr.dateend=DateEnd; 
    tsplotstr.outpath=outpath; tsplotstr.StrChan=TarRadSpc.chanstr;tsplotstr.ylabel=[strTar,' TB SD']; tsplotstr.savename=[strsavenameX,'-',CodeFun,'-time-ttbsd-',DateBegin,'-',DateEnd];plotstr.datetick='mmm';
    sub_plottimeseries(x,y,tsplotstr)
	% day_H2Oden
    y = day_H2Oden(:,:,1); y=y';
    tsplotstr.Rad=strX; tsplotstr.datebegin=DateBegin; tsplotstr.dateend=DateEnd; 
    tsplotstr.outpath=outpath; tsplotstr.StrChan={''};tsplotstr.ylabel=[strX,' Water Vapor (g/m^3)']; tsplotstr.savename=[strsavenameX,'-',CodeFun,'-time-H2Oden-',DateBegin,'-',DateEnd];plotstr.datetick='mmm';
    sub_plottimeseries(x,y,tsplotstr)
	% day_wind
    y = day_wind(:,:,1); y=y';
    tsplotstr.Rad=strX; tsplotstr.datebegin=DateBegin; tsplotstr.dateend=DateEnd; 
    tsplotstr.outpath=outpath; tsplotstr.StrChan={''};tsplotstr.ylabel=[strX,' Wind Speed (m/s)']; tsplotstr.savename=[strsavenameX,'-',CodeFun,'-time-wind-',DateBegin,'-',DateEnd];plotstr.datetick='mmm';
    sub_plottimeseries(x,y,tsplotstr)
	% day_sst
    y = day_sst(:,:,1); y=y';
    tsplotstr.Rad=strX; tsplotstr.datebegin=DateBegin; tsplotstr.dateend=DateEnd; 
    tsplotstr.outpath=outpath; tsplotstr.StrChan={''};tsplotstr.ylabel=[strX,' SST (K)']; tsplotstr.savename=[strsavenameX,'-',CodeFun,'-time-sst-',DateBegin,'-',DateEnd];plotstr.datetick='mmm';
    sub_plottimeseries(x,y,tsplotstr)
    
    % time series FFT power spectra
	x = datenum(ndatestr,'yyyymmdd');plotstr.time_xlabel='Time';
	% day_tbdd
    y = day_tbdd(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFTpowerSpectra(x1,y1); fT = 1./f*length(x1);
    plotstr.time_ylabel=[strX,' TB DD'];plotstr.time_legend=TarRadSpc.chanstr(TarIndDD);plotstr.time_datetick='mmm';plotstr.freq_xlabel='Day';plotstr.freq_ylabel='Power Spectra';plotstr.freq_legend=TarRadSpc.chanstr(TarIndDD);plotstr.savename=[strsavenameX,'-',CodeFun,'-timeFFT-tbdd-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    math_plotFFTdomain2(x1,y1,fT,ps,plotstr)
	% day_ttb
    y = day_ttb(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFTpowerSpectra(x1,y1); fT = 1./f*length(x1);
    plotstr.time_ylabel=[strX,' TB'];plotstr.time_legend=TarRadSpc.chanstr;plotstr.time_datetick='mmm';plotstr.freq_xlabel='Day';plotstr.freq_ylabel='Power Spectra';plotstr.freq_legend=TarRadSpc.chanstr;plotstr.savename=[strsavenameX,'-',CodeFun,'-timeFFT-ttb-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    math_plotFFTdomain2(x1,y1,fT,ps,plotstr)
	% day_ttbsd
    y = day_ttbsd(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFTpowerSpectra(x1,y1); fT = 1./f*length(x1);
    plotstr.time_ylabel=[strX,' TB SD'];plotstr.time_legend=TarRadSpc.chanstr;plotstr.time_datetick='mmm';plotstr.freq_xlabel='Day';plotstr.freq_ylabel='Power Spectra';plotstr.freq_legend=TarRadSpc.chanstr;plotstr.savename=[strsavenameX,'-',CodeFun,'-timeFFT-ttbsd-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    math_plotFFTdomain2(x1,y1,fT,ps,plotstr)
	% day_H2Oden
    y = day_H2Oden(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFTpowerSpectra(x1,y1); fT = 1./f*length(x1);
    [f,ps] = math_FFTpowerSpectra(x,yi); fT = 1./f*length(x);
    plotstr.time_ylabel=[strX,' Water Vapor (g/m^3)'];plotstr.time_legend={''};plotstr.time_datetick='mmm';plotstr.freq_xlabel='Day';plotstr.freq_ylabel='Power Spectra';plotstr.freq_legend={''};plotstr.savename=[strsavenameX,'-',CodeFun,'-timeFFT-H2Oden-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    math_plotFFTdomain2(x1,y1,fT,ps,plotstr)
	% day_wind
    y = day_wind(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFTpowerSpectra(x1,y1); fT = 1./f*length(x1);
    [f,ps] = math_FFTpowerSpectra(x,yi); fT = 1./f*length(x);
    plotstr.time_ylabel=[strX,' Wind Speed (m/s)'];plotstr.time_legend={''};plotstr.time_datetick='mmm';plotstr.freq_xlabel='Day';plotstr.freq_ylabel='Power Spectra';plotstr.freq_legend={''};plotstr.savename=[strsavenameX,'-',CodeFun,'-timeFFT-wind-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    math_plotFFTdomain2(x1,y1,fT,ps,plotstr)
	% day_sst
    y = day_sst(:,:,1); y=y';
    yi = math_interpNaN(x,y);
    idx = ~isnan(sum(yi,2));x1=x(idx);y1=yi(idx,:);
    [f,ps] = math_FFTpowerSpectra(x1,y1); fT = 1./f*length(x1);
    [f,ps] = math_FFTpowerSpectra(x,yi); fT = 1./f*length(x);
    plotstr.time_ylabel=[strX,' SST'];plotstr.time_legend={''};plotstr.time_datetick='mmm';plotstr.freq_xlabel='Day';plotstr.freq_ylabel='Power Spectra';plotstr.freq_legend={''};plotstr.savename=[strsavenameX,'-',CodeFun,'-timeFFT-sst-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    math_plotFFTdomain2(x1,y1,fT,ps,plotstr)

    % day bin plot
    % common plot setting
	x=1:numday;plotstr.xlabel = ['Time Series'];plotstr.titlecolorbar=['(K)'];plotstr.outpath=outpath;plotstr.caxis.opt=1;plotstr.caxis.value=[-3,3];plotstr.title.opt=1;plotstr.colors.opt=1;temp=colormap;temp=temp(1:3:end,:);plotstr.colors.value=temp;
    % daybin_H2OdenDD
    for ichan=1: length(TarIndDD)
        y=BinH2Oden;z=squeeze(daybin_H2OdenDD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Water Vapor (g/m^3)'];plotstr.title.value=[strX,' H2Oden-DD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-DDH2Oden-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_windDD
    for ichan=1: length(TarIndDD)
        y=BinWind;z=squeeze(daybin_windDD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Wind Speed (m/s)'];plotstr.title.value=[strX,' Wind-DD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-DDwind-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_latDD
    for ichan=1: length(TarIndDD)
        y=BinLat;z=squeeze(daybin_latDD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Latitude'];plotstr.title.value=[strX,' Latitude-DD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-DDlat-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_lonDD
    for ichan=1: length(TarIndDD)
        y=BinLon;z=squeeze(daybin_lonDD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Longitude'];plotstr.title.value=[strX,' Longitude-DD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-DDlon-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_sstDD
    for ichan=1: length(TarIndDD)
        y=BinSST;z=squeeze(daybin_sstDD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['SST (K)'];plotstr.title.value=[strX,' SST-DD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-DDsst-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
		
	% daybin_H2OdenTSD
    for ichan=1: length(TarIndDD)
        y=BinH2Oden;z=squeeze(daybin_H2OdenTSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Water Vapor (g/m^3)'];plotstr.title.value=[TarRadDataInfo.rad,' H2Oden-SD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-TSDH2Oden-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_windTSD
    for ichan=1: length(TarIndDD)
        y=BinWind;z=squeeze(daybin_windTSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Wind Speed (m/s)'];plotstr.title.value=[TarRadDataInfo.rad,' Wind-SD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-TSDwind-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_latTSD
    for ichan=1: length(TarIndDD)
        y=BinLat;z=squeeze(daybin_latTSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Latitude'];plotstr.title.value=[TarRadDataInfo.rad,' Latitude-SD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-TSDlat-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_lonTSD
    for ichan=1: length(TarIndDD)
        y=BinLon;z=squeeze(daybin_lonTSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Longitude'];plotstr.title.value=[TarRadDataInfo.rad,' Longitude-SD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-TSDlon-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_sstTSD
    for ichan=1: length(TarIndDD)
        y=BinSST;z=squeeze(daybin_sstTSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['SST (K)'];plotstr.title.value=[TarRadDataInfo.rad,' SST-SD Variability ',TarRadSpc.chanstr{TarIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-TSDsst-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end

	% daybin_H2OdenRSD
    for ichan=1: length(RefIndDD)
        y=BinH2Oden;z=squeeze(daybin_H2OdenRSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Water Vapor (g/m^3)'];plotstr.title.value=[RefRadDataInfo.rad,' H2Oden-SD Variability ',RefRadSpc.chanstr{RefIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-RSDH2Oden-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_windRSD
    for ichan=1: length(RefIndDD)
        y=BinWind;z=squeeze(daybin_windRSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Wind Speed (m/s)'];plotstr.title.value=[RefRadDataInfo.rad,' Wind-SD Variability ',RefRadSpc.chanstr{RefIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-RSDwind-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_latRSD
    for ichan=1: length(RefIndDD)
        y=BinLat;z=squeeze(daybin_latRSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Latitude'];plotstr.title.value=[RefRadDataInfo.rad,' Latitude-SD Variability ',RefRadSpc.chanstr{RefIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-RSDlat-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_lonRSD
    for ichan=1: length(RefIndDD)
        y=BinLon;z=squeeze(daybin_lonRSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['Longitude'];plotstr.title.value=[RefRadDataInfo.rad,' Longitude-SD Variability ',RefRadSpc.chanstr{RefIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-RSDlon-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
	% daybin_sstRSD
    for ichan=1: length(RefIndDD)
        y=BinSST;z=squeeze(daybin_sstRSD(:,ichan,:,1));z(z==0)=NaN;
		zmean = nanmean(z(:));z = z-nanmean(z(:));
        plotstr.ylabel=['SST (K)'];plotstr.title.value=[RefRadDataInfo.rad,' SST-SD Variability ',RefRadSpc.chanstr{RefIndDD(ichan)},sprintf(' Mean=%0.1f',zmean)];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-RSDsst-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirect2D(x,y,z,plotstr)
    end
    
    % hist2 
	% common plot setting
	plotstr.titlecolorbar='No.';plotstr.outpath=outpath;
    % hist2_ttb_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = [strTar,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB (K)'];plotstr.ylabel=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-tb-tbdd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTB,BinTBDD,hist2_ttb_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_ttb_ttbsd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = [strTar,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB (K)'];plotstr.ylabel=[TarRadDataInfo.rad,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-tb-ttbsd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTB,BinTBDD,hist2_ttb_ttbsd(:,:,ichan,1),plotstr)
    end
    % hist2_rtb_rtbsd for each channel
    for ichan=1: length(RefIndDD)
        plotstr.xlabel = [strRef,' ',RefRadSpc.chanstr{RefIndDD(ichan)},' TB (K)'];plotstr.ylabel=[RefRadDataInfo.rad,' ',RefRadSpc.chanstr{RefIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-tb-rtbsd-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinTB,BinTBDD,hist2_rtb_rtbsd(:,:,ichan,1),plotstr)
    end
    % hist2_wind_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['Wind Speed (m/s)'];plotstr.ylabel=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-wind-tbdd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinWind,BinTBDD,hist2_wind_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_wind_ttbsd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['Wind Speed (m/s)'];plotstr.ylabel=[TarRadDataInfo.rad,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-wind-ttbsd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinWind,BinTBDD,hist2_wind_ttbsd(:,:,ichan,1),plotstr)
    end
    % hist2_wind_rtbsd for each channel
    for ichan=1: length(RefIndDD)
        plotstr.xlabel = ['Wind Speed (m/s)'];plotstr.ylabel=[RefRadDataInfo.rad,' ',RefRadSpc.chanstr{RefIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-wind-rtbsd-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinWind,BinTBDD,hist2_wind_rtbsd(:,:,ichan,1),plotstr)
    end
    % hist2_H2Oden_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['Water Vapor (g/m^3)'];plotstr.ylabel=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-H2Oden-tbdd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinH2Oden,BinTBDD,hist2_H2Oden_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_H2Oden_ttbsd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['Water Vapor (g/m^3)'];plotstr.ylabel=[TarRadDataInfo.rad,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-H2Oden-ttbsd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinH2Oden,BinTBDD,hist2_H2Oden_ttbsd(:,:,ichan,1),plotstr)
    end
    % hist2_H2Oden_rtbsd for each channel
    for ichan=1: length(RefIndDD)
        plotstr.xlabel = ['Water Vapor (g/m^3)'];plotstr.ylabel=[RefRadDataInfo.rad,' ',RefRadSpc.chanstr{RefIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-H2Oden-rtbsd-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinH2Oden,BinTBDD,hist2_H2Oden_rtbsd(:,:,ichan,1),plotstr)
    end
    % hist2_sst_tbdd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['SST (K)'];plotstr.ylabel=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-sst-tbdd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinSST,BinTBDD,hist2_sst_tbdd(:,:,ichan,1),plotstr)
    end
    % hist2_sst_ttbsd for each channel
    for ichan=1: length(TarIndDD)
        plotstr.xlabel = ['SST (K)'];plotstr.ylabel=[TarRadDataInfo.rad,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-sst-ttbsd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinSST,BinTBDD,hist2_sst_ttbsd(:,:,ichan,1),plotstr)
    end
    % hist2_sst_rtbsd for each channel
    for ichan=1: length(RefIndDD)
        plotstr.xlabel = ['SST (K)'];plotstr.ylabel=[RefRadDataInfo.rad,' ',RefRadSpc.chanstr{RefIndDD(ichan)},' TB SD (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-hist2-sst-rtbsd-',RefRadSpc.chanstr{RefIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotDirectHist2DFit(BinSST,BinTBDD,hist2_sst_rtbsd(:,:,ichan,1),plotstr)
    end
    
    % temporal-parameter 2D colorful plot
	x=1:numday;plotstr.xlabel = ['Time Series'];
	plotstr.caxis.opt=0;plotstr.title.opt=1;plotstr.title.value=strX;plotstr.colors.opt=0;plotstr.titlecolorbar='No.';
    % dayhist_H2Oden
    plotstr.ylabel=['Water Vapor (g/m^3)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-hist-H2Oden-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    y=BinH2Oden;z=dayhist_H2Oden(:,:,1);z(z==0)=NaN;
    sub_plotDirect2D(x,y,z,plotstr)
    % dayhist_wind
    plotstr.ylabel=['Wind Speed (m/s)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-hist-wind-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    y=BinWind;z=dayhist_wind(:,:,1);z(z==0)=NaN;
    sub_plotDirect2D(x,y,z,plotstr)
    % dayhist_lat
    plotstr.ylabel=['Latitude'];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-hist-Lat-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    y=BinLat;z=dayhist_lat(:,:,1);z(z==0)=NaN;
    sub_plotDirect2D(x,y,z,plotstr)
    % dayhist_lon
    plotstr.ylabel=['Longitude'];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-hist-Lon-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    y=BinLon;z=dayhist_lon(:,:,1);z(z==0)=NaN;
    sub_plotDirect2D(x,y,z,plotstr)
    % dayhist_sst
    plotstr.ylabel=['SST (K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-temporal2D-hist-SST-',DateBegin,'-',DateEnd];plotstr.outpath=outpath;
    y=BinSST;z=dayhist_sst(:,:,1);z(z==0)=NaN;
    sub_plotDirect2D(x,y,z,plotstr)
	
    % map
	% common setting
    plotstr.caxis.opt=1;plotstr.caxis.value=[-3,3];
    % map of DD
    for ichan=1: length(TarIndDD) % map of DD
        z = map_tbdd(:,:,ichan,1);zmean = nanmean(z(:));z=z-zmean;
        plotstr.titlecolorbar='(K)';plotstr.title=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD Variability (Mean ',sprintf('%0.1f',zmean),'K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-tbdd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    end
    if NumDir==3
    for ichan=1: length(TarIndDD) % map of DD-asc
        z = map_tbdd(:,:,ichan,2);zmean = nanmean(z(:));z=z-zmean;
        plotstr.titlecolorbar='(K)';plotstr.title=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD Variability Asc (Mean ',sprintf('%0.1f',zmean),'K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-tbdd-asc-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    end
    for ichan=1: length(TarIndDD) % map of DD-des
        z = map_tbdd(:,:,ichan,3);zmean = nanmean(z(:));z=z-zmean;
        plotstr.titlecolorbar='(K)';plotstr.title=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB DD Variability Des (Mean ',sprintf('%0.1f',zmean),'K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-tbdd-des-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    end
    end
    for ichan=1: length(TarIndDD) % map of ttbsd
        z = map_ttbsd(:,:,TarIndDD(ichan),1);zmean = nanmean(z(:));z=z-zmean;
        plotstr.titlecolorbar='(K)';plotstr.title=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB SD Variability (Mean ',sprintf('%0.1f',zmean),'K)'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-ttbsd-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    end
	% common setting
	plotstr.caxis.opt=0;
	% map of TB
    for ichan=1: length(TarIndDD) 
        z = map_ttb(:,:,TarIndDD(ichan),1);
        plotstr.titlecolorbar='(K)';plotstr.title=[strX,' ',TarRadSpc.chanstr{TarIndDD(ichan)},' TB'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-tb-',TarRadSpc.chanstr{TarIndDD(ichan)},'-',DateBegin,'-',DateEnd];
        sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    end
    % map of gridnum
    z = map_gridnum(:,:,1,1);
    idx = z==0; z(idx)=NaN;
    plotstr.titlecolorbar='No.';plotstr.title=[strX,' Collocation No.'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-gridNo-',DateBegin,'-',DateEnd];
    sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    % map of wind
    z = map_wind(:,:,1,1);
    idx = z==0; z(idx)=NaN;
    plotstr.titlecolorbar='(m/s)';plotstr.title=[strX,' Wind Speed'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-phy-wind-',DateBegin,'-',DateEnd];
    sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    % map of H2Oden
    z = map_H2Oden(:,:,1,1);
    idx = z==0; z(idx)=NaN;
    plotstr.titlecolorbar='(g/m^3)';plotstr.title=[strX,' Water Vapor'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-phy-H2O-',DateBegin,'-',DateEnd];
    sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
    % map of sst
    z = map_sst(:,:,1,1);
    idx = z==0; z(idx)=NaN;
    plotstr.titlecolorbar='(K)';plotstr.title=[strX,' SST'];plotstr.savename=[strsavenameX,'-',CodeFun,'-map-phy-sst-',DateBegin,'-',DateEnd];
    sub_plotMap2DClatlon(gridlat,gridlon,z,plotstr)
end
return

