function saterr_imp_prof_read4singleorbit
% loading profile info for one single orbit
%   profile info can come from model or reanalysis
%
% Input:
%       satellite geometry and profiles from reanalysis
%
% Output:
%       Prof.atm_pres,      pressure (mb),              [altitude(top-down),1]/[altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_tmp,       temperature (K),            [altitude(top-down),1]/[altitude(top-down),crosstrack,alongtrack]
%       Prof.atm_q,         specific humidity (kg/kg),  [altitude(top-down),1]/[altitude(top-down),crosstrack,alongtrack]
% 
% Description:
%
% written by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 12/01/2019: determining scan geometry from observations
% revised by John Xun Yang, University of Maryland, jxyang@umd.edu, or johnxun@umich.edu, 03/01/2020: enabling reanalysis

global Rad Orbit Prof

% ===================================================
%% simulation
% ===================================================
switch Prof.type
    case {'US_Standard_Atmosphere','Tropical','Midlatitude_Summer','Midlatitude_Winter','Subarctic_Summer','Subarctic_Winter'}
        n1 = Rad.ind_CT_num(1);
        ind_startend = Rad.alongtrack_orbit_ind_startend(Rad.norbit,:);
        n2 = ind_startend(2) - ind_startend(1) + 1;
        
        [atm_pres,atm_tmp,atm_H20_mr] = atm_6prof('US_Standard_Atmosphere','H2O');
        atm_H20_mr = atm_H20_mr*1e-3; % kg/kg
        atm_q = humconvert('MR2SH',atm_H20_mr);
        
        Prof.atm_pres = atm_pres;     % pressure (mb),                [altitude,1], unit (K)
        Prof.atm_tmp = atm_tmp;       % temperature (K),              [altitude,1], unit (K)
        Prof.atm_q = atm_q;           % specific humidity (kg/kg),    [altitude,1 ], unit (kg/kg)
        
    case {'customize'}
        
    case {'reanalysis'}
        % saterr_set_path_scheme.m
        % Prof.ana.name = Path.ana.path;
        % Prof.ana.path = Path.ana.name;
        
        
        % -------------------------
        % loading observational data
        % -------------------------
        inpath = [pathin_root,'/',Path.date.ndatestr(iday,1:4),'/',Path.date.ndatestr(iday,:),'/'];
        infile = files_daily(ifile).name;
        disp(infile)
        
        
        % -----------------------------
        % load profiles and satellite geo
        % -----------------------------
        opt_infile = 1; % 1=MAT, 2=binary
        switch opt_infile
            case 1
                [npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
                    fov_lat,fov_lon,fov_eia,fov_azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_q_level,landseafrac] = prof_read_4sim_mat(inpath,infile);
            case 2
                [npixel,nlevel,nchannel,ncrosstrack,nalongtrack,...
                    fov_lat,fov_lon,fov_eia,fov_azm,scanangle,sc_h,sc_lat,sc_lon,sfc_tmp,sfc_ws,atm_pres_interface,atm_pres_level,atm_tmp_level,atm_q_level,landseafrac] = prof_read_4sim_bin(inpath,infile);
        end
        
        [n1,n2,n3] = size(fov_eia);
        
        % -----------------------------
        % profile
        % -----------------------------
        Prof.atm_pres = atm_pres_level;
        Prof.atm_tmp = atm_tmp_level;
        Prof.atm_q = atm_q_level;
        Prof.sfc_tmp = sfc_tmp;
        Prof.sfc_ws = sfc_ws;
        Prof.landseafrac = landseafrac;
        
    otherwise
        error('Prof.type is wrong')
        
end

