function [lat,lon,atm_t,atm_q,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst] = ec_read_era5_ana_ml_137_sfc_umd(inpath,infile)
% read ERA5 ana at model level atmosphere (137-level, 138 interface) and surface; netcdf file
% 
% Output:
%       lat,            latitude (up-down)          [721,1]  90:-0.25:-90 (0.25 degree grid)
%       lon,            longitude                   [1440,1] 0:0.25:359.75 
%       atm_t,          temperature (K),            [lon,lat(north-south),layer(top-down)]
%       atm_q,          specific humidity (kg kg^-1)[lon,lat,layer],    having negative value from ECMWF
%       sfc_pres,       sfc pressure (Pa),          [lon,lat]
%       sfc_u10,        sfc 10m ws U (m/s),         [lon,lat]
%       sfc_v10,        sfc 10m ws V (m/s),         [lon,lat]
%       sfc_skt,        sfc skin temperature (K),   [lon,lat]
%       sfc_sst,        sea surface temperature (K),[lon,lat]
% 
% Note:
%       Per ECMWF, level is between interface, https://rda.ucar.edu/datasets/ds627.0/docs/Eta_coordinate/
% 
%       In CRTM, there is layer=level of ECMWF, level=interface
%       MiRS use this code and average level pressure for layer pressure
% 
%      2 Pa to surface
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/12/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/12/2020: monthly directory

% read
lat = ncread([inpath,infile],'lat');
lon = ncread([inpath,infile],'lon');

atm_t = ncread([inpath,infile],'atm_t');
atm_q = ncread([inpath,infile],'atm_q');

sfc_pres = ncread([inpath,infile],'sfc_pres');
sfc_u10 = ncread([inpath,infile],'sfc_u10');
sfc_v10 = ncread([inpath,infile],'sfc_v10');
sfc_skt = ncread([inpath,infile],'sfc_skt');
sfc_sst = ncread([inpath,infile],'sfc_sst');

% convert
lat = double(lat);
lon = double(lon);

% anomaly data
idx = atm_q<0;
atm_q(idx) = 0;

