function [lat,lon,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst,sfc_scale_factor,sfc_offset] = ec_read_era5_ana_sfc(str_date,inpath)
% read ERA5 ana surface (monthly) from ECMWF; netcdf file
% 
% Input:
%       str_date,       yyyymmddHH (prevent numerica error)
%       inpath,         directory for monthly data
% 
% Output (hourly):
%       sfc_pres,       sfc pressure (Pa),          [lon,lat (north-south)]
%       sfc_u10,        sfc 10-m ws U (m/s),        [lon,lat (north-south)]
%       sfc_v10,        sfc 10-m ws V (m/s),        [lon,lat (north-south)]
%       sfc_skt,        sfc skin temperature,       [lon,lat (north-south)]
%       sfc_sst,        sea surface temperature,    [lon,lat (north-south)],      NaN=missing/bad
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/12/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/12/2020: monthly directory
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/25/2020: cds data

% ===========================================================
% setting bound
% ===========================================================
range_int16 = [-32767,32766]; % conservative

% ===========================================================
% check
% ===========================================================
lat = [];
lon = [];
sfc_pres = [];
sfc_u10 = [];
sfc_v10 = [];
sfc_skt = [];
sfc_sst = [];
sfc_scale_factor = [];
sfc_offset = [];

indatenum = datenum(str_date,'yyyymmddHH');
str_yyyymm = str_date(1:6); % day 1 of each month

if isempty(dir([inpath,'era5_ana_sfc_pres_mon',str_yyyymm,'*']))
    warning(['suface pressure missing ',str_yyyymm])
    return
end
if isempty(dir([inpath,'era5_ana_sfc_uwind_mon',str_yyyymm,'*']))
    warning(['surface 10u wind missing ',str_yyyymm])
    return
end
if isempty(dir([inpath,'era5_ana_sfc_vwind_mon',str_yyyymm,'*']))
    warning(['surface 10v wind missing ',str_yyyymm])
    return
end
if isempty(dir([inpath,'era5_ana_sfc_skintmp_mon',str_yyyymm,'*']))
    warning(['surface skin temperature missing ',str_yyyymm])
    return
end
if isempty(dir([inpath,'era5_ana_sfc_sst_mon',str_yyyymm,'*']))
    warning(['surface sst missing ',str_yyyymm])
    return
end


% ===========================================================
% read through files
% ===========================================================

% -------------------------
% surface (monthly data)
% -------------------------

% surface pressure
% ---------------
fileinfo = dir([inpath,'era5_ana_sfc_pres_mon',str_yyyymm,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'sp',[1,1,ind],[inf,inf,1]);
M = double(M);
sfc_pres = M;

% scale,offset
att = ncinfo([inpath,infile],'sp');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

sfc_scale_factor(1) = a1;
sfc_offset(1) = a0;

% lat lon
% ---------------
lat = ncread([inpath,infile],'latitude'); 
lon = ncread([inpath,infile],'longitude'); 

% wind speed 10 meter U
% ---------------
fileinfo = dir([inpath,'era5_ana_sfc_uwind_mon',str_yyyymm,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'u10',[1,1,ind],[inf,inf,1]);
M = double(M);
sfc_u10 = M;

% scale,offset
att = ncinfo([inpath,infile],'u10');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

sfc_scale_factor(2) = a1;
sfc_offset(2) = a0;

% wind speed 10 meter V
% ---------------
fileinfo = dir([inpath,'era5_ana_sfc_vwind_mon',str_yyyymm,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'v10',[1,1,ind],[inf,inf,1]);
M = double(M);
sfc_v10 = M;

% scale,offset
att = ncinfo([inpath,infile],'v10');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

sfc_scale_factor(3) = a1;
sfc_offset(3) = a0;

% skin temperature
% ---------------
fileinfo = dir([inpath,'era5_ana_sfc_skintmp_mon',str_yyyymm,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'skt',[1,1,ind],[inf,inf,1]);
M = double(M);
sfc_skt = M;

% scale,offset
att = ncinfo([inpath,infile],'skt');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

sfc_scale_factor(4) = a1;
sfc_offset(4) = a0;

% sst
% ---------------
fileinfo = dir([inpath,'era5_ana_sfc_sst_mon',str_yyyymm,'*']);
infile = fileinfo.name;
disp(infile)

hour = double(ncread([inpath,infile],'time')); % hour since 1900-1-1
ref_datenum = datenum([1900 1 1 0 0 0]) + hour/24;

ind = find(ismember(ref_datenum,indatenum));
if isempty(ind)
    error('ind is empty')
end
M = ncread([inpath,infile],'sst',[1,1,ind],[inf,inf,1]);
M = double(M);
sfc_sst = M;

% scale,offset
att = ncinfo([inpath,infile],'sst');
a1 = att.Attributes(1).Value;
a0 = att.Attributes(2).Value;

sfc_scale_factor(5) = a1;
sfc_offset(5) = a0;
