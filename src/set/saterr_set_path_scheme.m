function saterr_set_path_scheme
% setting directory and processing scheme
% 
% Input:
%       directories of satellite and reanalyais data if needed
%
% Output:
%       directories of satellite and reanalyais data
%
% Description:
%       The directories setting is only necessary when observational satellite and reanalysis data are needed for simulation
%
%   more setting can be found at:
%   satellite orbit:
%       saterr_set_geoorbit_real_scfov.m, saterr_set_geoorbit_real_scfov.m
% 
%   reanalysis data:
%       saterr_set_profile.m, saterr_set_profile_ana.m
%
%   the general data and directory layout is rootpath/year/yyyymmdd/files
%   e.g. rootpath/ERA5-37/20190601/era5_ana_pl_37_sfc_umd_2019060100.nc
%                                  era5_ana_pl_37_sfc_umd_2019060101.nc
%                                  ...
%       
%   When comparing two satellites, go saterr_intercal_oo_setting.m for details
% 
% History:
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/06/2019: original code

global Rad Path Orbit Setting NGranuel

% -------------------------
% setting directory
% -------------------------

% directory of satellite data if needed
path_satellite_data = '/data/jyang/data/microwave/metop-a/amsu-a';
% directory of reanalysis data if needed
% path_reanalysis_data = '/data/jyang/reanalysis/era5/era5_ana_pl_37_sfc'; 
path_reanalysis_data = '/data/jyang/data/reanalysis/era5/era5_ana_ml_137_sfc'; 
% name of reanalysis data
name_reanalysis_data = 'era5-137'; 
% date range for processing data: format yyyymmdd, date_range(1)<=date<date_range(2)
date_range = {'20190601','20190603'}; % cell

% root directory of processing, which overwrites Setting.PathRoot
path_processing = ''; 

% file ID
sensor_file_ID = '*atms*'; % ID for identifying sensor data files
sensor_file_ID = 'NSS.AMAX.*'; % ID for identifying sensor data files
sensor_data_info = 'atms_OPS_SDRdaily_V02_npp'; % refer to parse_sensorname.m
sensor_data_info = 'amsu-a_OPS_SDR_V02_metop-a'; % refer to parse_sensorname.m


ana_file_ID = 'era5_ana*'; % ID for identifying reanalysis files

% -------------------------
% setting scheme
% -------------------------
% basic scheme for processing
% A=simulation w/o using moderate reanalysis and satellite data; B=extensive simulation w/ reanalysis and satellite data
% Default is A; 
set_scheme = 'A'; 

switch Setting.step
    case {'step1_a','step1_b','step1_b_queue','step1_c','step1_d','step2_a','step2_b'}
        set_scheme = 'B';
    case {'step1','step2'}
        set_scheme = 'A';
    case {'step3_oo','step3_sd','step3_dd'}
        set_scheme = 'B';
    otherwise
        error('Setting.step is wrong')
end

% -------------------------
% parse
% -------------------------
saterr_parse_path_scheme

