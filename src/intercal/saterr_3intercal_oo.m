function saterr_3intercal_oo
% comparing two satellite (observation - observation)
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
saterr_intercal_oo_setting

% =======================================================
% observation - observation analysis
% =======================================================

for iday=1: size(ndatestr,1) % daily
    datestr1 = ndatestr(iday,:);
    datenum1 = datenum(datestr1,'yyyymmdd');

    % ---------------------------
    % reading file info
    % ---------------------------
    [tar_fileinfo] = set_FileDaily(tar_datainfo,tar_datainfo.path,ndatestr(iday,:));
    [ref_fileinfo] = set_FileDaily(ref_datainfo,ref_datainfo.path,ndatestr(iday,:));
    
    if (tar_fileinfo.united_filenum==0) || (ref_fileinfo.united_filenum==0)
        continue
    end
    
    % ---------------------------
    % loading daily target satellite data
    % ---------------------------
    
    [tar_qual,tar_tb_obs,tar_eia,tar_lat,tar_lon,tar_time,tar_azm,tar_scanpos,tar_scanangle,tar_sc_h,tar_sc_lat,tar_sc_lon,tar_len_orbit] = read_sat_filesdaily(tar_datainfo,tar_fileinfo);
    tar_time_sc = tar_time(round(end/2),:);

    % ---------------------------
    % loading daily reference satellite data
    % ---------------------------
    [ref_qual,ref_tb_obs,ref_eia,ref_lat,ref_lon,ref_time,ref_azm,ref_scanpos,ref_scanangle,ref_sc_h,ref_sc_lat,ref_sc_lon,ref_len_orbit] = read_sat_filesdaily(ref_datainfo,ref_fileinfo);
    
    % ---------------------------
    % inner-loop filtering and processing
    % ---------------------------
    saterr_intercal_oo_process
    
end

% ---------------------------
% summarizing and output
% ---------------------------
saterr_intercal_oo_output
 
% ---------------------------
% plot
% ---------------------------
saterr_3intercal_oo_plot



