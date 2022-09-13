function ec_main_write_era5_ana_ml_137_sfc_umd(DatestrBegin,DatestrEnd)
% write netcdf file of hourly ERA5 at model-level 137-layer
%   DatestrBegin<=time<DatestrEnd
%
% Input:
%       DatestrBegin,   YYYYMMDDHH
%       DatestrEnd,     YYYYMMDDHH
%  
%     File syntax:
%       hourly atmosphere file: era5_ana_ml_137_q_20190601.nc
%                               era5_ana_ml_137_tmp_20190601.nc
%       monthly surface file:   era5_ana_sfc_pres_mon201906.nc
%                               era5_ana_sfc_skintmp_mon201906.nc.nc
%                               era5_ana_sfc_sst_mon201906.nc.nc
%                               era5_ana_sfc_uwind_mon201906.nc.nc
%                               era5_ana_sfc_vwind_mon201906.nc.nc
%     Directory syntax:
%       inpath_atm = [PathIn,'atm_ml137_daily/']; % */daily_file
%       inpath_sfc = [PathIn,'sfc_monthly/'];     % */monthly_file
% 
% 
% Output:
%   e.g. era5_umd_l37_2018013113.nc
%
%       atm_t,          temperature (K),            [lon(0:0.25:359.75),lat(90:-0.25:-90)s,layer(top-down)]
%       atm_q,          specific humidity (kg kg^-1)[lon,lat,layer]     >=0
%       sfc_pres,       sfc pressure (Pa),          [lon,lat]
%       sfc_u10,        sfc 10-m ws U (m/s),        [lon,lat]           
%       sfc_v10,        sfc 10-m ws V (m/s),        [lon,lat]
%       sfc_skt,        sfc skin temperature,       [lon,lat]
%       sfc_sst,        sea surface temperature,    [lon,lat]
%
% Examples:
%       ec_main_write_era5_ana_ml_137_sfc_umd('2019020100','201909030100')    
%       outfile = era5_umd_atmsfc_ml137_2019083100.nc.nc
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/26/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 06/16/2020: revise fillvaule and filename syntax


% ===========================================================
% setting
% ===========================================================
Hour_Interval = 1;

PathIn = '/data/jyang/data/reanalysis/ERA5/era5_atmsfc_ml137/temp/';
PathOut = '/data/jyang/data/reanalysis/ERA5/era5_atmsfc_ml137/';

% ===========================================================
% execute
% ===========================================================
datenum1 = (datenum(DatestrBegin,'yyyymmddHH'): Hour_Interval/24: datenum(DatestrEnd,'yyyymmddHH'))';
idx = datenum1<datenum(DatestrEnd,'yyyymmddHH');
datenum1 = datenum1(idx);
ndatestr = datestr(datenum1,'yyyymmddHH'); % avoid numeric error of cumulative 1/24;

for idate=1: size(ndatestr,1)
    
    % ===========================================================
    % setting
    % ===========================================================
    datestr1 = ndatestr(idate,:);
    outpath = [PathOut,datestr1(1:4),'/',datestr1(1:8),'/']; % year/date/..., e.g. 2019/20190831/
    if ~exist(outpath,'dir')
        mkdir(outpath)
    end
    
    inpath_atm = [PathIn,'atm_ml137_daily/']; % */daily_file
    inpath_sfc = [PathIn,'sfc_monthly/']; % % */monthly_file

    disp('===========================================================')
    disp(datestr1)

    % ===========================================================
    % read (ml-137, surface)
    % ===========================================================
    
    inpath = inpath_atm;
    [lat,lon,atm_t,atm_q,atm_scale_factor,atm_offset] = ec_read_era5_ana_ml_137(datestr1,inpath);
    
    inpath = inpath_sfc;
    [lat,lon,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst,sfc_scale_factor,sfc_offset] = ec_read_era5_ana_sfc(datestr1,inpath);
    
    % ===========================================================
    % output
    % ===========================================================
    
    %% write binary file
    outfile = ['era5_ana_ml_137_sfc_umd_',datestr1,'.nc'];
    ec_write_era5_ana_ml_137_sfc_umd(outpath,outfile,...
        lat,lon,...
        atm_t,atm_q,atm_scale_factor,atm_offset,...
        sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst,sfc_scale_factor,sfc_offset)

    disp(outfile)
    
end


