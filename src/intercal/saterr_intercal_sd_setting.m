% setting filters and variables for single-difference intercalibration 


% =======================================================
% setting
% =======================================================

% ---------------------------
% radiomter specification
% ---------------------------
tar_num_chan = 2;
num_crosstrack = 30;

tar_rad.spacecraft = upper(Rad.spacecraft);
tar_rad.sensor = upper(Rad.sensor);
tar_rad.chanfreq = Rad.chanfreq;
tar_rad.chanpol = Rad.chanpol;
tar_rad.chan_freq_nominal = Rad.chan_freq_nominal;
tar_rad.chanind = 1: Rad.tar_num_chan;
tar_rad.num_crosstrack = Rad.num_crosstrack(1);

tar_rad.chanfreq = tar_rad.chanfreq(1: tar_num_chan);
tar_rad.chanpol = tar_rad.chanpol(1: tar_num_chan);
tar_rad.chan_freq_nominal = tar_rad.chan_freq_nominal(1: tar_num_chan);
tar_rad.chanind = tar_rad.chanind(1: tar_num_chan);

TarScanpos = 1: num_crosstrack;

% ---------------------------
% radiomter specification
% ---------------------------
% outpath
outpath = [pathout,'/','1data'];
if ~exist(outpath,'dir')
    mkdir(outpath) % create directory if not existing
end

% ---------------------------
% filter setting
% ---------------------------
% filter of tb range
FilterCal.tbrange.onoff=1;
if FilterCal.tbrange.onoff == 1
    FilterCal.tbrange.range=[0 350]; % range of tb, FilterSet.tbrange(1)<tb & tb<FilterSet.tbrange(2)
end

% filter of obs - sim
FilterCal.tar_tb_sd.onoff = 1;
FilterCal.tar_tb_sd.range = [-15,15];

% filter with overall standard deviation (will used output from preprocess)
FilterCal.sigma.tar_tb_sd.onoff = 1; % 0=off,1=turn on;
if FilterCal.sigma.tar_tb_sd.onoff == 1
    FilterCal.sigma.tar_tb_sd.n = 3; % e.g. n_ttb_sd=3 denotes 3 sigma filtering
end

FilterCal.landfilter.onoff = 1;

% ---------------------------
% other calibration settings
% ---------------------------
% Bins
Stat.BinTB = 80:0.4:310;
Stat.BinTBSD = -15:0.1:15;

% ---------------------------
% hist2
% ---------------------------
Stat.Bin_Hist2_TBSD = -10:0.1:10;
Stat.Bin_Hist2_TB = 100:0.4:310;


% direction of orbit
NumOrbitNode = 1; % D3=[both/asc/des],D1=[both]
% grid resolution of map
GridMap = 1;

% collocation oscillation period according to prediction model
% PeriodOscModel = orbit_period2sat(RefRadSpc.orbit.altitude,RefRadSpc.orbit.inclination,TarRadSpc.orbit.altitude,TarRadSpc.orbit.inclination);
PeriodOscModel = 1;

% =======================================================
% setting variables
% =======================================================

% determine the time interval
ndate = datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1;
ndatestr = datestr(ndate,'yyyymmdd');
% ndate(3) = []; % remove 20190902 that has different TDR/SDR
numday = size(ndatestr,1);

% land/sea TB
n1 = length(Stat.BinTB);n2=tar_num_chan;
hist1landsea_tar_tb_obs=zeros(n1,n2); % all TB over land and sea except w/o bad value
hist1landsea_tar_tb_sim=zeros(n1,n2);
hist1sea_tar_tb_obs=zeros(n1,n2); % all TB over the sea except w/o bad value
hist1sea_tar_tb_sim=zeros(n1,n2);

% O-B stats
n1 = length(Stat.BinTB);n2=tar_num_chan;n3=NumOrbitNode;
hist1_tar_tb_obs=zeros(n1,n2,n3); % TB after fitlering including cloud
hist1_tar_tb_sim=zeros(n1,n2,n3);

n1 = length(Stat.BinTBSD);n2=tar_num_chan;n3=NumOrbitNode;
hist1_tar_tb_sd=zeros(n1,n2,n3);

n1 = length(Stat.Bin_Hist2_TBSD);n2=length(Stat.Bin_Hist2_TB);n3=tar_num_chan;n4=NumOrbitNode; % [DD,TB,channel,dir]
hist2_tb_tbsd = single(zeros(n1,n2,n3,n4));

% along scan
cross_tar_tb_sd = zeros(num_crosstrack,tar_num_chan,NumOrbitNode);
cross_tar_tb_obs = zeros(num_crosstrack,tar_num_chan,NumOrbitNode);
cross_tar_tb_sim = zeros(num_crosstrack,tar_num_chan,NumOrbitNode);
cross_tar_num = zeros(num_crosstrack,1,NumOrbitNode);
cross_tar_tb_sd2 = zeros(num_crosstrack,tar_num_chan);

% daily
n1=tar_num_chan;n2=size(ndatestr,1);n3=NumOrbitNode;
day_num = zeros(1,n2); % [n1,n2]

day_tar_tb_obs = zeros(n1,n2);
day_tar_tb_sim = zeros(n1,n2);
day_tar_tb_sd = zeros(n1,n2);
day_tar_tb_sd_std = zeros(n1,n2);

% map
GridLat = -90:90;
GridLon = -180:179;
n1=numel(GridLat);n2=numel(GridLon);n4=NumOrbitNode;
map_tar_gridnum = zeros(n1,n2,1,n4);
map_tar_tb_sd = zeros(n1,n2,tar_num_chan,n4);
