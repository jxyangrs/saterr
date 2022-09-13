function [lat,lon,atm_pres1D,atm_t,atm_q,atm_crwc,atm_cswc,atm_clwc,atm_ciwc,atm_cc,sfc_pres,sfc_u10,sfc_v10,sfc_skt,sfc_sst] = ucar_clw_read_era5_ana_pl_37_sfc_umd(inpath,infile)
% write nc files w/ cloud info
% 
% Input:
%       e.g. era5_ana_pl_37_sfc_umd_2019060100.nc
% 
% Output:
%       lat,            latitude (up-down)                              [721,1]  90:-0.25:-90 (0.25 degree grid)
%       lon,            longitude                                       [1440,1] 0:0.25:359.75 
%       atm_pres1D,     atm pressure (Pa),                              [layer(up-down),1]/[37] 
%       atm_t,          temperature (K),                                [lon,lat,layer]
%       atm_q,          specific humidity (kg kg^-1),                   [lon,lat,layer]
%       atm_crwc,       specific rain water content (kg kg^-1),         [lon,lat,layer]
%       atm_cswc,       specific snow water content (kg kg^-1),         [lon,lat,layer]
%       atm_clwc,       specific cloud liquid water content (kg kg^-1), [lon,lat,layer]
%       atm_ciwc,       specific cloud ice water content (kg kg^-1),    [lon,lat,layer]
%       atm_cc,         cloud cover (ranging [0,1]),                    [lon,lat,layer,ndatenum]
%       sfc_pres,       sfc pressure (Pa),                              [lon,lat]
%       sfc_u10,        sfc 10-m ws U (m/s),                            [lon,lat]
%       sfc_v10,        sfc 10-m ws V (m/s),                            [lon,lat]
%       sfc_skt,        sfc skin temperature,                           [lon,lat]
%       sfc_sst,        sea surface temperature,                        [lon,lat]
% 
% Note:
%       pressure 37-layer mbar [1;2;3;5;7;10;20;30;50;70;100;125;150;175;200;225;250;300;350;400;450;500;550;600;650;700;750;775;800;825;850;875;900;925;950;975;1000]
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 02/13/2020: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 09/19/2021: add cloud

fin = [inpath,'/',infile];

lat = ncread(fin,'lat');
lon = ncread(fin,'lon');
atm_pres1D = ncread(fin,'atm_pres1D');
sfc_pres = ncread(fin,'sfc_pres');
sfc_u10 = ncread(fin,'sfc_u10');
sfc_v10 = ncread(fin,'sfc_v10');
sfc_skt = ncread(fin,'sfc_skt');
sfc_sst = ncread(fin,'sfc_sst');
atm_t = ncread(fin,'atm_t');
atm_q = ncread(fin,'atm_q');
atm_crwc = ncread(fin,'atm_crwc');
atm_cswc = ncread(fin,'atm_cswc');
atm_clwc = ncread(fin,'atm_clwc');
atm_ciwc = ncread(fin,'atm_ciwc');
atm_cc = ncread(fin,'atm_cc');





