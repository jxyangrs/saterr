% setting data path, filters and variables for double-difference intercalibration 
% 
% 
% History:
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review

% =======================================================
% Input
% =======================================================

% ---------------------------
% setting target and reference satellites
% ---------------------------
tar_datainfo_obs.spacecraft = 'metop-a';
tar_datainfo_obs.sensor = 'amsu-a';
tar_datainfo_obs.path = '/data/jyang/data/sounder/metop-a/amsu-a';
tar_datainfo_obs.fileID = '*AMAX.M2*'; % e.g. *AMAX.M2*=metop-a amsu-a; *MHSX.M3*=metop-c mhs
tar_datainfo_sim.path = '/data/jyang/task_output/saterr/metop-a/amsu-a/2cal';
tar_datainfo_sim.fileID = '*AMAX.M2*'; % e.g. *AMAX.M2*=metop-a amsu-a; *MHSX.M3*=metop-c mhs


ref_datainfo_obs.spacecraft = 'metop-a';
ref_datainfo_obs.sensor = 'amsu-a';
ref_datainfo_obs.path = '/data/jyang/data/sounder/metop-a/amsu-a';
ref_datainfo_obs.fileID = '*AMAX.M2*'; % e.g. *AMAX.M2*=metop-a amsu-a; *MHSX.M3*=metop-c mhs
ref_datainfo_sim.path = '/data/jyang/task_output/saterr/metop-a/amsu-a/2cal';
ref_datainfo_sim.fileID = '*AMAX.M2*'; % e.g. *AMAX.M2*=metop-a amsu-a; *MHSX.M3*=metop-c mhs

datebegin = '20190601'; % datebegin<=date range<dateend
dateend = '20190603';

% ---------------------------
% setting pathout
% ---------------------------
pathout = '/data/jyang/task_output/saterr/intercal/';

% ---------------------------
% land-ocean mask
% ---------------------------
load('LandMask_ERA5_June_0.25degree.mat') % LonMask ranging [0,360)
LonMask = double(LonMask);
LatMask = double(LatMask);
LandMask = double(LandMask);

tar_sensor = rad_spc_set(tar_datainfo_obs.sensor);

ref_sensor = rad_spc_set(ref_datainfo_obs.sensor);

% ---------------------------
% setting index of match-up channels
% ---------------------------
match_tar_chanind = 1: 5;
match_ref_chanind = 1: 5;

match_num_chan = length(match_tar_chanind);

tar_sensor.chanfreq = tar_sensor.chanfreq(match_tar_chanind);
tar_sensor.chanstr = tar_sensor.chanstr(match_tar_chanind);
tar_sensor.chan_freq_nominal = tar_sensor.chan_freq_nominal(match_tar_chanind);
tar_sensor.chanpol = tar_sensor.chanpol(match_tar_chanind);
tar_sensor.chanind = tar_sensor.chanind(match_tar_chanind);
tar_sensor.numchan = match_num_chan;

ref_sensor.chanfreq = ref_sensor.chanfreq(match_ref_chanind);
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
FilterCal.ref_tb_sd.onoff = 1;
FilterCal.ref_tb_sd.range = [-15,15];

% filter of double difference
FilterCal.tb_dd.onoff = 1;
FilterCal.tb_dd.range = [-15,15];

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
Stat.BinTBDD = -15:0.1:15;

% ---------------------------
% hist2
% ---------------------------
Stat.Bin_Hist2_TB = 100:0.4:310;
Stat.Bin_Hist2_TBSD = -10:0.1:10;
Stat.Bin_Hist2_TBDD = -10:0.1:10;

% direction of orbit
NumOrbitNode = 3; % D3=[both/asc/des],D1=[both]
% grid resolution of map
GridMap = 1;

% collocation oscillation period according to prediction model
% PeriodOscModel = orbit_period2sat(RefRadSpc.orbit.altitude,RefRadSpc.orbit.inclination,TarRadSpc.orbit.altitude,TarRadSpc.orbit.inclination);
PeriodOscModel = 1;

% =======================================================
% setting variables
% =======================================================

% determine the time interval
ndatenum = datenum(datebegin,'yyyymmdd'): datenum(dateend,'yyyymmdd')-1;
ndatestr = datestr(ndatenum,'yyyymmdd');
numday = size(ndatestr,1);


% hist1
n1 = length(Stat.BinTB);n2=match_num_chan;n3=NumOrbitNode;
hist1_tar_tb_obs=zeros(n1,n2,n3); % TB after fitlering including cloud

n1 = length(Stat.BinTBDD);n2=match_num_chan;n3=NumOrbitNode;
hist1_tb_dd=zeros(n1,n2,n3);

% hist2
n1 = length(Stat.Bin_Hist2_TBDD);n2=length(Stat.Bin_Hist2_TB);n3=match_num_chan;n4=NumOrbitNode; % [DD,TB,channel,dir]
hist2_tar_tb_tb_dd = single(zeros(n1,n2,n3,n4));

% along scan
n1=tar_sensor.num_crosstrack;n2=match_num_chan;n3=NumOrbitNode;
cross_tar_tb_obs = zeros(n1,n2,n3);
cross_tar_num = zeros(n1,1,n3);
cross_tb_dd = zeros(n1,n2,n3);
cross_tb_dd2 = zeros(n1,n2,n3);


% daily
n1=match_num_chan;n2=size(ndatestr,1);n3=NumOrbitNode;
day_num = zeros(1,n2); % [n1,n2]

day_tar_tb_obs = zeros(n1,n2,n3);
day_ref_tb_obs = zeros(n1,n2,n3);
day_tb_dd = zeros(n1,n2,n3);
day_tb_dd_std = zeros(n1,n2,n3);

day_crosstnum = zeros(tar_sensor.num_crosstrack,1,n2,n3);

% map
GridLat = -90: GridMap: 90;
GridLon = -180: GridMap: 179;
n1=numel(GridLat);n2=numel(GridLon);n4=NumOrbitNode;
map_tar_gridnum = zeros(n1,n2,1,n4);
map_tb_dd = zeros(n1,n2,match_num_chan,n4);
map_tar_tb_obs = zeros(n1,n2,match_num_chan,n4);
