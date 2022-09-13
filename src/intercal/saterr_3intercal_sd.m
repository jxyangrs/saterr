function saterr_3intercal_sd
% calibration for single difference (observation - simulation)
%
% Input:
%       simulation results
%
% Output:
%       calibration, visualization
%
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/03/2018: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: review


global Rad Prof Orbit Path
global LatMask LonMask LandMask % land-sea mask

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
pathin_sensor = Path.sensor.path;

% set up path of simulation
pathin_sim = Path.sim.orbit;
pathout = [Path.intercal.output,'/','sd'];

% ---------------------------
% land-ocean mask
% ---------------------------
load('LandMask_ERA5_June_0.25degree.mat') % LonMask ranging [0,360)
LonMask = double(LonMask);
LatMask = double(LatMask);
LandMask = double(LandMask);

% ---------------------------
% setting filters and variables
% ---------------------------
saterr_intercal_sd_setting

% =======================================================
% single difference analysis
% =======================================================

for iday=1: size(ndatestr,1) % daily
    datestr1 = ndatestr(iday,:);
    datenum1 = datenum(datestr1,'yyyymmdd');

    
    % ---------------------------
    % loading daily satellite data
    % ---------------------------
    [fileinfo] = set_FileDaily(sensor_datainfo,pathin_sensor,ndatestr(iday,:));
    
    [tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_sc_h,tar_sc_lat,tar_sc_lon,tar_len_orbit] = read_sat_filesdaily(sensor_datainfo,fileinfo);
    tar_time_sc = tar_time(round(end/2),:);

    % ---------------------------
    % loading daily simulation data
    % ---------------------------
    [tar_tb_sim] = read_sim_filesdaily(pathin_sim,datestr1);
    
    % ---------------------------
    % inner-loop filtering and processing
    % ---------------------------
    saterr_intercal_sd_process
    
end

% ---------------------------
% summarizing and output
% ---------------------------
saterr_intercal_sd_output

% ---------------------------
% plot
% ---------------------------
saterr_3intercal_sd_plot



