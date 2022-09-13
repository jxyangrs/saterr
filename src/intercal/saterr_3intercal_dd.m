function saterr_3intercal_dd
% analyzing double difference of two satellite (observation-simulation) - (observation-simulation)
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
saterr_intercal_dd_setting

% =======================================================
% observation - observation analysis
% =======================================================

for iday=1: size(ndatestr,1) % daily
    datestr1 = ndatestr(iday,:);
    datenum1 = datenum(datestr1,'yyyymmdd');

    % ---------------------------
    % reading satellite data info
    % ---------------------------
    [tar_fileinfo_obs] = set_FileDaily(tar_datainfo_obs,tar_datainfo_obs.path,ndatestr(iday,:));
    [ref_fileinfo_obs] = set_FileDaily(ref_datainfo_obs,ref_datainfo_obs.path,ndatestr(iday,:));
    
    if (tar_fileinfo_obs.united_filenum==0) || (ref_fileinfo_obs.united_filenum==0)
        continue
    end
    
    % ---------------------------
    % reading simulation data info
    % ---------------------------
    [tar_fileinfo_sim] = set_data_sim_filedaily(tar_datainfo_sim,tar_datainfo_sim.path,ndatestr(iday,:));
    [ref_fileinfo_sim] = set_data_sim_filedaily(ref_datainfo_sim,ref_datainfo_sim.path,ndatestr(iday,:));
    
    if (tar_fileinfo_sim.united_filenum==0) || (ref_fileinfo_sim.united_filenum==0)
        continue
    end
    
    % ---------------------------
    % loading daily target satellite data
    % ---------------------------
    [tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_sc_h,tar_sc_lat,tar_sc_lon,tar_len_orbit] = read_sat_filesdaily(tar_datainfo_obs,tar_fileinfo_obs);
    tar_time_sc = tar_time(round(end/2),:);

    % ---------------------------
    % loading daily reference satellite data
    % ---------------------------
    [ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_sc_h,ref_sc_lat,ref_sc_lon,ref_len_orbit] = read_sat_filesdaily(ref_datainfo_obs,ref_fileinfo_obs);
    
    % ---------------------------
    % loading daily target simulation
    % ---------------------------
    [tar_tb_sim] = read_data_cal_tatb_filesdaily(tar_fileinfo_sim.path);
    
    % ---------------------------
    % loading daily reference simulation
    % ---------------------------
    [ref_tb_sim] = read_data_cal_tatb_filesdaily(ref_fileinfo_sim.path);
    
    % ---------------------------
    % inner-loop filtering and processing
    % ---------------------------
    saterr_intercal_dd_process
    
end

% ---------------------------
% summarizing and output
% ---------------------------
saterr_intercal_dd_output

% ---------------------------
% plot
% ---------------------------
saterr_3intercal_dd_plot



