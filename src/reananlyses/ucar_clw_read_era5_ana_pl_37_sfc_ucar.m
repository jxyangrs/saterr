function [lat,lon,atm_pres1D,atm_t,atm_q,atm_crwc,atm_cswc,atm_clwc,atm_ciwc,atm_cc,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst] = ...
    ucar_clw_read_era5_ana_pl_37_sfc_ucar(indate,inpath)
% read ERA5 reanalysis atmosphere (37-layer) and surface; UCAR's netcdf file
% 
% Input:
%       atmosphere profile, hourly data of one day [0:23]
%       surface profile, hourly data of one month
%   atmosphere:
%       specific humidity
%       temperature
%   surface:
%       pressure
%       U wind
%       V wind
%       skin temperature
%       sst
%   variables:
%       indate,         datenum,                    [ndatenum,1]
%       inpath,         directory
%       
% Output:
%       lat,            latitude (up-down)                              [721,1]  90:-0.25:-90 (0.25 degree grid)
%       lon,            longitude                                       [1440,1] 0:0.25:359.75 
%       atm_pres1D,     atm pressure (Pa),                              [layer(up-down),1]/[37] 
%       atm_t,          temperature (K),                                [lon,lat,layer,ndatenum]
%       atm_q,          specific humidity (kg kg^-1),                   [lon,lat,layer,ndatenum]
%       atm_crwc,       specific rain water content (kg kg^-1),         [lon,lat,layer,ndatenum]
%       atm_cswc,       specific snow water content (kg kg^-1),         [lon,lat,layer,ndatenum]
%       atm_clwc,       specific cloud liquid water content (kg kg^-1), [lon,lat,layer,ndatenum]
%       atm_ciwc,       specific cloud ice water content (kg kg^-1),    [lon,lat,layer,ndatenum]
%       atm_cc,         cloud cover (ranging [0,1]),                    [lon,lat,layer,ndatenum]
%       sfc_pres,       sfc pressure (Pa),                              [lon,lat,ndatenum]
%       sfc_u10,        sfc 10-m ws U (m/s),                            [lon,lat,ndatenum]
%       sfc_v10,        sfc 10-m ws V (m/s),                            [lon,lat,ndatenum]
%       sfc_skt,        sfc skin temperature,                           [lon,lat,ndatenum]
%       sfc_sst,        sea surface temperature,                        [lon,lat,ndatenum]
% 
% Examples:
%       indate = [2018013113];
%       inpath_day = '../20180131';
% 
% Note:
% atm_pres1D = flip([1;2;3;5;7;10;20;30;50;70;100;125;150;175;200;225;250;300;350;400;450;500;550;600;650;700;750;775;800;825;850;875;900;925;950;975;1000]);
% 
% Code:
%     ind = find(ismember(utc_date,indate));
%     atm_t = 0;
%     n = length(ind);
%     for i=1: n
%         M = ncread([inpath,infile],'T',[1,1,1,ind(i)],[inf,inf,inf,1]); % kg kg^-1
%         atm_t = atm_t+M;
%     end
%     atm_t = atm_t/n;
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/12/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/12/2020: monthly directory
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/15/2020: add sst
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/19/2021: add cloud


% ===========================================================
% check
% ===========================================================
lat = [];
lon = [];
atm_pres1D = [];
atm_t = [];
atm_q = [];
sfc_pres = [];
sfc_u10 = [];
sfc_v10 = [];
sfc_skt = [];
sfc_sst = [];

str_date = num2str(indate);
str_monthday1 = [str_date(1:6),'0100']; % day 1 of each month

if isempty(dir([inpath,'/','*.pl.*_t.ll*',str_date(1:8),'*']))
    warning(['temperature missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.pl.*_q.ll*',str_date(1:8),'*']))
    warning(['specific humidity missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.sfc.*_sp.ll*',str_monthday1,'*']))
    warning(['suface pressure missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.sfc.*_10u.ll*',str_monthday1,'*']))
    warning(['surface 10u wind missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.sfc.*_10v.ll*',str_monthday1,'*']))
    warning(['surface 10v wind missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.sfc.*_skt.ll*',str_monthday1,'*']))
    warning(['surface skin temperature missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.sfc.*_sstk.ll*',str_monthday1,'*']))
    warning(['surface skin temperature missing ',str_date])
    return
end

% clw
if isempty(dir([inpath,'/','*.pl.*_crwc.ll*',str_monthday1,'*']))
    warning(['crwc missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.pl.*_cswc.ll*',str_monthday1,'*']))
    warning(['cswc missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.pl.*_clwc.ll*',str_monthday1,'*']))
    warning(['clwc missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.pl.*_ciwc.ll*',str_monthday1,'*']))
    warning(['ciwc missing ',str_date])
    return
end
if isempty(dir([inpath,'/','*.pl.*_cc.ll*',str_monthday1,'*']))
    warning(['ciwc missing ',str_date])
    return
end

% ===========================================================
% read through files
% ===========================================================
disp('===========================================================')
disp('reading era5')
% -------------------------
% atmosphere (daily data)
% -------------------------

% pressure & temperature (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_t.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');
lat = ncread([inpath,'/',infile],'latitude');
lon = ncread([inpath,'/',infile],'longitude');
pres = ncread([inpath,'/',infile],'level');
atm_pres1D = pres*1e2;

ind = find(ismember(utc_date,indate));
atm_t = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'T',[1,1,1,ind(i)],[inf,inf,inf,1]); 
    atm_t = cat(4,atm_t,M);
end

% specific humidity (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_q.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
atm_q = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'Q',[1,1,1,ind(i)],[inf,inf,inf,1]); % kg kg^-1
    M(M<0) = 0; % remove some negative value 
    atm_q = cat(4,atm_q,M);
end

% Specific rain water content (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_crwc.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
atm_crwc = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'CRWC',[1,1,1,ind(i)],[inf,inf,inf,1]); % kg kg^-1
    M(M<0) = 0; % remove some negative value 
    atm_crwc = cat(4,atm_crwc,M);
end

% Specific snow water content (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_cswc.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
atm_cswc = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'CSWC',[1,1,1,ind(i)],[inf,inf,inf,1]); % kg kg^-1
    M(M<0) = 0; % remove some negative value 
    atm_cswc = cat(4,atm_cswc,M);
end

% Specific cloud liquid water content (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_clwc.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
atm_clwc = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'CLWC',[1,1,1,ind(i)],[inf,inf,inf,1]); % kg kg^-1
    M(M<0) = 0; % remove some negative value 
    atm_clwc = cat(4,atm_clwc,M);
end

% Specific cloud ice water content (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_ciwc.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
atm_ciwc = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'CIWC',[1,1,1,ind(i)],[inf,inf,inf,1]); % kg kg^-1
    M(M<0) = 0; % remove some negative value 
    atm_ciwc = cat(4,atm_ciwc,M);
end

% cloud fraction (hourly day file)
fileinfo = dir([inpath,'/','*.pl.*_cc.ll*',str_date(1:8),'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
atm_cc = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'CC',[1,1,1,ind(i)],[inf,inf,inf,1]); % ranging [0,1]
    M(M<0) = 0; % remove some negative value 
    atm_cc = cat(4,atm_cc,M);
end

% -------------------------
% surface (monthly data)
% -------------------------

% surface pressure 
fileinfo = dir([inpath,'/','*.sfc.*_sp.ll*',str_monthday1,'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
sfc_pres = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'SP',[1,1,ind(i)],[inf,inf,1]); 
    sfc_pres = cat(4,sfc_pres,M);
end

% wind speed 10 meter V
fileinfo = dir([inpath,'/','*.sfc.*_10u.ll*',str_monthday1,'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
sfc_u10 = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'VAR_10U',[1,1,ind(i)],[inf,inf,1]); 
    sfc_u10 = cat(4,sfc_u10,M);
end

% wind speed 10 meter U
fileinfo = dir([inpath,'/','*.sfc.*_10v.ll*',str_monthday1,'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
sfc_v10 = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'VAR_10V',[1,1,ind(i)],[inf,inf,1]); 
    sfc_v10 = cat(4,sfc_v10,M);
end

% skin temperature
fileinfo = dir([inpath,'/','*.sfc.*_skt.ll*',str_monthday1,'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
sfc_skt = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'SKT',[1,1,ind(i)],[inf,inf,1]); 
    sfc_skt = cat(4,sfc_skt,M);
end

% sst
fileinfo = dir([inpath,'/','*.sfc.*_sstk.ll*',str_monthday1,'*']);
infile = fileinfo.name;
disp(infile)

utc_date = ncread([inpath,'/',infile],'utc_date');

ind = find(ismember(utc_date,indate));
sfc_sst = [];
n = length(ind);
for i=1: n
    M = ncread([inpath,'/',infile],'SSTK',[1,1,ind(i)],[inf,inf,1]); 
    sfc_sst = cat(4,sfc_sst,M);
end
