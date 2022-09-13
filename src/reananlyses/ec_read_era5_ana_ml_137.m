function [lat,lon,atm_t,atm_q,atm_scale_factor,atm_offset] = ec_read_era5_ana_ml_137(str_date,inpath)
% read ERA5 ana surface (monthly) from ECMWF; netcdf file
% 
% Input:
%       str_date,        yyyymmddHH (prevent numeric error)
%       inpath,          directory for monthly data
% 
% Output (daily file):
%       atm_t,      atm pressure (Pa),                   [lon,lat(north-south),137-layer (top-down)]
%       atm_q,      atm specifc humidity (kg/kg),        [lon,lat(north-south),137-layer (top-down)]
% 
% Example:
%       indatenum = datenum([2019 1 1 0 0 0]);
%       inpath_day = '../20180131/';
% 
% Note:
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/12/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/12/2020: monthly directory
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/25/2020: cds data; remove range control

% ===========================================================
% check
% ===========================================================
lat = [];
lon = [];
atm_t = [];
atm_q = [];
atm_scale_factor = [];
atm_offset = [];

indatenum = datenum(str_date,'yyyymmddHH');
str_yyyymmdd = str_date(1:8); % day 1 of each month

if isempty(dir([inpath,'era5_ana_ml_137_tmp_',str_yyyymmdd,'*']))
    warning(['tmp missing ',str_date])
    return
end
if isempty(dir([inpath,'era5_ana_ml_137_q_',str_yyyymmdd,'*']))
    warning(['q ',str_date])
    return
end

% ===========================================================
% read through files
% ===========================================================

% -------------------------
% atmosphre (daily data)
% -------------------------

% temperature 
% ---------------
fileinfo = dir([inpath,'era5_ana_ml_137_tmp_',str_yyyymmdd,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'t',[1,1,1,ind],[inf,inf,inf,1]);
M = double(M);
atm_t = M;

% scale,offset
att = ncinfo([inpath,infile],'t');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

atm_scale_factor(1) = a1;
atm_offset(1) = a0;


% lat lon
% ---------------
lat = ncread([inpath,infile],'latitude'); 
lon = ncread([inpath,infile],'longitude'); 

% q
% ---------------
fileinfo = dir([inpath,'era5_ana_ml_137_q_',str_yyyymmdd,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'q',[1,1,1,ind],[inf,inf,inf,1]);
M = double(M);
atm_q = M;

% scale,offset
att = ncinfo([inpath,infile],'q');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

atm_scale_factor(2) = a1;
atm_offset(2) = a0;
