function ec_write_era5_ana_ml_137_sfc_umd(outpath,outfile,...
    lat,lon,...
    atm_t,atm_q,atm_scale_factor,atm_offset,...
    sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst,sfc_scale_factor,sfc_offset)
% write netcdf file of hourly ERA5 at model-level 137-layer
%
% 
% Output:
%   e.g. era5_umd_l37_2018013113.nc
% 
%       lat,            latitude (north-south)      [721,1]  90:-0.25:-90 (0.25 degree grid)
%       lon,            longitude                   [1440,1] 0:0.25:359.75 
%       atm_t,          temperature (K),            [lon(0:0.25:359.75),lat(90:-0.25:-90)s,layer(top-down)]
%       atm_q,          specific humidity (kg kg^-1)[lon,lat,layer(top-down)]     >=0
%       sfc_pres,       sfc pressure (Pa),          [lon,lat]
%       sfc_u10,        sfc 10-m ws U (m/s),        [lon,lat]
%       sfc_v10,        sfc 10-m ws V (m/s),        [lon,lat]
%       sfc_skt,        sfc skin temperature,       [lon,lat]
%       sfc_sst,        sea surface temperature,    [lon,lat]
% 
% Examples:
%       write_umd_era5_ml137_atmsfc(datenum([2019 8 31 0 0 0],inpath_atm,inpath_sfc,outpath,outfile)
%       outfile = era5_umd_ml137_2018013100.bin
% 
% Table:
%         scale, sfc_offset, _FillValue
%         atmosphere
%         temperature:          0.0023132,      245.2474,       -32767
%         specific humidity:    4.4373e-07,     0.014497,       -32767
% 
%         surface monthly
%         surface pressure,     0.84449,        77082.5074
%         u wind 10 m,          0.0010576,      -2.9593
%         v wind 10 m,          0.0010908,      0.44065
%         skin temperature:     0.0022551,      269.0066,       -32767
%         sea surface temp,     0.00060108,     290.0765,       -32767
% 
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/26/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 04/30/2020: fillvalue update; prevent overrange


% ===========================================================
% check
% ===========================================================
% setting
var_basic            = {'lat','lon'};
var_basic_longname   = {'latitude','longitude'};
var_basic_units      = {'degrees','degrees'};
var_basic_datatype   = {'single','single'};
sfc_var              = {'sfc_pres','sfc_u10','sfc_v10','sfc_skt','sfc_sst'};
sfc_var_longname     = {'surface pressure','surface 10-m wind speed U','surface 10-m wind speed V','surface skin temperature','sea surface temperature'};
sfc_var_units        = {'Pa','m/s','m/s','K','K'};
sfc_var_datatype     = {'int16','int16','int16','int16','int16'};
atm_var              = {'atm_t','atm_q'};
atm_var_longname     = {'atmospheric air temperature','atmospheric specific humidity'};
atm_var_units        = {'K','kg/kg'};
atm_var_datatype     = {'int16','int16','int16'};

fillvalue_int16 = -32767;
upbound_int16 = 32767;
dnbound_int16 = -32766; % -32767 is NaN of fillvalue

% ===========================================================
% write
% ===========================================================
% -------------------------
% clear
% -------------------------
fout = [outpath,outfile];
if exist(fout,'file')
    delete(fout)
end

% -------------------------
% create
% -------------------------
[n1,n2,n3] = size(atm_t);
lat = lat(:);
lon = lon(:);

% basic variables
nccreate(fout,'lon','Dimensions',{'Lon',n1},'Datatype',var_basic_datatype{1});
nccreate(fout,'lat','Dimensions',{'Lat',n2},'Datatype',var_basic_datatype{2});

for i=1: length(sfc_var)
    nccreate(fout,sfc_var{i},'Dimensions',{'Lon',n1,'Lat',n2},'Datatype',sfc_var_datatype{i},'FillValue',fillvalue_int16);
end

for i=1: length(atm_var)
    nccreate(fout,atm_var{i},'Dimensions',{'Lon',n1,'Lat',n2,'Level',n3},'Datatype',atm_var_datatype{i},'FillValue',fillvalue_int16);
end

% -------------------------
% prevent overrange
%   overrange can take place due to conversion twice
% -------------------------
% sfc
for i=1: length(sfc_var)
    eval(['y=',sfc_var{i},';']);
    x = (y-sfc_offset(i))/sfc_scale_factor(i);
    idx = x>upbound_int16;
    s1 = sum(idx(:));
    if s1>0
        x(idx) = upbound_int16;
    end
    idx = x<dnbound_int16;
    s2 = sum(idx(:));
    if s2>0
        x(idx) = dnbound_int16;
    end
    eval([sfc_var{i}, '=x;'])
end
% atm
for i=1: length(atm_var)
    eval(['y=',atm_var{i},';']);
    x = (y-atm_offset(i))/atm_scale_factor(i);
    idx = x>upbound_int16;
    s1 = sum(idx(:));
    if s1>0
        x(idx) = upbound_int16;
    end
    idx = x<dnbound_int16;
    s2 = sum(idx(:));
    if s2>0
        x(idx) = dnbound_int16;
    end
    eval([atm_var{i}, '=x;'])
end

% -------------------------
% write variables
% (not converting w/ scale and offset)
% -------------------------
for i=1: length(var_basic)
    eval(['ncwrite(fout,''', var_basic{i}, ''',',var_basic{i},');'])
end
for i=1: length(sfc_var)
    eval(['ncwrite(fout,''', sfc_var{i}, ''',',sfc_var{i},');'])
end
for i=1: length(atm_var)
    eval(['ncwrite(fout,''', atm_var{i}, ''',',atm_var{i},');'])
end

% -------------------------
% add attributes
% -------------------------
for i=1: length(var_basic)
    ncwriteatt(fout,var_basic{i},'units',var_basic_units{i})
    ncwriteatt(fout,var_basic{i},'long_name',var_basic_longname{i})
end

for i=1: length(sfc_var)
    ncwriteatt(fout,sfc_var{i},'units',sfc_var_units{i})
    ncwriteatt(fout,sfc_var{i},'long_name',sfc_var_longname{i})
    ncwriteatt(fout,sfc_var{i},'scale_factor',sfc_scale_factor(i))
    ncwriteatt(fout,sfc_var{i},'add_offset',sfc_offset(i));
end

for i=1: length(atm_var)
    ncwriteatt(fout,atm_var{i},'units',atm_var_units{i})
    ncwriteatt(fout,atm_var{i},'long_name',atm_var_longname{i})
    ncwriteatt(fout,atm_var{i},'scale_factor',atm_scale_factor(i))
    ncwriteatt(fout,atm_var{i},'add_offset',atm_offset(i));
end

