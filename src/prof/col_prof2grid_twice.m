function [sfc_pres,sfc_tmp_skin,sfc_ws,atm_pres_level,atm_pres_layer,atm_tmp,atm_humspc] = col_prof2grid_twice(inlat,inlon,...    
    aux_latgeo,aux_longeo,aux_sfc_tmp_skin,aux_sfc_ws,aux_sfc_pres,... % surface
    aux_atm_pres_level,aux_atm_pres_layer,aux_atm_tmp_layer,aux_atm_q_layer) % atmosphere
% collocation for profiles by reducing duplication first
%   Reducing duplication saves RAM
% 
% Input:
%       lat,                  satellite     [m1,1]
%       lon,                  satellite     [m1,1] ranging [0,360)/[-180,180]
%       aux_latgeo,           gridded lat   [n1,1]
%       aux_longeo,           gridded lon   [n2,1] ranging [0,360)/[-180,180]
%       aux_sfc_tmp_skin,     Kelvin,       [n1,n2]
%       aux_sfc_ws,           m/s,          [n1,n2]
%       aux_sfc_pres,         Pa,           [n1,n2]
%       aux_atm_pres_level,   Pa,           [n1,n2,n3+1]
%       aux_atm_pres_layer,   Pa,           [n1,n2,n3]
%       aux_atm_tmp_layer,    Kelvin,       [n1,n2,n3]
%       aux_atm_q_layer,      kg/kg,        [n1,n2,n3]
% 
% Output:
%       sfc_pres,             Kelvin,       [1,m1]
%       sfc_tmp_skin,         Kelvin,       [1,m1]
%       sfc_ws,               m/s,          [1,m1]
%       atm_pres_layer,       Pa,           [n3,m1]
%       atm_pres_level,       Pa,           [n3,m1]
%       atm_tmp,              Kelvin,       [n3,m1]
%       atm_humspc,           kg/kg,        [n3,m1]
% 
% Description:
%       lon and aux_longeo should have the same range
% 
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 10/22/2019: original code
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 11/05/2019: collocation twice to save RAM

% ---------------------------
% reduce grid duplication
% ---------------------------
% grid lat lon
[idxuniqgeo,idxallgeo] = col_uniquegrid(inlat,inlon,aux_latgeo,aux_longeo);
inlat = inlat(idxuniqgeo);
inlon = inlon(idxuniqgeo);

% ---------------------------
% allocate geo field profiles to each grid
% ---------------------------
[atm_pres_level,atm_pres_layer,atm_tmp,atm_humspc,sfc_tmp_skin,sfc_ws,sfc_pres] = ...
    col_prof2grid(inlat,inlon,aux_latgeo,aux_longeo,...
    aux_atm_pres_level,aux_atm_pres_layer,aux_atm_tmp_layer,aux_atm_q_layer,aux_sfc_tmp_skin,aux_sfc_ws,aux_sfc_pres);

% ---------------------------
% transform order back to that of observation geo
% ---------------------------
sfc_pres = sfc_pres(idxallgeo);
sfc_tmp_skin = sfc_tmp_skin(idxallgeo);
sfc_ws = sfc_ws(idxallgeo);
atm_pres_layer = atm_pres_layer(:,idxallgeo);
atm_pres_level = atm_pres_level(:,idxallgeo);
atm_tmp = atm_tmp(:,idxallgeo);
atm_humspc = atm_humspc(:,idxallgeo);
