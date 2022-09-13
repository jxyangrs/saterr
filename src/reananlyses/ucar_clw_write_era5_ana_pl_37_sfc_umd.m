function ucar_clw_write_era5_ana_pl_37_sfc_umd(outpath,outfile, lat,lon,atm_pres1D,atm_t,atm_q,atm_crwc,atm_cswc,atm_clwc,atm_ciwc,atm_cc,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst)
% write netcdf file including both atmosphere and surface
% 
% Input/Output:
%   e.g. era5_37_2019060100_umd.nc
%   either 37 or 91 layers
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
%       outfile = era5_umd_l37_2018013100.nc
% 
% Note:
%       ncwrite does auto conversion for datatype (e.g. double to int16)
%       in presence of scale_factor,add_offset, ncwrite does conversion with them; 
%       overrange is not allowed
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/15/2020: adaptive scale factor
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/19/2021: add cloud

% ===========================================================
% check
% ===========================================================
% setting
var_basic            = {'lat','lon','atm_pres1D'};
var_basic_longname   = {'latitude','longitude','atmospheric pressure level (37)'};
var_basic_units      = {'degrees','degrees','millibar'};
var_basic_datatype   = {'single','single','single'};
sfc_var              = {'sfc_pres','sfc_u10','sfc_v10','sfc_skt','sfc_sst'};
sfc_var_longname     = {'surface pressure','surface 10-m wind speed U','surface 10-m wind speed V','surface skin temperature','sea surface temperature'};
sfc_var_units        = {'Pa','m/s','m/s','K','K'};
sfc_var_datatype     = {'int16','int16','int16','int16','int16'};
atm_var              = {'atm_t','atm_q','atm_crwc','atm_cswc','atm_clwc','atm_ciwc','atm_cc'};
atm_var_longname     = {'atmospheric air temperature','atmospheric specific humidity','specific rain water content','specific snow water content','specific cloud liquid water content','specific cloud ice water content','cloud cover'};
atm_var_units        = {'K','kg/kg','kg/kg','kg/kg','kg/kg','kg/kg','(0-1)'};
atm_var_datatype     = {'int16','int16','int16','int16','int16','int16','int16'};

[n1,n2,n3] = size(atm_t);

% ===========================================================
% calculate scale_factor and add_offset
% ===========================================================
% setting
fillvalue_int16 = -32767;

num_range = [-32767+2,32767-2]; % for int16, extra number to prevent overrange

scale_factor_sfc = [];
add_offset_sfc = [];
for i=1: length(sfc_var)
    eval(['x=',sfc_var{i},';']);
    data_range = [min(x(:)),max(x(:))];
    [scale_factor,add_offset] = scaleoffset(num_range,data_range);
    scale_factor_sfc(i) = scale_factor;
    add_offset_sfc(i) = add_offset;
end

scale_factor_atm = [];
add_offset_atm= [];
for i=1: length(atm_var)
    eval(['x=',atm_var{i},';']);
    data_range = [min(x(:)),max(x(:))];
    [scale_factor,add_offset] = scaleoffset(num_range,data_range);
    scale_factor_atm(i) = scale_factor;
    add_offset_atm(i) = add_offset;
end

% ===========================================================
% write
% ===========================================================

% -------------------------
% clear
% -------------------------
fout = [outpath,'/',outfile];
if exist(fout,'file')
    delete(fout)
end

% -------------------------
% create
% -------------------------

% basic variables
nccreate(fout,'lon','Dimensions',{'Lon',n1},'Datatype',var_basic_datatype{1});
nccreate(fout,'lat','Dimensions',{'Lat',n2},'Datatype',var_basic_datatype{2});
nccreate(fout,'atm_pres1D','Dimensions',{'Level',n3},'Datatype',var_basic_datatype{3});

% variables to convert
for i=1: length(sfc_var)
    nccreate(fout,sfc_var{i},'Dimensions',{'Lon',n1,'Lat',n2},'Datatype',sfc_var_datatype{i},'FillValue',fillvalue_int16,'DeflateLevel',5);
end

for i=1: length(atm_var)
    nccreate(fout,atm_var{i},'Dimensions',{'Lon',n1,'Lat',n2,'Level',n3},'Datatype',atm_var_datatype{i},'FillValue',fillvalue_int16,'DeflateLevel',5);
end
% for i=1: length(sfc_var)
%     nccreate(fout,sfc_var{i},'Dimensions',{'Lon',n1,'Lat',n2},'Datatype',sfc_var_datatype{i},'FillValue',fillvalue_int16);
% end
% 
% for i=1: length(atm_var)
%     nccreate(fout,atm_var{i},'Dimensions',{'Lon',n1,'Lat',n2,'Level',n3},'Datatype',atm_var_datatype{i},'FillValue',fillvalue_int16);
% end
% -------------------------
% add attributes of units
% -------------------------
for i=1: length(var_basic)
    ncwriteatt(fout,var_basic{i},'units',var_basic_units{i})
    ncwriteatt(fout,var_basic{i},'long_name',var_basic_longname{i})
end
for i=1: length(sfc_var)
    ncwriteatt(fout,sfc_var{i},'units',sfc_var_units{i})
    ncwriteatt(fout,sfc_var{i},'long_name',sfc_var_longname{i})
end

for i=1: length(atm_var)
    ncwriteatt(fout,atm_var{i},'units',atm_var_units{i})
    ncwriteatt(fout,atm_var{i},'long_name',atm_var_longname{i})
end

% -------------------------
% add attributes of scale_factor and add_offset
% -------------------------
for i=1: length(sfc_var)
    ncwriteatt(fout,sfc_var{i},'scale_factor',scale_factor_sfc(i));
    ncwriteatt(fout,sfc_var{i},'add_offset',add_offset_sfc(i));
end

for i=1: length(atm_var)
    ncwriteatt(fout,atm_var{i},'scale_factor',scale_factor_atm(i));
    ncwriteatt(fout,atm_var{i},'add_offset',add_offset_atm(i));
end

% -------------------------
% write variables
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


