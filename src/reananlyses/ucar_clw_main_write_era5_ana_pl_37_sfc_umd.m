function ucar_clw_main_write_era5_ana_pl_37_sfc_umd(DateBegin,DateEnd)
% write netcdf based on ERA5 of pressure level 37
%
% Input:
%       atmosphere at pressure-level 37-layer: separate files of different parameters, hourly of one day
%           e.g. e5.oper.an.pl.128_130_t.ll025sc.2019060100_2019060123.nc
%                e5.oper.an.pl.128_133_q.ll025sc.2019060100_2019060123.nc
%                e5.oper.an.pl.128_075_crwc.ll025sc.2019060100_2019060123.nc
%                e5.oper.an.pl.128_076_cswc.ll025sc.2019060100_2019060123.nc
%                e5.oper.an.pl.128_246_clwc.ll025sc.2019060100_2019060123.nc
%                e5.oper.an.pl.128_247_ciwc.ll025sc.2019060100_2019060123.nc
%       surface: separate files of different parameters, monthly
%           e.g. e5.oper.an.sfc.128_034_sstk.ll025sc.2018010100_2018013123.nc
%                e5.oper.an.sfc.128_134_sp.ll025sc.2018010100_2018013123.nc
%                e5.oper.an.sfc.128_165_10u.ll025sc.2019080100_2019083123.nc
%                e5.oper.an.sfc.128_166_10v.ll025sc.2019080100_2019083123.nc
%       input directory: root/files
%
% Output:
%       hourly file with both atmosphere and surface
%           e.g. era5_ana_pl_37_sfc_umd_2019060100.nc
%           output directory: year/date/files
%
% Examples:
%       DateBegin<= date <DateEnd
%       ucar_clw_main_write_era5_ana_pl_37_sfc_umd('2019060100','2019060200')
%       ucar_clw_main_write_era5_ana_pl_37_sfc_umd('2019060110','2019060122')
%           
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/25/2020: no time average
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/12/2020: options for output netcdf
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/19/2021: add cloud and do compression

% ===========================================================
% setting
% ===========================================================
PathIn = '/data/reanalysis/era5/era5_ana_pl_37_sfc/temp';
PathOut = '/data/reanalysis/era5/era5_ana_pl_37_sfc';

% DateBegin = '2019060123'; % DateBegin<= date <DateEnd
% DateEnd = '2019060200';
Hour_Interval = 1;

% ===========================================================
% execuate
% ===========================================================
ndatehour = (datenum(DateBegin,'yyyymmddHH'): Hour_Interval/24: datenum(DateEnd,'yyyymmddHH'))';
idx = ndatehour<datenum(DateEnd,'yyyymmddHH');
ndatehour = ndatehour(idx);

for idate=1: length(ndatehour)
    
    % ===========================================================
    % directory
    % ===========================================================
    datestr1 = datestr(ndatehour(idate),'yyyymmddHH');
    inpath = PathIn;
%     inpath = [PathIn,datestr1(1:4),'/',datestr1(5:6),'/']; % year/month/..., e.g. 2019/08/
    
    outpath = [PathOut,'/',datestr1(1:4),'/',datestr1(1:8),'/']; % year/date/..., e.g. 2019/20190831/
    if ~exist(outpath,'dir')
        mkdir(outpath)
    end
    
    % ===========================================================
    % read ERA5 from ECMWF (37 layer)
    % ===========================================================
    indate = str2num(datestr1);
    
    [lat,lon,atm_pres1D,atm_t,atm_q,atm_crwc,atm_cswc,atm_clwc,atm_ciwc,atm_cc,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst] = ucar_clw_read_era5_ana_pl_37_sfc_ucar(indate,inpath);
    if isempty(lat)
        warning('lat is empty')
    end
    
    % ===========================================================
    % output
    % ===========================================================
    
    % write netcdf file
    outfile = ['era5_ana_pl_37_sfc_umd_',datestr1,'.nc'];
    if exist([outpath,outfile],'file')
        delete([outpath,outfile]);
    end
    ucar_clw_write_era5_ana_pl_37_sfc_umd(outpath,outfile, lat,lon,atm_pres1D,atm_t,atm_q,atm_crwc,atm_cswc,atm_clwc,atm_ciwc,atm_cc,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst)
    disp('output file:')
    disp(outfile)
    
end
