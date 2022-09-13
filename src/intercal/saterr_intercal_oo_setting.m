% setting filters and variables for single-difference intercalibration 


% =======================================================
% Input
% =======================================================

% ---------------------------
% setting target and reference satellites
% ---------------------------
tar_datainfo.spacecraft = 'metop-c';
tar_datainfo.sensor = 'mhs';
tar_datainfo.path = '/data/jyang/sounder/metop-c/mhs';
tar_datainfo.fileID = '*MHSX.M3*';

ref_datainfo.spacecraft = 'metop-a';
ref_datainfo.sensor = 'mhs';
ref_datainfo.path = '/data/jyang/sounder/metop-a/mhs';
ref_datainfo.fileID = '*MHSX.M2*';

datebegin = '20190101';
dateend = '20200102';

% ---------------------------
% setting pathout
% ---------------------------
pathout = '/data/jyang/task_output/saterr';

% ---------------------------
% land-ocean mask
% ---------------------------
load('LandMask_ERA5_June_0.25degree.mat') % LonMask ranging [0,360)
LonMask = double(LonMask);
LatMask = double(LatMask);
LandMask = double(LandMask);

tar_sensor = rad_spc_set(tar_datainfo.sensor);

ref_sensor = rad_spc_set(ref_datainfo.sensor);

% ---------------------------
% setting index of match-up channels
% ---------------------------
match_tar_chanind = 1: 5;
match_ref_chanind = 1: 5;

match_num_chan = length(match_tar_chanind);

tar_sensor.chan = tar_sensor.chan(match_tar_chanind);
tar_sensor.chanrep = tar_sensor.chan(match_tar_chanind);
tar_sensor.chanstr = tar_sensor.chanstr(match_tar_chanind);
tar_sensor.chan_freq_nominal = tar_sensor.chan_freq_nominal(match_tar_chanind);
tar_sensor.chanpol = tar_sensor.chanpol(match_tar_chanind);
tar_sensor.chanind = tar_sensor.chanind(match_tar_chanind);
tar_sensor.numchan = match_num_chan;

ref_sensor.chan = ref_sensor.chan(match_ref_chanind);
ref_sensor.chanrep = ref_sensor.chan(match_ref_chanind);
ref_sensor.chanstr = ref_sensor.chanstr(match_ref_chanind);
ref_sensor.chan_freq_nominal = ref_sensor.chan_freq_nominal(match_ref_chanind);
ref_sensor.chanpol = ref_sensor.chanpol(match_ref_chanind);
ref_sensor.chanind = ref_sensor.chanind(match_ref_chanind);
ref_sensor.numchan = match_num_chan;

% ---------------------------
% setting collocation criteria
% ---------------------------
Collocate.time = 60; % collocation temporal difference (minute)
Collocate.distance_type = 'km'; % km/degree; For km, polar effect of shorter distance than that in equator is reduced
Collocate.distance = 5; % collocation spatial difference (km/degree)
Collocate.eia = 2; % collocation EIA difference (degree)

% =======================================================
% filter
% =======================================================

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


% O-B stats
n1 = length(Stat.BinTB);n2=match_num_chan;n3=NumOrbitNode;
hist1_tar_tb_obs=zeros(n1,n2,n3); % TB after fitlering including cloud

n1 = length(Stat.BinTBSD);n2=match_num_chan;n3=NumOrbitNode;
hist1_tar_tb_dif=zeros(n1,n2,n3);

n1 = length(Stat.Bin_Hist2_TBSD);n2=length(Stat.Bin_Hist2_TB);n3=match_num_chan;n4=NumOrbitNode; % [DD,TB,channel,dir]
hist2_tar_tb_dif = single(zeros(n1,n2,n3,n4));

% along scan
cross_tar_tb_obs = zeros(tar_sensor.num_crosstrack,match_num_chan,NumOrbitNode);
cross_tar_num = zeros(tar_sensor.num_crosstrack,1,NumOrbitNode);
cross_tar_tb_dif = zeros(tar_sensor.num_crosstrack,match_num_chan,NumOrbitNode);
cross_tar_tb_dif2 = zeros(tar_sensor.num_crosstrack,match_num_chan);

% daily
n1=match_num_chan;n2=size(ndatestr,1);n3=NumOrbitNode;
day_num = zeros(1,n2); % [n1,n2]

day_tar_tb_obs = zeros(n1,n2);
day_tar_tb_dif = zeros(n1,n2);
day_tar_tb_dif_std = zeros(n1,n2);

% map
GridLat = -90: GridMap: 90;
GridLon = -180: GridMap: 179;
n1=numel(GridLat);n2=numel(GridLon);n4=NumOrbitNode;
map_tar_gridnum = zeros(n1,n2,1,n4);
map_tar_tb_dif = zeros(n1,n2,match_num_chan,n4);
